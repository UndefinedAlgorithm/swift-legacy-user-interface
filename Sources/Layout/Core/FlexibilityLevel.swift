enum FlexibilityLevel: UInt8, Hashable, Comparable {
  case unbound   = 0 // Takes any proposed size
  case boundFrom = 1 // Has minimum size
  case boundUpTo = 2 // Has maximum size
  case bound     = 3 // Has both minimum & maximum size (unequal)
  case fixed     = 4 // Ignores proposed size

  static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
