@testable import Layout
import Wrappers
import XCTest

final class LayoutBuilderCase: XCTestCase {
  func test_supported_syntax() {
    struct Foo<T> {
      init(@LayoutBuilder _ closure: () -> [AnyLayout<T>]) {
        _ = closure()
      }

      // FIXME: Remove this when `LayoutBuilder` is fully fixed.
      init<R>(
        @LayoutBuilder _ closure: () -> R
      ) where R: Layout, R.Content == T {
        self.init {
          [closure().wrapIntoAnyLayout()]
        }
      }
    }

    _ = Foo {
      SimpleCompliantLayout { _ in }
    }

    _ = Foo {
      SimpleCompliantLayout { _ in }
      SimpleCompliantLayout { _ in }
    }

    _ = Foo {
      if true {
        SimpleCompliantLayout { _ in }
      }
      SimpleCompliantLayout { _ in }
    }
  }
}
