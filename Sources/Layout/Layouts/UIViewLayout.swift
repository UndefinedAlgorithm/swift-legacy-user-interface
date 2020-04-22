#if canImport(UIKit)
import UIKit

public struct UIViewLayout<View>: Layout where View: UIView {
  public typealias Content = UIView

  public let view: View

  public init(_ view: View) {
    self.view = view
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

    sanitizeSize(size)
    traits.dimensions = ViewDimensions(size: size)
  }

  public func layout(in rect: CGRect, using traits: inout LayoutTraits) {
    precondition(rect.size == CGSize(traits.dimensions))
    view.frame = rect
  }
}
#endif
