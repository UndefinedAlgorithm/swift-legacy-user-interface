@testable import Layout
import Wrappers
import XCTest

final class FlexFrameLayoutCase: XCTestCase {
  let proposedSize = CGSize(width: 100, height: 100)

  @DelayedMutable
  var sut: FlexFrameLayout<SimpleCompliantLayout>

  @DelayedMutable
  var traits: LayoutTraits

  override func setUp() {
    super.setUp()
    traits = LayoutTraits(proposedSize: proposedSize)
  }

  override func tearDown() {
    _sut.reset()
    _traits.reset()
    super.tearDown()
  }

  func test_minWidth_propose_less() {
    let expectedSize = CGSize(width: 10, height: 100)

    var localTraits = LayoutTraits(proposedSize: CGSize(width: 5, height: 100))

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(minWidth: 10)

    sut.build(&localTraits)

    let rect = localTraits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &localTraits)
  }

  func test_minWidth_propose_more() {
    let expectedSize = CGSize(width: 100, height: 100)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(minWidth: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_maxWidth_propose_less() {
    let expectedSize = CGSize(width: 5, height: 100)

    var localTraits = LayoutTraits(proposedSize: CGSize(width: 5, height: 100))

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(maxWidth: 10)

    sut.build(&localTraits)

    let rect = localTraits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &localTraits)
  }

  func test_maxWidth_propose_more() {
    let expectedSize = CGSize(width: 10, height: 100)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(maxWidth: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_minHeight_propose_less() {
    let expectedSize = CGSize(width: 100, height: 10)

    var localTraits = LayoutTraits(proposedSize: CGSize(width: 100, height: 5))

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(minHeight: 10)

    sut.build(&localTraits)

    let rect = localTraits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &localTraits)
  }

  func test_minHeight_propose_more() {
    let expectedSize = CGSize(width: 100, height: 100)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(minHeight: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_maxHeight_propose_less() {
    let expectedSize = CGSize(width: 100, height: 5)

    var localTraits = LayoutTraits(proposedSize: CGSize(width: 100, height: 5))

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(maxHeight: 10)

    sut.build(&localTraits)

    let rect = localTraits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &localTraits)
  }

  func test_maxHeight_propose_more() {
    let expectedSize = CGSize(width: 100, height: 10)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(maxHeight: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_bound_width_propose_ideal() {
    let expectedSize = CGSize(width: 50, height: 100)

    var localTraits = LayoutTraits(proposedSize: expectedSize)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(minWidth: 10, maxWidth: 100)

    sut.build(&localTraits)

    let rect = localTraits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &localTraits)
  }

  func test_bound_height_propose_ideal() {
    let expectedSize = CGSize(width: 100, height: 50)

    var localTraits = LayoutTraits(proposedSize: expectedSize)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(minHeight: 10, maxHeight: 100)

    sut.build(&localTraits)

    let rect = localTraits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &localTraits)
  }
}
