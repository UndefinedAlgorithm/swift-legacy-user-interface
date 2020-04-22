
public protocol EnvironmentKey {
  associatedtype Value
  static var defaultValue: Value { get }
}
