public struct _Velocity<Value>: Equatable where Value: Equatable {
  public var valuePerSecond: Value
  
  public init(valuePerSecond: Value) {
    self.valuePerSecond = valuePerSecond
  }
}
extension _Velocity: Comparable where Value: Comparable {
  public static func < (lhs: _Velocity<Value>, rhs: _Velocity<Value>) -> Bool {
    lhs.valuePerSecond < rhs.valuePerSecond
  }
}

extension _Velocity: AdditiveArithmetic where Value: AdditiveArithmetic {
  public init() {
    self.init(valuePerSecond: .zero)
  }
  
  public static var zero: _Velocity {
    _Velocity(valuePerSecond: .zero)
  }
  
  public static func += (lhs: inout _Velocity, rhs: _Velocity) {
    lhs.valuePerSecond += rhs.valuePerSecond
  }
  
  public static func -= (lhs: inout _Velocity, rhs: _Velocity) {
    lhs.valuePerSecond -= rhs.valuePerSecond
  }
  
  public static func + (lhs: _Velocity, rhs: _Velocity) -> _Velocity {
    var velocity = lhs
    velocity += rhs
    return velocity
  }
  
  public static func - (lhs: _Velocity, rhs: _Velocity) -> _Velocity {
    var velocity = lhs
    velocity -= rhs
    return velocity
  }
}

extension _Velocity: VectorArithmetic where Value: VectorArithmetic {
  public mutating func scale(by rhs: Double) {
    valuePerSecond.scale(by: rhs)
  }
  
  public var magnitudeSquared: Double {
    valuePerSecond.magnitudeSquared
  }
}
