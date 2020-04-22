import Dispatch

final class TransactionStack {
  static let shared = TransactionStack(_transactions: [])
  
  var _transactions: [Transaction] = []
  
  init(_transactions transactions: [Transaction]) {
    dispatchPrecondition(condition: .onQueue(.main))
    _transactions = transactions
  }
  
  // The system can peek into the stack and obtain a transaction to produce
  // implicit animations during the next layout pass.
  func peek() -> Transaction? {
    dispatchPrecondition(condition: .onQueue(.main))
    return _transactions.last
  }
}

extension TransactionStack {
  func _push(_ transaction: Transaction) {
    dispatchPrecondition(condition: .onQueue(.main))
    _transactions.append(transaction)
  }
  
  @discardableResult
  func _pop() -> Transaction? {
    dispatchPrecondition(condition: .onQueue(.main))
    return _transactions.popLast()
  }
}

public func withTransaction<Result>(
  _ transaction: Transaction,
  _ body: () throws -> Result
) rethrows -> Result {
  dispatchPrecondition(condition: .onQueue(.main))
  let stack = TransactionStack.shared
  stack._push(transaction)
  // We use defer so that the transaction is popped from the stack on success
  // or on failure of the `body` call.
  defer {
    assert(stack._pop() != nil, "desynchronized stack")
  }
  return try body()
}

public func withAnimation<Result>(
  _ animation: Animation? = .default,
  _ body: () throws -> Result
) rethrows -> Result {
  // Not sure if we should create a new transaction, or rather peek into the
  // stack make a copy of the transaction from the stack, mutate its animation
  // and forward that to `withTransaction`.
  //
  // ```swift
  // var transaction = Transaction(animation: .default)
  // transaction.disablesAnimations = true
  // withTransaction(transaction) {
  //   withAnimation(.spring()) {
  //     /* perform actions */
  //
  //     // does the nested transaction have `disablesAnimations` set
  //     // to `true` in real SwiftUI at this point?
  //   }
  // }
  // ```
  let transaction = Transaction(animation: animation)
  return try withTransaction(transaction, body)
}
