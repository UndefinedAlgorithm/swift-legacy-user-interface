extension Optional {
  public func unwrapOr(
    _ defaultValue: @autoclosure () throws -> Wrapped
  ) rethrows -> Wrapped {
    try self ?? defaultValue()
  }

  public func unwrapOr(_ trap: @autoclosure () -> Never) -> Wrapped {
    switch self {
    case .some(let value):
      return value
    case .none:
      trap()
    }
  }
}
