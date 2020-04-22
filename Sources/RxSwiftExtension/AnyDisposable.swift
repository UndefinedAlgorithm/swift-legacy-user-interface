/*
import RxSwift

public final class AnyDisposable: Disposable, Hashable {
  final class _DisposeBox {
    let dispose: () -> Void
    init(_ dispose: @escaping () -> Void) {
      self.dispose = dispose
    }
  }
  
  let _disposeBox: _DisposeBox
  
  public init(_ dispose: @escaping () -> Void) {
    _disposeBox = _DisposeBox(dispose)
  }
  
  public init<D>(_ disposable: D) where D: Disposable {
    _disposeBox = _DisposeBox {
      disposable.dispose()
    }
  }
  
  public func dispose() {
    _disposeBox.dispose()
  }
  
  deinit {
    dispose()
  }
  
  public static func == (lhs: AnyDisposable, rhs: AnyDisposable) -> Bool {
    lhs._disposeBox === rhs._disposeBox
  }
  
  public func hash(into hasher: inout Hasher) {
    let identifier = ObjectIdentifier(_disposeBox)
    hasher.combine(identifier)
  }
  
  public final func store<C>(in collection: inout C)
    where
    C: RangeReplaceableCollection,
    C.Element == AnyDisposable
  {
    collection.append(self)
  }
  
  public final func store(in set: inout Set<AnyDisposable>) {
    set.insert(self)
  }
  
  public final func store<Key>(
    in dictionary: inout Dictionary<Key, AnyDisposable>,
    for key: Key
  ) where Key: Hashable {
    dictionary[key] = self
  }
}
*/
