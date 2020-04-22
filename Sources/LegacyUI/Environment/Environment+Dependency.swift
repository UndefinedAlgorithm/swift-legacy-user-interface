import Wrappers

extension Environment {
  enum _DependencyKey<Value>: EnvironmentKey {
    static var defaultValue: Value? {
      .none
    }
  }

  @propertyWrapper
  public struct Dependency<Value>: EnvironmentNode {
    @DelayedMutable
    var _value: Value

    public var wrappedValue: Value {
      _value
    }

    public init() {}

    public mutating func update(environment: Environment) {
      if let value = environment[_DependencyKey<Value>.self] {
        _value = value
      }
    }
  }

  public func dependency<Value>(_ value: Value) -> Environment {
    var environment = self
    environment[_DependencyKey<Value>.self] = value
    return environment
  }
}
