public enum Axis: Int8, CaseIterable {
  case horizontal = 0
  case vertical   = 1

  public struct Set: OptionSet {
    public let rawValue: Int8

    public init(rawValue: Int8) {
      self.rawValue = rawValue
    }

    public static let horizontal = Axis.Set(rawValue: 1 << 0)
    public static let vertical   = Axis.Set(rawValue: 1 << 1)
  }
}
