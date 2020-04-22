@testable import Layout
import Wrappers
import XCTest

final class HStackLayoutCase: XCTestCase {
  func test_single_compliant_child() {
    let expectedRect = CGRect(x: 0, y: 0, width: 40, height: 40)

    var traits = LayoutTraits(proposedSize: CGSize(width: 40, height: 40))

    var localSut = HStackLayout
      .init {
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == expectedRect)
        }
      }
      .frame(width: 40, height: 40)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_single_compliant_child_with_overridden_alignment() {
    let expectedRect = CGRect(x: 0, y: 10, width: 40, height: 40)

    var traits = LayoutTraits(proposedSize: CGSize(width: 40, height: 40))

    var localSut = HStackLayout
      .init(alignment: .top) {
        SimpleCompliantLayout
          .init { rect in
            XCTAssertTrue(rect == expectedRect)
          }
          .alignmentGuide(.top) { _ in
            -10
          }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: 0, width: 40, height: 50))
        }
      )
      .frame(width: 40, height: 40, alignment: .top)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_two_compliant_children() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 40, height: 40))

    var localSut = HStackLayout
      .init {
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 20, height: 40))
        }
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 20, y: 0, width: 20, height: 40))
        }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: 0, width: 40, height: 40))
        }
      )
      .frame(width: 40, height: 40, alignment: .top)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_complex_layout_1() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 120, height: 100))

    var localSut = HStackLayout
      .init(alignment: .top, spacing: 10) {
        SimpleCompliantLayout
          .init { rect in
            // 🟩 bound
            XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 5, height: 40))
          }
          .frame(minWidth: 4, maxWidth: 5)
          .frame(height: 40)
          .alignmentGuide(.top) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟪 fixed
            XCTAssertTrue(rect == CGRect(x: 15, y: 0, width: 0, height: 0))
          }
          .frame(width: 0, height: 0)
          .alignmentGuide(.top) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟧 unbound
            XCTAssertTrue(rect == CGRect(x: 25, y: 0, width: 5, height: 40))
          }
          .frame(height: 40)
          .alignmentGuide(.top) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟥 boundFrom
            XCTAssertTrue(rect == CGRect(x: 40, y: 0, width: 5, height: 40))
          }
          .frame(minWidth: 5)
          .frame(height: 40)
          .alignmentGuide(.top) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟦 fixed
            XCTAssertTrue(rect == CGRect(x: 55, y: 10, width: 20, height: 40))
          }
          .frame(width: 20, height: 40)
          .alignmentGuide(.top) { _ in
            -10
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟨 fixed
            XCTAssertTrue(rect == CGRect(x: 85, y: 10, width: 20, height: 40))
          }
          .frame(width: 20, height: 40)
          .alignmentGuide(.top) { _ in
            -10
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟥 boundUpTo
            XCTAssertTrue(rect == CGRect(x: 115, y: 0, width: 5, height: 40))
          }
          .frame(maxWidth: 5)
          .frame(height: 40)
          .alignmentGuide(.top) { _ in
            0
          }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: 0, width: 120, height: 50))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_complex_layout_2() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = HStackLayout
      .init(alignment: .top, spacing: 0) {
        SimpleCompliantLayout
          .init { rect in
            XCTAssertTrue(rect == CGRect(x: 0, y: -25, width: 50, height: 100))
          }
          .alignmentGuide(.top) { _ in
            50
          }

        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 50, y: 25, width: 50, height: 100))
        }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: -25, width: 100, height: 150))
        }
      )
      .frame(width: 100, height: 100)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  // This layout is broken in SwiftUI for some reason: FB7635852
  func test_complex_layout_3() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 60, height: 100))

    var localSut = HStackLayout
      .init(alignment: .top, spacing: 0) {
        SimpleCompliantLayout
          .init { rect in
            XCTAssertTrue(rect == CGRect(x: 0, y: -25, width: 20, height: 100))
          }
          .alignmentGuide(.top) { _ in
            50
          }

        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 20, y: 25, width: 20, height: 100))
        }

        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 40, y: 25, width: 20, height: 100))
        }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: -25, width: 60, height: 150))
        }
      )
      .frame(width: 60, height: 100)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }
}
