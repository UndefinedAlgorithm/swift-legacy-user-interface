import CoreGraphics

public struct VerticalAlignment: Hashable {
  let key: AlignmentKey

  public init(_ id: AlignmentID.Type) {
    let bits = unsafeBitCast(id as Any.Type, to: UInt.self) + 1
    self.key = AlignmentKey(bits: bits)
  }
}

extension VerticalAlignment {
  enum Top: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      0
    }
  }

  public static let top = VerticalAlignment(Top.self)

  enum Center: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context.height / 2
    }
  }

  public static let center = VerticalAlignment(Center.self)

  enum Bottom: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context.height
    }
  }

  public static let bottom = VerticalAlignment(Bottom.self)

  enum FirstTextBaseline: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context.height
    }
  }

  public static let firstTextBaseline
    = VerticalAlignment(FirstTextBaseline.self)

  enum LastTextBaseline: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context.height
    }
  }

  public static let lastTextBaseline
    = VerticalAlignment(LastTextBaseline.self)
}
