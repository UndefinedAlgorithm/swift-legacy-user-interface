@testable import Wrappers
import XCTest

final class DelayedMutableCase: XCTestCase {
  func test_init() {
    let sut = DelayedMutable<Int>()
    XCTAssertTrue(sut._value == .none)
  }

  func test_initialization() {
    var sut = DelayedMutable<Int>()
    XCTAssertTrue(sut._value == .none)
    sut.wrappedValue = 42
    XCTAssertTrue(sut._value == 42)
  }

  func test_isInitialized() {
    var sut = DelayedMutable<Int>()
    XCTAssertFalse(sut.isInitialized)
    sut.wrappedValue = 42
    XCTAssertTrue(sut.isInitialized)
  }

  func test_reset() {
    var sut = DelayedMutable<Int>()
    sut.wrappedValue = 42
    sut.reset()
    XCTAssertTrue(sut._value == .none)
  }
}
