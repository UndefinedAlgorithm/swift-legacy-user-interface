import CoreGraphics

extension Optional: Layout where Wrapped: Layout {
  public typealias Content = Wrapped.Content

  public func build(_ traits: inout LayoutTraits) {
    switch self {
    case .some(let layout):
      layout.build(&traits)
    case .none:
      traits.dimensions = ViewDimensions(size: .zero)
    }
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))
    if case .some(var layout) = self {
      layout.layout(in: rect, using: &traits)
      self = .some(layout)
    }
  }
}
