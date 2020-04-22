@testable import Layout
import Wrappers
import XCTest

struct CompliantLayout<Content>: Layout {
  let closure: (CGRect) -> Void

  func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)
    traits.dimensions = ViewDimensions(size: traits.proposedSize)
  }

  mutating func layout(in rect: CGRect, using traits: inout LayoutTraits) {
    precondition(rect.size == CGSize(traits.dimensions))
    closure(rect)
  }
}

typealias SimpleCompliantLayout = CompliantLayout<Never>

final class CompliantLayoutCase: XCTestCase {
  func test_init_and_final_size() {
    let proposedSize = CGSize(width: 10, height: 20)

    var sut = SimpleCompliantLayout { rect in
      XCTAssertTrue(rect.size == proposedSize)
    }
    var traits = LayoutTraits(proposedSize: proposedSize)
    sut.build(&traits)

    let rect = traits.rect(at: .zero)
    XCTAssertTrue(rect.size == proposedSize)
    sut.layout(in: rect, using: &traits)
  }
}
