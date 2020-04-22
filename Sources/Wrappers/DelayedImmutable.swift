import Misc

@propertyWrapper
public struct DelayedImmutable<Value> {
  var _value: Value?

  public init() {
    _value = nil
  }

  public var wrappedValue: Value {
    get {
      _value ?? fatalError("property accessed before being initialized")
    }
    set {
      // Perform an initialization, trap if the value is already initialized.
      if _value != nil {
        fatalError("property initialized twice")
      }
      _value = newValue
    }
  }

  public var isInitialized: Bool {
    _value != nil
  }
}
