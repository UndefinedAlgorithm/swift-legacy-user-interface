//import RxExtension
//import Wrappers
//
//extension Environment {
//  enum _ObservableObjectKey<Object>:
//    EnvironmentKey
//    where
//    Object: ObservableObject
//  {
//    static var defaultValue: Object? {
//      .none
//    }
//  }
//
//  @propertyWrapper
//  public struct ObservedObject<Object>:
//    EnvironmentNode
//    where
//    Object: ObservableObject
//  {
//    @dynamicMemberLookup
//    public struct Wrapper {
//      let _object: Object
//
//      init(_object: Object) {
//        self._object = _object
//      }
//
//      public subscript<Subject>(
//        dynamicMember keyPath: ReferenceWritableKeyPath<Object, Subject>
//      ) -> Binding<Subject> {
//        Binding(
//          get: { [object = _object] in
//            object[keyPath: keyPath]
//          },
//          set: { [object = _object] newValue, transaction in
//            withTransaction(transaction) {
//              object[keyPath: keyPath] = newValue
//            }
//          }
//        )
//      }
//    }
//
//    @DelayedMutable
//    var _object: Object
//
//    @DelayedMutable
//    var _subscription: AnyDisposable
//
//    public var wrappedValue: Object {
//      _object
//    }
//
//    public var projectedValue: Wrapper {
//      Wrapper(_object: _object)
//    }
//
//    public init() {}
//
//    public mutating func update(environment: Environment) {
//      if let object = environment[_ObservableObjectKey<Object>.self] {
//        _object = object
//        _subscription = object
//          .objectWillChange
//          .mapToVoid()
//          .subscribe()
//          .wrapIntoAnyDisposable()
//      }
//    }
//  }
//
//  public func observedObject<Object>(
//    _ object: Object
//  ) -> Environment where Object: ObservableObject {
//    var environment = self
//    environment[_ObservableObjectKey<Object>.self] = object
//    return environment
//  }
//}
