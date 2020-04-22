import CoreGraphics

public struct Alignments: Equatable {
  var _values: [AlignmentKey: CGFloat]

  var keys: Set<AlignmentKey> {
    Set(_values.keys)
  }

  public init() {
    self._values = [:]
  }

  public subscript (guide: HorizontalAlignment) -> CGFloat? {
    get {
      _values[guide.key]
    }
    set {
      self[guide.key] = newValue
    }
  }

  public subscript (guide: VerticalAlignment) -> CGFloat? {
    get {
      _values[guide.key]
    }
    set {
      self[guide.key] = newValue
    }
  }

  mutating func merge(_ other: Alignments, offset: CGPoint = .zero) {
    other._values.forEach { element in
      let value: CGFloat
      if element.key.representsHorizontalAlignment {
        value = offset.x
      } else {
        value = offset.y
      }
      self[element.key] = element.value + value
    }
  }

  subscript (key: AlignmentKey) -> CGFloat? {
    get {
      _values[key]
    }
    set {
      _values[key] = newValue
    }
  }
}
