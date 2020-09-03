@testable import Layout
import Wrappers
import XCTest

fileprivate typealias SimpleHSpacerLayout = HSpacerLayout<Never>

final class HSpacerLayoutCase: XCTestCase {
  func test_init_and_default_minLenght() {
    let proposedSize = CGSize(width: 10, height: 20)

    var sut = SimpleHSpacerLayout()
    var traits = LayoutTraits(proposedSize: proposedSize)
    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == CGSize(width: 10, height: 0))
    sut.layout(in: rect, using: &traits)
  }

  func test_init_and_greater_minLenght() {
    let proposedSize = CGSize(width: 10, height: 20)

    var sut = SimpleHSpacerLayout(minLength: 15)
    var traits = LayoutTraits(proposedSize: proposedSize)
    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == CGSize(width: 15, height: 0))
    sut.layout(in: rect, using: &traits)
  }
}
