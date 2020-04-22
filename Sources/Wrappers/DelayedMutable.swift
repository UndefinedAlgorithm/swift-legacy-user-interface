import Misc

@propertyWrapper
public struct DelayedMutable<Value> {
  var _value: Value?

  public init() {
    _value = nil
  }

  public var wrappedValue: Value {
    get {
      _value ?? fatalError("property accessed before being initialized")
    }
    set {
      _value = newValue
    }
  }

  public var isInitialized: Bool {
    _value != nil
  }

  /// "Reset" the wrapper so it can be initialized again.
  public mutating func reset() {
    _value = nil
  }
}
