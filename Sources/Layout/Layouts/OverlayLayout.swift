import CoreGraphics

public struct OverlayLayout<Current, Overlay>:
  Layout
  where
  Current: Layout,
  Overlay: Layout,
  Current.Content == Overlay.Content
{
  public typealias Content = Current.Content

  var current: Current
  var overlay: Overlay

  let alignment: Alignment

  public func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    // 1. Propose size to main child.
    var currentTraits = LayoutTraits(proposedSize: traits.proposedSize)
    current.build(&currentTraits)

    // 2. Respect child's size and compute own size.
    let size = CGSize(currentTraits.dimensions)
    sanitizeSize(size)

    var overlayTraits = LayoutTraits(proposedSize: size)
    overlay.build(&overlayTraits)

    overlayTraits.align(with: currentTraits.dimensions, using: alignment)

    traits[0] = currentTraits
    traits[1] = overlayTraits

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

    overlay.layout(in: traits[1].rect(at: rect.origin), using: &traits[1])
    current.layout(in: rect, using: &traits[0])
  }
}

extension Layout {
  /// Returns a layout that shows `overlay` in front of `self`.
  public func overlay<Overlay>(
    _ overlay: Overlay,
    alignment: Alignment = .center
  ) -> OverlayLayout<Self, Overlay>
    where
    Overlay: Layout,
    Overlay.Content == Content
  {
    OverlayLayout(
      current: self,
      overlay: overlay,
      alignment: alignment
    )
  }
}
