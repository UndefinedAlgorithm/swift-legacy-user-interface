public protocol EnvironmentNode: Node {
  mutating func update(environment: Environment)
}
