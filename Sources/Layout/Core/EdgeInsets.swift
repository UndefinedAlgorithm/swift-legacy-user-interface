import CoreGraphics

public struct EdgeInsets: Equatable {
  public var top: CGFloat
  public var leading: CGFloat
  public var bottom: CGFloat
  public var trailing: CGFloat

  public init(
    top: CGFloat,
    leading: CGFloat,
    bottom: CGFloat,
    trailing: CGFloat
  ) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }

  public init() {
    self.init(all: 0)
  }

  init(all length: CGFloat) {
    self.init(top: length, leading: length, bottom: length, trailing: length)
  }
}

#if canImport(UIKit)
import UIKit

extension UIEdgeInsets {
  public init(_ insets: EdgeInsets) {
    self.init(
      top: insets.top,
      left: insets.leading,
      bottom: insets.bottom,
      right: insets.trailing
    )
  }
}
#endif
