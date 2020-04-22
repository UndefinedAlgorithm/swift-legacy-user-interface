// FIXME: Make this type `internal` again.
public enum AnyAnimation: _Animation {
  case bezierAnimation(BezierAnimation)
  case springAnimation(SpringAnimation)
  case fluidSpringAnimation(FluidSpringAnimation)

  public init(_ animation: BezierAnimation) {
    self = .bezierAnimation(animation)
  }

  public init(_ animation: SpringAnimation) {
    self = .springAnimation(animation)
  }

  public init(_ animation: FluidSpringAnimation) {
    self = .fluidSpringAnimation(animation)
  }
}
