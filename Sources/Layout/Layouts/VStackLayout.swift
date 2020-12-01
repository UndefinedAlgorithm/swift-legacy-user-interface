import CoreGraphics
import Wrappers

public struct VStackLayout<Content>: Layout {
  var _layout: DirectionalStackLayout<Content>

  var alignment: HorizontalAlignment {
    switch _layout.alignment {
    case .vertical:
      fatalError("Impossible alignment")
    case .horizontal(let alignment):
      return alignment
    }
  }

  var spacing: CGFloat {
    _layout.spacing
  }

  var children: [AnyLayout<Content>] {
    get {
      _layout.children
    }
    set {
      _layout.children = newValue
    }
  }

  public init(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat = 0,
    @LayoutBuilder children: () -> [AnyLayout<Content>]
  ) {
    self._layout = DirectionalStackLayout(
      alignment: .horizontal(alignment),
      spacing: spacing,
      children: children
    )
  }

//  // FIXME: Remove this overload when `LayoutBuilder` is fully fixed.
//  public init<T>(
//    alignment: HorizontalAlignment = .center,
//    spacing: CGFloat = 0,
//    @LayoutBuilder children: () -> T
//  ) where T: Layout, T.Content == Content {
//    self.init(alignment: alignment, spacing: spacing) {
//      [children().wrapIntoAnyLayout()]
//    }
//  }

  public func build(_ traits: inout LayoutTraits) {
    _layout.build(&traits)
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    _layout.layout(in: rect, using: &traits)
  }
}
