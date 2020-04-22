#if canImport(UIKit)
@testable import Layout
import UIKit
import Wrappers
import XCTest

final class UIViewLayoutCase: XCTestCase {
  func test_UISwitch() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = UIViewLayout(UISwitch())
      .background(
        CompliantLayout<UIView> { rect in
          if #available(iOS 11, *) {
            XCTAssertTrue(rect.size == CGSize(width: 51, height: 31))
          }
        }
      )
      .frame(width: 100, height: 100, alignment: .topLeading)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_UIView() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = UIViewLayout(UIView())
      .background(
        CompliantLayout<UIView> { rect in
          if #available(iOS 11, *) {
            XCTAssertTrue(rect.size == CGSize(width: 100, height: 100))
          }
        }
      )
      .frame(width: 100, height: 100, alignment: .topLeading)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }
}
#endif
