//import CoreGraphics
//
//struct AspectRatioLayout {
//
//}
//
//extension Layout {
//  public func aspectRatio(
//    _ aspectRatio: CGFloat? = nil,
//    contentMode: ContentMode
//  ) -> AspectRatioLayout<Self> {
//    AspectRatioLayout(aspectRatio: aspectRatio, contentMode: contentMode)
//  }
//
//  public func aspectRatio(
//    _ aspectRatio: CGSize,
//    contentMode: ContentMode
//  ) -> AspectRatioLayout<Self> {
//    aspectRatio(
//      aspectRatio.width / aspectRatio.height,
//      contentMode: contentMode
//    )
//  }
//
//  public func scaledToFit() -> AspectRatioLayout<Self> {
//    aspectRatio(contentMode: .fit)
//  }
//
//  public func scaledToFill() -> AspectRatioLayout<Self> {
//    aspectRatio(contentMode: .fill)
//  }
//}
