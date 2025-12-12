//
//  AuthorizeActionUiConfig.swift
//  feature-common
//
//  Created by Alena Zaikina on 12/9/25.
//

import logic_ui
import logic_resources

public extension UIConfig.AuthorizeAction {
  enum AuthOption: Equatable, Sendable {
    case biometricPin
    case none(LocalizableStringKey)

    public var label: LocalizableStringKey {
      return switch self {
      case .biometricPin:
            .quickPinCreateReenterTitle
      case .none(let buttonLabel):
        buttonLabel
      }
    }
  }

  enum AuthorizeActionResult: Sendable {
    case success
    case cancelled
    case error(Error)
  }
}

public extension UIConfig {
  struct AuthorizeAction: UIConfigType, Equatable {

    public let title: LocalizableStringKey
    public let description: LocalizableStringKey
    public let authOptions: [AuthOption]
    public let navigationSuccessType: ThreeWayNavigationType
    public let navigationBackType: ThreeWayNavigationType?
    public let onAuthResult: (@Sendable (UIConfig.AuthorizeAction.AuthorizeActionResult) -> Void)?

    public var log: String {
      return "title: \(title.toString)" +
      " description: \(description.toString)" +
      " onSuccessNav: \(navigationSuccessType.key)" +
      " onBackNav: \(navigationBackType?.key ?? "none")"
    }

    public init(
      title: LocalizableStringKey,
      description: LocalizableStringKey,
      authOptions: [AuthOption],
      navigationSuccessType: ThreeWayNavigationType,
      navigationBackType: ThreeWayNavigationType?,
      onAuthResult: (@Sendable (UIConfig.AuthorizeAction.AuthorizeActionResult) -> Void)? = nil
    ) {
      self.title = title
      self.description = description
      self.authOptions = authOptions
      self.navigationSuccessType = navigationSuccessType
      self.navigationBackType = navigationBackType
      self.onAuthResult = onAuthResult
    }
  }
}

public extension UIConfig.AuthorizeAction {
  static func == (lhs: UIConfig.AuthorizeAction, rhs: UIConfig.AuthorizeAction) -> Bool {
    return lhs.title == rhs.title &&
    lhs.description == rhs.description &&
    lhs.authOptions == rhs.authOptions &&
    lhs.navigationSuccessType == rhs.navigationSuccessType &&
    lhs.navigationBackType == rhs.navigationBackType
  }
}
