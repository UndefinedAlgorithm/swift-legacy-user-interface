import CoreGraphics

public struct ViewDimensions: Equatable {
  var size: CGSize

  public var width: CGFloat {
    size.width
  }

  public var height: CGFloat {
    size.height
  }

  public var alignments: Alignments

  init(size: CGSize) {
    self.size = size
    self.alignments = Alignments()
  }

  public subscript (guide: HorizontalAlignment) -> CGFloat {
    self[explicit: guide] ?? alignmentID(for: guide.key).defaultValue(in: self)
  }

  public subscript (guide: VerticalAlignment) -> CGFloat {
    self[explicit: guide] ?? alignmentID(for: guide.key).defaultValue(in: self)
  }

  public subscript (explicit guide: HorizontalAlignment) -> CGFloat? {
    alignments[guide]
  }

  public subscript (explicit guide: VerticalAlignment) -> CGFloat? {
    alignments[guide]
  }

  subscript (axis: Axis) -> CGFloat {
    switch axis {
    case .horizontal:
      return width
    case .vertical:
      return height
    }
  }
}

extension CGSize {
  public init(_ dimensions: ViewDimensions) {
    self.init(width: dimensions.width, height: dimensions.height)
  }
}
