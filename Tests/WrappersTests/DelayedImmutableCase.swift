@testable import Wrappers
import XCTest

final class DelayedImmutableCase: XCTestCase {
  func test_init() {
    let sut = DelayedImmutable<Int>()
    XCTAssertTrue(sut._value == .none)
  }

  func test_initialization() {
    var sut = DelayedImmutable<Int>()
    XCTAssertTrue(sut._value == .none)
    sut.wrappedValue = 42
    XCTAssertTrue(sut._value == 42)
  }

  func test_isInitialized() {
    var sut = DelayedImmutable<Int>()
    XCTAssertFalse(sut.isInitialized)
    sut.wrappedValue = 42
    XCTAssertTrue(sut.isInitialized)
  }
}
