import CoreGraphics

public struct HorizontalAlignment: Hashable {
  let key: AlignmentKey

  public init(_ id: AlignmentID.Type) {
    let bits = unsafeBitCast(id as Any.Type, to: UInt.self)
    self.key = AlignmentKey(bits: bits)
  }
}

extension HorizontalAlignment {
  enum Leading: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      0
    }
  }

  public static let leading = HorizontalAlignment(Leading.self)

  enum Center: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context.width / 2
    }
  }

  public static let center = HorizontalAlignment(Center.self)

  enum Trailing: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context.width
    }
  }

  public static let trailing = HorizontalAlignment(Trailing.self)
}
