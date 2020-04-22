struct AlignmentKey: Hashable {
  let bits: UInt

  var representsHorizontalAlignment: Bool {
    bits.isMultiple(of: 2)
  }
}
