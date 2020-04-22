import CoreGraphics

public struct FrameLayout<Child>: Layout where Child: Layout {
  public typealias Content = Child.Content

  var child: Child
  let width: CGFloat?
  let height: CGFloat?
  let alignment: Alignment

  init(child: Child, width: CGFloat?, height: CGFloat?, alignment: Alignment) {
    self.child = child
    self.width = width
    self.height = height
    self.alignment = alignment
  }

  public func build(_ traits: inout LayoutTraits) {
    // Limit the proposed size if needed.
    var size = traits.proposedSize
    if let width = width {
      size.width = width
    }
    if let height = height {
      size.height = height
    }
    sanitizeSize(size)

    // 1. Propose size to the child.
    var childTraits = LayoutTraits(proposedSize: size)
    child.build(&childTraits)

    // 2. Respect child's size and compute own size.
    size = CGSize(childTraits.dimensions)
    if let width = width {
      size.width = width
    }
    if let height = height {
      size.height = height
    }
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
    width: CGFloat? = .none,
    height: CGFloat? = .none,
    alignment: Alignment = .center
  ) -> FrameLayout<Self> {
    FrameLayout(
      child: self,
      width: width,
      height: height,
      alignment: alignment
    )
  }
}
