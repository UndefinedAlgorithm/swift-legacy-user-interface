import CoreGraphics

public protocol AlignmentID {
  static func defaultValue(in context: ViewDimensions) -> CGFloat
}

func alignmentID(for key: AlignmentKey) -> AlignmentID.Type {
  let existential: Any.Type
  if key.representsHorizontalAlignment {
    existential = unsafeBitCast(key.bits, to: Any.Type.self)
  } else {
    // Re-align misaligned pointer (implementation detail of VAlignment).
    existential = unsafeBitCast(key.bits - 1, to: Any.Type.self)
  }
  return existential as! AlignmentID.Type
}
