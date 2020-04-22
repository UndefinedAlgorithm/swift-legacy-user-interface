@testable import Layout
import Wrappers
import XCTest

final class ViewDimensionsCase: XCTestCase {
  @DelayedMutable
  var sut: ViewDimensions

  override func tearDown() {
    _sut.reset()
    super.tearDown()
  }

  func test_init() {
    let size = CGSize(width: 1, height: 2)
    sut = ViewDimensions(size: size)
    XCTAssertTrue(sut.size == size)
    XCTAssertTrue(sut.width == size.width)
    XCTAssertTrue(sut.height == size.height)
  }
}
