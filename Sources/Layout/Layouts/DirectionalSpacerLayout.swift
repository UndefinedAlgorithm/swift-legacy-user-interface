import CoreGraphics

struct DirectionalSpacerLayout<Content>: Layout {
  let axis: Axis
  var minLength: CGFloat

  init(axis: Axis, minLength: CGFloat = 0) {
    self.axis = axis
    self.minLength = minLength
  }

  func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    let size: CGSize
    switch axis {
    case .horizontal:
      size = CGSize(
        width: max(minLength, traits.proposedSize[axis]),
        height: 0
      )
    case .vertical:
      size = CGSize(
        width: 0,
        height: max(minLength, traits.proposedSize[axis])
      )
    }
    traits.dimensions = ViewDimensions(size: size)
  }

  mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    let size: CGSize
    switch axis {
    case .horizontal:
      size = CGSize(width: traits.dimensions[axis], height: 0)
    case .vertical:
      size = CGSize(width: 0, height: traits.dimensions[axis])
    }
    precondition(rect.size == size)
  }
}
