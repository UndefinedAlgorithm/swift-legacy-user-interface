public func ?? <T>(lhs: T?, rhs: @autoclosure () -> Never) -> T {
  lhs.unwrapOr(rhs())
}
