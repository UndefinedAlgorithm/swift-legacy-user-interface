import CoreGraphics

public struct Animation: Equatable {
  // FIXME: Remote `public` modifier from these properties.
  public let base: AnyAnimation
  public let delay: Double
  public let speed: Double
  public let transition: AnimationTransition?
  
  init(
    _base base: AnyAnimation,
    delay: Double = 0,
    speed: Double = 1,
    transition: AnimationTransition? = .none
  ) {
    self.base = base
    self.delay = delay
    self.speed = speed
    self.transition = transition
  }

  // Returns an animation that has its delay added delay. For example,
  // if you had noDelayAnimation.delay(1).delay(1), it would be a 2 seconds
  // delay.
  public func delay(_ delay: Double) -> Animation {
    Animation(
      _base: base,
      delay: self.delay + delay,
      speed: speed,
      transition: transition
    )
  }

  // Returns an animation that has its speed multiplied by speed. For example,
  // if you had oneSecondAnimation.speed(0.25), it would be at 25% of its
  // normal speed, so you would have an animation that would last 4 seconds.
  public func speed(_ speed: Double) -> Animation {
    Animation(
      _base: base,
      delay: delay,
      speed: self.speed * speed,
      transition: transition
    )
  }

  public func transition(_ transition: AnimationTransition?) -> Animation {
    Animation(
      _base: base,
      delay: delay,
      speed: speed,
      transition: transition
    )
  }
  
//  public func repeatCount(
//    _ repeatCount: Int,
//    autoreverses: Bool = true
//  ) -> Animation {
//    let animation = RepeatAnimation(
//      animation: base,
//      repeatCount: repeatCount,
//      autoreverses: autoreverses
//    )
//    let base = AnyAnimation(animation)
//    return Animation(base: base)
//  }
//
//  public func repeatForever(autoreverses: Bool = true) -> Animation {
//    let animation = RepeatAnimation(
//      animation: base,
//      repeatCount: .none,
//      autoreverses: autoreverses
//    )
//    let base = AnyAnimation(animation)
//    return Animation(base: base)
//  }
}

extension Animation {
  public static let `default`: Animation = .easeInOut
  
  public static func easeInOut(duration: Double) -> Animation {
    let animation = BezierAnimation(duration: duration, curve: .easeInOut)
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static var easeInOut: Animation {
    easeInOut(duration: 0.35)
  }
  
  public static func easeIn(duration: Double) -> Animation {
    let animation = BezierAnimation(duration: duration, curve: .easeIn)
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static var easeIn: Animation {
    easeIn(duration: 0.35)
  }
  
  public static func easeOut(duration: Double) -> Animation {
    let animation = BezierAnimation(duration: duration, curve: .easeOut)
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static var easeOut: Animation {
    easeOut(duration: 0.35)
  }
  
  public static func linear(duration: Double) -> Animation {
    let animation = BezierAnimation(duration: duration, curve: .linear)
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static var linear: Animation {
    linear(duration: 0.35)
  }

  public static func timingCurve(
    _ c0x: Double,
    _ c0y: Double,
    _ c1x: Double,
    _ c1y: Double,
    duration: Double = 0.35
  ) -> Animation {
    let curve = BezierTimingCurve.timingCurve(
      controlPoint1: CGPoint(x: c0x, y: c0y),
      controlPoint2: CGPoint(x: c1x, y: c1y)
    )
    let animation = BezierAnimation(duration: duration, curve: curve)
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static func interpolatingSpring(
    mass: Double = 1.0,
    stiffness: Double,
    damping: Double,
    initialVelocity: Double = 0.0
  ) -> Animation {
    let animation = SpringAnimation(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
      initialVelocity: _Velocity(valuePerSecond: initialVelocity)
    )
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static func spring(
    response: Double = 0.55,
    dampingFraction: Double = 0.825//,
//    blendDuration: Double = 0
  ) -> Animation {
    let animation = FluidSpringAnimation(
      response: response,
      dampingFraction: dampingFraction//,
//      blendDuration: blendDuration
    )
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
  
  public static func interactiveSpring(
    response: Double = 0.15,
    dampingFraction: Double = 0.86//,
//    blendDuration: Double = 0.25
  ) -> Animation {
    let animation = FluidSpringAnimation(
      response: response,
      dampingFraction: dampingFraction//,
//      blendDuration: blendDuration
    )
    let base = AnyAnimation(animation)
    return Animation(_base: base)
  }
}
