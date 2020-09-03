import CoreGraphics
import Wrappers
import Misc

struct DimensionsCache {
  enum Key: Equatable {
    case any
    case zero
    case infinity
  }

  struct Value {
    var proposedSize: ProposedSize
    var dimensions: ViewDimensions
  }

  @DelayedMutable
  var _any: Value

  @DelayedMutable
  var _infinity: Value

  @DelayedMutable
  var _zero: Value

  let axis: Axis

  init(axis: Axis) {
    self.axis = axis
  }

  subscript (key: Key) -> Value {
    get {
      switch key {
      case .any:
        return _any
      case .zero:
        return _zero
      case .infinity:
        return _infinity
      }
    }
    set {
      let proposedSpace = space(in: newValue.proposedSize, onAxis: axis)
      switch key {
      case .any:
        _any = newValue
      case .zero:
        precondition(proposedSpace == 0)
        _zero = newValue
      case .infinity:
        precondition(proposedSpace == .infinity)
        _infinity = newValue
      }
    }
  }

  var flexibilityLevel: FlexibilityLevel {
    // Extract values of interest for the correct axis.
    let zeroValue: CGFloat
    let infinityValue: CGFloat
    switch axis {
    case .horizontal:
      zeroValue = self[.zero].dimensions.width
      infinityValue = self[.infinity].dimensions.width
    case .vertical:
      zeroValue = self[.zero].dimensions.height
      infinityValue = self[.infinity].dimensions.height
    }
    // Compute the level based on the range values.
    switch (zeroValue, infinityValue) {
    case (0, .infinity):
      return .unbound
    case (let lhs, .infinity) where 0 < lhs && lhs < .infinity:
      return .boundFrom
    case (0, let rhs) where 0 < rhs && rhs < .infinity:
      return .boundUpTo
    case (let lhs, let rhs) where 0 < lhs && lhs < rhs && rhs < .infinity:
      return .bound
    case (let lhs, let rhs) where lhs == rhs:
      return .fixed
    default:
      fatalError("illegal range (\(zeroValue), \(infinityValue))")
    }
  }
}

func space(in proposedSize: ProposedSize, onAxis axis: Axis) -> CGFloat {
  switch axis {
  case .horizontal:
    return proposedSize.width
  case .vertical:
    return proposedSize.height
  }
}

func space(in size: CGSize, onAxis axis: Axis) -> CGFloat {
  switch axis {
  case .horizontal:
    return size.width
  case .vertical:
    return size.height
  }
}


struct FlexibilityIndex: Equatable {
  let flexibilityLevel: FlexibilityLevel
  let index: Int
}

public struct ProposedSize: Hashable {
  public var width: CGFloat
  public var height: CGFloat

  public init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }

  subscript (axis: Axis) -> CGFloat {
    get {
      switch axis {
      case .horizontal:
        return width
      case .vertical:
        return height
      }
    }
    set {
      switch axis {
      case .horizontal:
        width = newValue
      case .vertical:
        height = newValue
      }
    }
  }
}

extension CGSize {
  public init(_ size: ProposedSize) {
    self.init(width: size.width, height: size.height)
  }

  subscript (axis: Axis) -> CGFloat {
    get {
      switch axis {
      case .horizontal:
        return width
      case .vertical:
        return height
      }
    }
    set {
      switch axis {
      case .horizontal:
        width = newValue
      case .vertical:
        height = newValue
      }
    }
  }
}

extension CGPoint {
  subscript (axis: Axis) -> CGFloat {
    get {
      switch axis {
      case .horizontal:
        return x
      case .vertical:
        return y
      }
    }
    set {
      switch axis {
      case .horizontal:
        x = newValue
      case .vertical:
        y = newValue
      }
    }
  }
}
