// FIXME: Make this type `internal` again.
public struct SpringAnimation: _Animation {
  public let mass: Double
  public let stiffness: Double
  public let damping: Double
  public let initialVelocity: _Velocity<Double>
}
