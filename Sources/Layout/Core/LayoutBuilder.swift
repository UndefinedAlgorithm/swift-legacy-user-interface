// FIXME: Does not support single expression yet.
@_functionBuilder
public enum LayoutBuilder {
  public typealias Component<Content> = [AnyLayout<Content>]

  public static func buildExpression<T>(
    _ expression: T
  ) -> [AnyLayout<T.Content>] where T: Layout {
    [expression.wrapIntoAnyLayout()]
  }

  public static func buildIf<Content>(
    _ children: Component<Content>?
  ) -> Component<Content> {
    children ?? []
  }

  public static func buildBlock<Content>(
    _ component: Component<Content>
  ) -> Component<Content> {
    component
  }

  public static func buildBlock<Content>(
    _ children: Component<Content>...
  ) -> Component<Content> {
    // FIXME: Use `.flatMap(\.self)` when compiler bug is resolved.
    children.flatMap { $0 }
  }
}
