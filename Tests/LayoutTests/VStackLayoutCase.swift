@testable import Layout
import Wrappers
import XCTest

final class VStackLayoutCase: XCTestCase {
  func test_single_compliant_child() {
    let expectedRect = CGRect(x: 0, y: 0, width: 40, height: 40)

    var traits = LayoutTraits(proposedSize: CGSize(width: 40, height: 40))

    var localSut = VStackLayout
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
    let expectedRect = CGRect(x: 10, y: 0, width: 40, height: 40)

    var traits = LayoutTraits(proposedSize: CGSize(width: 40, height: 40))

    var localSut = VStackLayout
      .init(alignment: .leading) {
        SimpleCompliantLayout
          .init { rect in
            XCTAssertTrue(rect == expectedRect)
          }
          .alignmentGuide(.leading) { _ in
            -10
          }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: 0, width: 50, height: 40))
        }
      )
      .frame(width: 40, height: 40, alignment: .leading)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_two_compliant_children() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 40, height: 40))

    var localSut = VStackLayout
      .init {
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 40, height: 20))
        }
        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 0, y: 20, width: 40, height: 20))
        }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: 0, width: 40, height: 40))
        }
      )
      .frame(width: 40, height: 40, alignment: .leading)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_complex_layout_1() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 120))

    var localSut = VStackLayout
      .init(alignment: .leading, spacing: 10) {
        SimpleCompliantLayout
          .init { rect in
            // 🟩 bound
            XCTAssertTrue(rect == CGRect(x: 0, y: 0, width: 40, height: 5))
          }
          .frame(minHeight: 4, maxHeight: 5)
          .frame(width: 40)
          .alignmentGuide(.leading) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟪 fixed
            XCTAssertTrue(rect == CGRect(x: 0, y: 15, width: 0, height: 0))
          }
          .frame(width: 0, height: 0)
          .alignmentGuide(.leading) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟧 unbound
            XCTAssertTrue(rect == CGRect(x: 0, y: 25, width: 40, height: 5))
          }
          .frame(width: 40)
          .alignmentGuide(.leading) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟥 boundFrom
            XCTAssertTrue(rect == CGRect(x: 0, y: 40, width: 40, height: 5))
          }
          .frame(minHeight: 5)
          .frame(width: 40)
          .alignmentGuide(.leading) { _ in
            0
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟦 fixed
            XCTAssertTrue(rect == CGRect(x: 10, y: 55, width: 40, height: 20))
          }
          .frame(width: 40, height: 20)
          .alignmentGuide(.leading) { _ in
            -10
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟨 fixed
            XCTAssertTrue(rect == CGRect(x: 10, y: 85, width: 40, height: 20))
          }
          .frame(width: 40, height: 20)
          .alignmentGuide(.leading) { _ in
            -10
          }

        SimpleCompliantLayout
          .init { rect in
            // 🟥 boundUpTo
            XCTAssertTrue(rect == CGRect(x: 0, y: 115, width: 40, height: 5))
          }
          .frame(maxHeight: 5)
          .frame(width: 40)
          .alignmentGuide(.leading) { _ in
            0
          }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: 0, y: 0, width: 50, height: 120))
        }
      )

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_complex_layout_2() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = VStackLayout
      .init(alignment: .leading, spacing: 0) {
        SimpleCompliantLayout
          .init { rect in
            XCTAssertTrue(rect == CGRect(x: -25, y: 0, width: 100, height: 50))
          }
          .alignmentGuide(.leading) { _ in
            50
          }

        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 25, y: 50, width: 100, height: 50))
        }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: -25, y: 0, width: 150, height: 100))
        }
      )
      .frame(width: 100, height: 100)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  // This layout is broken in SwiftUI for some reason: FB7635852
  func test_complex_layout_3() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 60))

    var localSut = VStackLayout
      .init(alignment: .leading, spacing: 0) {
        SimpleCompliantLayout
          .init { rect in
            XCTAssertTrue(rect == CGRect(x: -25, y: 0, width: 100, height: 20))
          }
          .alignmentGuide(.leading) { _ in
            50
          }

        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 25, y: 20, width: 100, height: 20))
        }

        SimpleCompliantLayout { rect in
          XCTAssertTrue(rect == CGRect(x: 25, y: 40, width: 100, height: 20))
        }
      }
      .background(
        SimpleCompliantLayout { rect in
          XCTAssert(rect == CGRect(x: -25, y: 0, width: 150, height: 60))
        }
      )
      .frame(width: 100, height: 60)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }
}
