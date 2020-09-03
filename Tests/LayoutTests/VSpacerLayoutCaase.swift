@testable import Layout
import Wrappers
import XCTest

fileprivate typealias SimpleVSpacerLayout = VSpacerLayout<Never>

final class VSpacerLayoutCase: XCTestCase {
  func test_init_and_default_minLenght() {
    let proposedSize = CGSize(width: 20, height: 10)

    var sut = SimpleVSpacerLayout()
    var traits = LayoutTraits(proposedSize: proposedSize)
    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == CGSize(width: 0, height: 10))
    sut.layout(in: rect, using: &traits)
  }

  func test_init_and_greater_minLenght() {
    let proposedSize = CGSize(width: 20, height: 10)

    var sut = SimpleVSpacerLayout(minLength: 15)
    var traits = LayoutTraits(proposedSize: proposedSize)
    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == CGSize(width: 0, height: 15))
    sut.layout(in: rect, using: &traits)
  }
}
