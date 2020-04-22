@propertyWrapper
public struct Clamp<Value> where Value: Comparable {
  public var value: Value
  public let range: ClosedRange<Value>

  public init(wrappedValue: Value, range: ClosedRange<Value>) {
    self.value = Self._clamp(wrappedValue, to: range)
    self.range = range
  }

  public var wrappedValue: Value {
    get {
      value
    }
    set {
      value = Self._clamp(newValue, to: range)
    }
  }
}

extension Clamp {
  static func _clamp(
    _ value: Value,
    to range: ClosedRange<Value>
  ) -> Value {
    if value < range.lowerBound {
      return range.lowerBound
    } else if value > range.upperBound {
      return range.upperBound
    } else {
      return value
    }
  }
}
