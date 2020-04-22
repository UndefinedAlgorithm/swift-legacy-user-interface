public struct Transaction {
  public var animation: Animation?
  public var disablesAnimations: Bool

  public init(animation: Animation?) {
    self.animation = animation
    self.disablesAnimations = false
  }
  
  public init() {
    self.init(animation: .none)
  }
}
