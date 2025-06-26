//
//  BiometricSetupUiConfig.swift
//  feature-common
//
//  Created by Bharat Jagtap on 05/06/25.
//

import logic_ui
import logic_resources

public extension UIConfig {
  struct BiometricSetupUiConfig: UIConfigType, Equatable {
    public let title: LocalizableStringKey?
    public let caption: LocalizableStringKey
    public let button: LocalizableStringKey
    public let skipButton: LocalizableStringKey
    public let navigationSuccessType: DeepLinkNavigationType

    public var log: String {
      return "title: \(title?.toString ?? "none")" +
      " caption: \(caption)" +
      " button: \(button)" +
      " skipButton: \(skipButton)" +
      " onSuccessNav: \(navigationSuccessType)"
    }
    public init(
      title: LocalizableStringKey?,
      caption: LocalizableStringKey,
      button: LocalizableStringKey,
      skipButton: LocalizableStringKey,
      navigationSuccessType: DeepLinkNavigationType
    ) {
      self.title = title
      self.caption = caption
      self.button = button
      self.skipButton = skipButton
      self.navigationSuccessType = navigationSuccessType
    }
  }
}
