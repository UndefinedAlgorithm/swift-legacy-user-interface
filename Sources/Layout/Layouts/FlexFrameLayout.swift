import CoreGraphics
import Wrappers

// FIXME: Add `idealWidth` and `idealHeight`.
public struct FlexFrameLayout<Child>: Layout where Child: Layout {
  public typealias Content = Child.Content

  let minWidth: CGFloat?
  let maxWidth: CGFloat?
  let minHeight: CGFloat?
  let maxHeight: CGFloat?
  let alignment: Alignment
  var child: Child

  init(
    minWidth: CGFloat?,
    maxWidth: CGFloat?,
    minHeight: CGFloat?,
    maxHeight: CGFloat?,
    alignment: Alignment,
    child: Child
  ) {
    func areInNondecreasingOrder(_ min: CGFloat?, _ max: CGFloat?) -> Bool {
      let min = min ?? -.infinity
      let max = max ?? min
      return min <= max
    }

    let widthCondition = areInNondecreasingOrder(minWidth, maxWidth)
    let heightCondition = areInNondecreasingOrder(minHeight, maxHeight)
    precondition(widthCondition && heightCondition)

    self.minWidth = minWidth
    self.maxWidth = maxWidth
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.alignment = alignment
    self.child = child
  }

  public func build(_ traits: inout LayoutTraits) {
    // FIXME: Use property syntax when possible.
    var _width = Clamp(
      wrappedValue: traits.proposedSize.width,
      range: max(0, (minWidth ?? 0)) ... max(0, (maxWidth ?? .infinity))
    )
    var width: CGFloat {
      get {
        _width.wrappedValue
      }
      set {
        _width.wrappedValue = newValue
      }
    }

    // FIXME: Use property syntax when possible.
    var _height = Clamp(
      wrappedValue: traits.proposedSize.height,
      range: max(0, (minHeight ?? 0)) ... max(0, (maxHeight ?? .infinity))
    )
    var height: CGFloat {
      get {
        _height.wrappedValue
      }
      set {
        _height.wrappedValue = newValue
      }
    }

    var size = CGSize(width: width, height: height)
    sanitizeSize(size)

    // 1. Propose size to the child.
    var childTraits = LayoutTraits(proposedSize: size)
    child.build(&childTraits)

    // 2. Respect child's size and compute own size.
    let childSize = CGSize(childTraits.dimensions)
    width = childSize.width
    height = childSize.height

    size = CGSize(width: width, height: height)
    sanitizeSize(size)

    // 3. Generate own dimensions.
    var dimensions = ViewDimensions(size: size)
    let hDefault = dimensions[alignment.horizontal]
    let vDefault = dimensions[alignment.vertical]

    // 4. Align child in own coordinate space.
    childTraits.align(with: dimensions, using: alignment)

    // Merge alignments from child.
    dimensions.alignments
      .merge(childTraits.dimensions.alignments, offset: childTraits.origin)
    // Force certain alignments to have default values.
    dimensions.alignments[alignment.horizontal] = hDefault
    dimensions.alignments[alignment.vertical] = vDefault
    traits.dimensions = dimensions

    // Save child traits.
    traits[0] = childTraits
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))
    child.layout(in: traits[0].rect(at: rect.origin), using: &traits[0])
  }
}

extension Layout {
  public func frame(
    minWidth: CGFloat? = .none,
    maxWidth: CGFloat? = .none,
    minHeight: CGFloat? = .none,
    maxHeight: CGFloat? = .none,
    alignment: Alignment = .center
  ) -> FlexFrameLayout<Self> {
    FlexFrameLayout(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      alignment: alignment,
      child: self
    )
  }
}
