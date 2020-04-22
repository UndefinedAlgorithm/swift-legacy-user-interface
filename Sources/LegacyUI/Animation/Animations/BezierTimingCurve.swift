import CoreGraphics

// FIXME: Make this type `internal` again.
public enum BezierTimingCurve: Equatable {
  case easeInOut
  case easeIn
  case easeOut
  case linear
  // TODO: Rename this properly
  case timingCurve(
    controlPoint1: CGPoint,
    controlPoint2: CGPoint
  )
}
