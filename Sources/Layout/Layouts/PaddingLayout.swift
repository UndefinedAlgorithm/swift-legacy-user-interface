import CoreGraphics
import Wrappers

public struct PaddingLayout<Child>: Layout where Child: Layout {
  public typealias Content = Child.Content

  let insets: EdgeInsets
  var child: Child

  init(insets: EdgeInsets, child: Child) {
    self.insets = insets
    self.child = child
  }

  public func build(_ traits: inout LayoutTraits) {
    let hInsets = insets.leading + insets.trailing
    let vInsets = insets.top + insets.bottom

    // FIXME: Use property syntax when possible.
    var _width = Clamp(
      wrappedValue: traits.proposedSize.width - hInsets,
      range: 0 ... .infinity
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
      wrappedValue: traits.proposedSize.height - vInsets,
      range: 0 ... .infinity
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
    width = childSize.width + hInsets
    height = childSize.height + vInsets

    size = CGSize(width: width, height: height)
    sanitizeSize(size)

    // 3. Generate own dimensions.
    var dimensions = ViewDimensions(size: size)

    // 4. Align child in own coordinate space.
    childTraits.origin = CGPoint(x: insets.leading, y: insets.top)

    // Merge alignments from child.
    dimensions.alignments
      .merge(childTraits.dimensions.alignments, offset: childTraits.origin)

    // Save own dimensions.
    traits.dimensions = dimensions

    // Save child traits.
    traits[0] = childTraits
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))

    let childRect = traits[0].rect(at: rect.origin)
    precondition(rect.contains(childRect))
    child.layout(in: childRect, using: &traits[0])
  }
}

extension Layout {
  public func padding(_ insets: EdgeInsets) -> PaddingLayout<Self> {
    PaddingLayout(insets: insets, child: self)
  }

  public func padding(
    _ edges: Edge.Set = .all,
    _ length: CGFloat = 0
  ) -> PaddingLayout<Self> {
    func inset(forEdge edge: Edge) -> CGFloat {
      if edges.contains(Edge.Set(edge)) {
        return length
      } else {
        return 0
      }
    }

    let insets = EdgeInsets(
      top: inset(forEdge: .top),
      leading: inset(forEdge: .leading),
      bottom: inset(forEdge: .bottom),
      trailing: inset(forEdge: .trailing)
    )
    return PaddingLayout(insets: insets, child: self)
  }

  public func padding(_ length: CGFloat) -> PaddingLayout<Self> {
    padding(.all, length)
  }
}
