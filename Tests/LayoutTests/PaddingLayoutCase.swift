@testable import Layout
import Wrappers
import XCTest

final class PaddingLayoutCase: XCTestCase {
  func test_inset_leading() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 200, height: 200))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 10, y: 0, width: 100, height: 100))
      }
      .frame(width: 100, height: 100, alignment: .topLeading)
      .padding(.leading, 10)
      .background(
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 110, height: 100))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_inset_trailing() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 200, height: 200))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 100, height: 100))
      }
      .frame(width: 100, height: 100, alignment: .topLeading)
      .padding(.trailing, 10)
      .background(
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 110, height: 100))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_inset_top() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 200, height: 200))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 0, y: 10, width: 100, height: 100))
      }
      .frame(width: 100, height: 100, alignment: .topLeading)
      .padding(.top, 10)
      .background(
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 100, height: 110))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_inset_bottom() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 200, height: 200))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 100, height: 100))
      }
      .frame(width: 100, height: 100, alignment: .topLeading)
      .padding(.bottom, 10)
      .background(
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 100, height: 110))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_inset_all() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 200, height: 200))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 10, y: 10, width: 100, height: 100))
      }
      .frame(width: 100, height: 100, alignment: .topLeading)
      .padding(10)
      .background(
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 120, height: 120))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  // TODO: Check negative insets behavior.
}
