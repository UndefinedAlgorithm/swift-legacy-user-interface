import CoreGraphics

func sanitizeSize(_ size: CGSize) {
  precondition(size.width >= 0 && size.height >= 0)
}
