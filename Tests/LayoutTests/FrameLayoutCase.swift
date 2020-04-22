@testable import Layout
import Wrappers
import XCTest

final class FrameLayoutCase: XCTestCase {
  let proposedSize = CGSize(width: 100, height: 100)

  @DelayedMutable
  var sut: FrameLayout<SimpleCompliantLayout>

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

  func test_fixed_width() {
    let expectedSize = CGSize(width: 10, height: 100)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(width: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_fixed_height() {
    let expectedSize = CGSize(width: 100, height: 10)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(height: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_fixed_size() {
    let expectedSize = CGSize(width: 10, height: 10)

    sut = SimpleCompliantLayout
      .init { rect in
        XCTAssertTrue(rect.size == expectedSize)
      }
      .frame(width: 10, height: 10)

    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == expectedSize)
    sut.layout(in: rect, using: &traits)
  }

  func test_nested_fixed_frames() {
    let origins: [Alignment: CGPoint] = [
      .topLeading: .zero,
      .top: CGPoint(x: 45, y: 0),
      .topTrailing: CGPoint(x: 90, y: 0),
      .leading: CGPoint(x: 0, y: 45),
      .center: CGPoint(x: 45, y: 45),
      .trailing: CGPoint(x: 90, y: 45),
      .bottomLeading: CGPoint(x: 0, y: 90),
      .bottom: CGPoint(x: 45, y: 90),
      .bottomTrailing: CGPoint(x: 90, y: 90)
    ]

    for (alignment, origin) in origins {
      let expectedRect = CGRect(
        origin: origin,
        size: CGSize(width: 10, height: 10)
      )

      var localSut = SimpleCompliantLayout
        .init { rect in
          XCTAssertTrue(rect == expectedRect)
        }
        .frame(width: 10, height: 10)
        .frame(width: 100, height: 100, alignment: alignment)

      localSut.build(&traits)

      let rect = traits.rect(at: .zero)
      XCTAssertTrue(rect.size == proposedSize)
      localSut.layout(in: rect, using: &traits)
    }
  }
}
