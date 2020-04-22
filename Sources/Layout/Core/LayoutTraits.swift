import CoreGraphics
import Misc
import Wrappers

public struct LayoutTraits {
  var _traits: [Int: LayoutTraits] = [:]

  public var proposedSize: CGSize

  public var origin: CGPoint = .zero

  @DelayedMutable
  public var dimensions: ViewDimensions

  public init(proposedSize: CGSize) {
    self.proposedSize = proposedSize
  }

  public subscript (index: Int) -> LayoutTraits {
    get {
      _traits[index] ?? fatalError("trait not initialized")
    }
    set {
      _traits[index] = newValue
    }
  }

  public mutating func align(
    with parentDimensions: ViewDimensions,
    using alignment: Alignment
  ) {
    let hGuide = alignment.horizontal
    origin.x = parentDimensions[hGuide] - dimensions[hGuide]
    let vGuide = alignment.vertical
    origin.y = parentDimensions[vGuide] - dimensions[vGuide]
  }

  public func rect(at origin: CGPoint) -> CGRect {
    let finalOrigin = CGPoint(
      x: origin.x + self.origin.x,
      y: origin.y + self.origin.y
    )
    return CGRect(origin: finalOrigin, size: CGSize(dimensions))
  }
}
