import Wrappers

public struct Environment {
  static let _empty = Environment()

  typealias Key = ObjectIdentifier

  var _values: [Key: _Box]

  public init() {
    _values = [:]
  }

  final class _Box {
    var value: Any
    init(value: Any) {
      self.value = value
    }
  }

  public subscript<Key>(key: Key.Type) -> Key.Value where Key: EnvironmentKey {
    get {
      let identifier = ObjectIdentifier(key)
      guard
        let box = _values[identifier],
        let value = box.value as? Key.Value
      else {
        return Key.defaultValue
      }
      return value
    }
    set {
      // Extract the box from the dictionary or create a new one.
      let identifier = ObjectIdentifier(key)
      var box = _values.removeValue(forKey: identifier) ?? _Box(value: newValue)
      // Check if the box is uniquely referenced and mutate,
      // if not create a new box.
      if isKnownUniquelyReferenced(&box) {
        box.value = newValue
      } else {
        box = _Box(value: newValue)
      }
      // Inject the box back into the dictionary.
      _values[identifier] = box
    }
  }
}
