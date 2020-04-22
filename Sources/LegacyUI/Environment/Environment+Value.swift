import Wrappers

extension Environment {
  @propertyWrapper
  public struct Value<Wrapped>: EnvironmentNode {
    let _keyPath: KeyPath<Environment, Wrapped>

    var _value: Wrapped?

    public var wrappedValue: Wrapped {
      _value ?? Environment._empty[keyPath: _keyPath]
    }

    public init(_ keyPath: KeyPath<Environment, Wrapped>) {
      self._keyPath = keyPath
    }

    public mutating func update(environment: Environment) {
      _value = environment[keyPath: _keyPath]
    }
  }

  public func value<V>(
    _ keyPath: WritableKeyPath<Environment, V>,
    _ value: V
  ) -> Environment {
    var environment = self
    environment[keyPath: keyPath] = value
    return environment
  }

  public func transformValue<V>(
    _ keyPath: WritableKeyPath<Environment, V>,
    transform: @escaping (inout V) -> Void
  ) -> Environment {
    var environment = self
    var value = environment[keyPath: keyPath]
    transform(&value)
    environment[keyPath: keyPath] = value
    return environment
  }
}
