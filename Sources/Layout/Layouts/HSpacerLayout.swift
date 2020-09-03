import CoreGraphics

public struct HSpacerLayout<Content>: Layout {
  var _layout: DirectionalSpacerLayout<Content>

  public var minLength: CGFloat {
    _layout.minLength
  }

  public init(minLength: CGFloat = 0) {
    self._layout = DirectionalSpacerLayout(
      axis: .horizontal,
     minLength: minLength
    )
  }

  public func build(_ traits: inout LayoutTraits) {
    _layout.build(&traits)
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    _layout.layout(in: rect, using: &traits)
  }
}
