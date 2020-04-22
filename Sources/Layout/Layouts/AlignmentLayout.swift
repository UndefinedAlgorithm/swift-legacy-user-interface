import CoreGraphics

public struct AlignmentLayout<Child>: Layout where Child: Layout {
  public typealias Content = Child.Content

  var child: Child
  let key: AlignmentKey
  let computeValue: (ViewDimensions) -> CGFloat

  init(
    child: Child,
    guide: HorizontalAlignment,
    computeValue: @escaping (ViewDimensions) -> CGFloat
  ) {
    self.child = child
    self.key = guide.key
    self.computeValue = computeValue
  }

  init(
    child: Child,
    guide: VerticalAlignment,
    computeValue: @escaping (ViewDimensions) -> CGFloat
  ) {
    self.child = child
    self.key = guide.key
    self.computeValue = computeValue
  }

  public func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    // 1. Propose size to main child.
    var childTraits = LayoutTraits(proposedSize: traits.proposedSize)
    child.build(&childTraits)

    // 2. Respect child's size and compute own size.
    let size = CGSize(childTraits.dimensions)
    sanitizeSize(size)

    traits[0] = childTraits

    // 3. Generate own dimensions.
    var dimensions = ViewDimensions(size: size)
    dimensions.alignments.merge(childTraits.dimensions.alignments)
    dimensions.alignments[key] = computeValue(childTraits.dimensions)
    traits.dimensions = dimensions
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))
    child.layout(in: rect, using: &traits[0])
  }
}

extension Layout {
  public func alignmentGuide(
    _ guide: HorizontalAlignment,
    computeValue: @escaping (ViewDimensions) -> CGFloat
  ) -> AlignmentLayout<Self> {
    AlignmentLayout(child: self, guide: guide, computeValue: computeValue)
  }

  public func alignmentGuide(
    _ guide: VerticalAlignment,
    computeValue: @escaping (ViewDimensions) -> CGFloat
  ) -> AlignmentLayout<Self> {
    AlignmentLayout(child: self, guide: guide, computeValue: computeValue)
  }
}
