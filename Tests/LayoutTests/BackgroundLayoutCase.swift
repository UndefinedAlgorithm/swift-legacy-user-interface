@testable import Layout
import Wrappers
import XCTest

final class BackgroundLayoutCase: XCTestCase {
  func test_nested_fixed_layout() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 100, height: 100))
      }
      .frame(width: 100, height: 100)
      .background(
        SimpleCompliantLayout
        .init { rect in
          XCTAssertTrue(rect == CGRect(x: 90, y: 90, width: 10, height: 10))
        }
        .frame(width: 10, height: 10),
        alignment: .bottomTrailing
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }
}
