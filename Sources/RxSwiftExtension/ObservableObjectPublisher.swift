/*
import RxRelay
import RxSwift

public final class ObservableObjectPublisher: ObservableType {
  let _relay = PublishRelay<Void>()
  
  public typealias Element = Void
  
  public init() {}
  
  public final func subscribe<Observer>(
    _ observer: Observer
  ) -> Disposable
    where
    Observer: ObserverType,
    Observer.Element == Element
  {
    _relay.subscribe(observer)
  }
  
  public final func send() {
    _relay.accept(())
  }
}
 */
