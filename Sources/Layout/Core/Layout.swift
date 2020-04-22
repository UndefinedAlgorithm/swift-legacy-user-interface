import CoreGraphics

public protocol Layout {
  associatedtype Content

  func build(_ traits: inout LayoutTraits)

  mutating func layout(in rect: CGRect, using traits: inout LayoutTraits)
}
