import CoreGraphics

public protocol VectorArithmetic: AdditiveArithmetic {
  mutating func scale(by rhs: Double)
  var magnitudeSquared: Double { get }
}

extension Float: VectorArithmetic {
  public mutating func scale(by rhs: Double) {
    self *= Float(rhs)
  }
  
  public var magnitudeSquared: Double {
    Double(self * self)
  }
}

extension Double: VectorArithmetic {
  public mutating func scale(by rhs: Double) {
    self *= rhs
  }
  
  public var magnitudeSquared: Double {
    self * self
  }
}

extension CGFloat: VectorArithmetic {
  public mutating func scale(by rhs: Double) {
    self *= CGFloat(rhs)
  }
  
  public var magnitudeSquared: Double {
    Double(self * self)
  }
}
