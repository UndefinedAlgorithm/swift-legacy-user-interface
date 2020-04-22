import CoreGraphics

protocol _LayoutBox {
  func build(_ traits: inout LayoutTraits)

  mutating func layout(in rect: CGRect, using traits: inout LayoutTraits)
}

struct _ConcreteLayoutBox<Base>: _LayoutBox where Base: Layout {
  var _base: Base

  init(_ base: Base) {
    self._base = base
  }

  func build(_ traits: inout LayoutTraits) {
    _base.build(&traits)
  }

  mutating func layout(in rect: CGRect, using traits: inout LayoutTraits) {
    _base.layout(in: rect, using: &traits)
  }
}

public struct _AnyLayout<Content>: Layout {
  var _box: _LayoutBox

  init<T>(_ layout: T) where T: Layout, T.Content == Content {
    self._box = _ConcreteLayoutBox(layout)
  }

  public func build(_ traits: inout LayoutTraits) {
    _box.build(&traits)
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    _box.layout(in: rect, using: &traits)
  }
}

// FIXME: Exchange `_AnyLayout<Content>` with `any Layout<.Content == Content>`
// in some future Swift release.
public typealias AnyLayout<Content> = _AnyLayout<Content>

extension Layout {
  public func wrapIntoAnyLayout() -> AnyLayout<Self.Content> {
    AnyLayout(self)
  }
}
