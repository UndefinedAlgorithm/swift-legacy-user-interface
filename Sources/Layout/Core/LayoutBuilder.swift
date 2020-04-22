// FIXME: Does not support single expression yet.
@_functionBuilder
public enum LayoutBuilder {
  typealias Component<Content> = [AnyLayout<Content>]

  static func buildExpression<T>(
    _ expression: T
  ) -> [AnyLayout<T.Content>] where T: Layout {
    [expression.wrapIntoAnyLayout()]
  }

  static func buildIf<Content>(
    _ children: Component<Content>?
  ) -> Component<Content> {
    children ?? []
  }

  static func buildBlock<Content>(
    _ component: Component<Content>
  ) -> Component<Content> {
    component
  }

  static func buildBlock<Content>(
    _ children: Component<Content>...
  ) -> Component<Content> {
    // FIXME: Use `.flatMap(\.self)` when compiler bug is resolved.
    children.flatMap { $0 }
  }
}
