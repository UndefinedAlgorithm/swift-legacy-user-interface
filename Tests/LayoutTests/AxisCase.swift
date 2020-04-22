@testable import Layout
import Wrappers
import XCTest

final class AxisCase: XCTestCase {
  @DelayedMutable
  var sut: Axis

  override func tearDown() {
    _sut.reset()
    super.tearDown()
  }

  func test_raw_values() {
    sut = .horizontal
    XCTAssertTrue(sut.rawValue == 0)
    sut = .vertical
    XCTAssertTrue(sut.rawValue == 1)
  }

  func test_axis() {
    XCTAssertTrue(Axis.allCases == [.horizontal, .vertical])
  }

  func test_axis_set_raw_values() {
    var set: Axis.Set = .horizontal
    XCTAssertTrue(set.rawValue == 0x1)
    set = .vertical
    XCTAssertTrue(set.rawValue == 0x2)
    set = [.horizontal, .vertical]
    XCTAssertTrue(set.rawValue == 0x3)
  }
}
