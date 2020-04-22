@propertyWrapper
public struct Binding<Value> {
  public var transaction = Transaction()
  
  let _get: () -> Value
  let _set: (Value, Transaction) -> Void
  
  public var wrappedValue: Value {
    get {
      _get()
    }
    nonmutating set {
      _set(newValue, transaction)
    }
  }

  public var projectedValue: Binding<Value> {
    self
  }
  
  public init(
    get: @escaping () -> Value,
    set: @escaping (Value, Transaction) -> Void
  ) {
    _get = get
    _set = set
  }
  
  public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
    self.init(
      get: get,
      set: { newValue, _ in
        // Wrap into the transaction closure but don't call
        // `withTransaction` here. It's up to the user or other
        // API to decide.
        set(newValue)
      }
    )
  }
}

extension Binding {
  public static func constant(_ value: Value) -> Binding {
    Binding(
      get: {
        value
      },
      set: { _ in
        assertionFailure("cannot set a constant")
      }
    )
  }
}

extension Binding {
  /// Creates an instance by projecting the base value to an optional value.
  public init<V>(_ base: Binding<V>) where Value == V? {
    self.init(
      get: {
        .some(base.wrappedValue)
      },
      set: { newValue in
        // FIXME: Check if this is the correct behavior in SwiftUI.
        if let value = newValue {
          base.wrappedValue = value
        }
      }
    )
  }
  
  /// Creates an instance by projecting the base optional value to its
  /// unwrapped value, or returns `nil` if the base value is `nil`.
  public init?(_ base: Binding<Value?>) {
    if base.wrappedValue == nil {
      return nil
    }
    self.init(
      get: {
        base.wrappedValue!
      },
      set: { newValue in
        base.wrappedValue = newValue
      }
    )
  }

  public init<V>(_ base: Binding<V>) where Value == AnyHashable, V: Hashable {
    self.init(
      get: {
        base.wrappedValue
      },
      set: { newValue in
        // FIXME: Check if this is the correct behavior in SwiftUI.
        if let value = newValue.base as? V {
          base.wrappedValue = value
        }
      }
    )
  }
}

extension Binding {
  public func transaction(_ transaction: Transaction) -> Binding {
    var binding = self
    binding.transaction = transaction
    return binding
  }
  
  public func animation(_ animation: Animation?) -> Binding {
    var binding = self
    binding.transaction.animation = animation
    return binding
  }
}
