public enum Edge: Int8, CaseIterable {
  case top
  case leading
  case bottom
  case trailing

  public struct Set: OptionSet {
    public static let top      = Edge.Set(rawValue: 1 << 0)
    public static let leading  = Edge.Set(rawValue: 1 << 1)
    public static let bottom   = Edge.Set(rawValue: 1 << 2)
    public static let trailing = Edge.Set(rawValue: 1 << 4)

    public static let all: Edge.Set = [.top, .leading, .bottom, .trailing]
    public static let horizontal: Edge.Set = [.leading, .trailing]
    public static let vertical: Edge.Set = [.top, .bottom]

    public let rawValue: Int8

    public init(rawValue: Int8) {
      self.rawValue = rawValue
    }

    public init(_ edge: Edge) {
      switch edge {
      case .top:
        self = .top
      case .leading:
        self = .leading
      case .bottom:
        self = .bottom
      case .trailing:
        self = .trailing
      }
    }
  }

  public init?(rawValue: Int8) {
    switch rawValue {
    case 0:
      self = .top
    case 1:
      self = .leading
    case 2:
      self = .bottom
    case 3:
      self = .trailing
    default:
      return nil
    }
  }
}
