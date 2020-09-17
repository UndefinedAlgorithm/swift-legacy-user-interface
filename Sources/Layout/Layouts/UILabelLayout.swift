#if canImport(UIKit)
import UIKit

public struct UILabelLayout<View>: Layout where View: UILabel {
  public typealias Content = UIView

  public let view: View

  // FIXME: Move these into its own modifier.
  let fixedHorizontalSize: Bool
  let fixedVerticalSize: Bool

  public init(
    _ view: View,
    fixedHorizontalSize: Bool = false,
    fixedVerticalSize: Bool = false
  ) {
    self.view = view
    self.fixedHorizontalSize = fixedHorizontalSize
    self.fixedVerticalSize = fixedVerticalSize
  }

  public func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    let contentSize = view.intrinsicContentSize
    let fittingSize = view.sizeThatFits(traits.proposedSize)

    var size = traits.proposedSize
    if contentSize.width != UIView.noIntrinsicMetric {
      size.width = fittingSize.width
    }
    if contentSize.height != UIView.noIntrinsicMetric {
      size.height = fittingSize.height
    }

    if fixedHorizontalSize == false, size.width > traits.proposedSize.width {
      size.width = traits.proposedSize.width
    }
    if fixedVerticalSize == false, size.height > traits.proposedSize.height {
      size.height = traits.proposedSize.height
    }

    sanitizeSize(size)
    traits.dimensions = ViewDimensions(size: size)
  }

  public func layout(in rect: CGRect, using traits: inout LayoutTraits) {
    precondition(rect.size == CGSize(traits.dimensions))
    view.frame = rect
  }
}
#endif
