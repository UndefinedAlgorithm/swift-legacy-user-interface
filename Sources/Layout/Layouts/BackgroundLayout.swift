import CoreGraphics

public struct BackgroundLayout<Current, Background>:
  Layout
  where
  Current: Layout,
  Background: Layout,
  Current.Content == Background.Content
{
  public typealias Content = Current.Content

  var current: Current
  var background: Background

  let alignment: Alignment

  public func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    // 1. Propose size to main child.
    var currentTraits = LayoutTraits(proposedSize: traits.proposedSize)
    current.build(&currentTraits)

    // 2. Respect child's size and compute own size.
    let size = CGSize(currentTraits.dimensions)
    sanitizeSize(size)

    var backgroundTraits = LayoutTraits(proposedSize: size)
    background.build(&backgroundTraits)

    backgroundTraits.align(with: currentTraits.dimensions, using: alignment)

    traits[0] = currentTraits
    traits[1] = backgroundTraits

    // 3. Generate own dimensions.
    var dimensions = ViewDimensions(size: size)
    dimensions.alignments.merge(currentTraits.dimensions.alignments)
    traits.dimensions = dimensions
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))
    precondition(rect.size == CGSize(traits[0].dimensions))

    background.layout(in: traits[1].rect(at: rect.origin), using: &traits[1])
    current.layout(in: rect, using: &traits[0])
  }
}

extension Layout {
  /// Returns a layout that shows `self` in front of `background`.
  public func background<Background>(
    _ background: Background,
    alignment: Alignment = .center
  ) -> BackgroundLayout<Self, Background>
    where
    Background: Layout,
    Background.Content == Content
  {
    BackgroundLayout(
      current: self,
      background: background,
      alignment: alignment
    )
  }
}
