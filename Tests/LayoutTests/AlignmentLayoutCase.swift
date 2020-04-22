@testable import Layout
import Wrappers
import XCTest

final class AlignmentLayoutCase: XCTestCase {
  func test_overriding_top_alignment_once() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 40, y: -10, width: 20, height: 10))
      }
      .frame(width: 20, height: 10)
      .alignmentGuide(.top) { d in
        d[.bottom]
      }
      .frame(width: 100, height: 100, alignment: .top)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }

  func test_overriding_top_alignment_twice() {
    var traits = LayoutTraits(proposedSize: CGSize(width: 100, height: 100))

    var localSut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect == CGRect(x: 40, y: -20, width: 20, height: 10))
      }
      .frame(width: 20, height: 10)
      .alignmentGuide(.top) { d in
        d[.bottom]
      }
      .alignmentGuide(.top) { d in
        d[.trailing]
      }
      .frame(width: 100, height: 100, alignment: .top)

    localSut.build(&traits)
    localSut.layout(in: traits.rect(at: .zero), using: &traits)
  }
}
