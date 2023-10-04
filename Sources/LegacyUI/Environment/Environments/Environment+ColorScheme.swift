import enum SwiftUI.ColorScheme

extension Environment {
  enum _ColorSchemeKey: EnvironmentKey {
    static var defaultValue: ColorScheme {
      .light
    }
  }

  public var colorScheme: ColorScheme {
    get {
      self[_ColorSchemeKey.self]
    }
    set {
      self[_ColorSchemeKey.self] = newValue
    }
  }
}
