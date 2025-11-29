//
//  DocumentProviderExtension.swift
//  WalletDocumentProvider
//
//  Created by A200111500 on 16/11/25.
//

import ExtensionKit
import IdentityDocumentServicesUI
import SwiftUI
import DcApi18013AnnexC
import Swinject
import logic_ui
import logic_business

@main
struct DocumentProviderExtension: IdentityDocumentProvider {

  private let dcApiHandler: DcApiHandler
  private let routerHost: logic_ui.RouterHost

  init() {
    _ = DocumentProviderDIContainer.shared
    self.dcApiHandler = DIGraph.shared.resolver.force(DcApiHandler.self)
    self.routerHost = DIGraph.shared.resolver.force(logic_ui.RouterHost.self)
  }
  var body: some IdentityDocumentRequestScene {
    ISO18013MobileDocumentRequestScene { context in
      if let documentRouter = routerHost as? DocumentProviderRouter {
        documentRouter.configureAuthorization(
          context: context,
          handler: dcApiHandler
        )
      }
      print(routerHost)
      return routerHost.composeApplication()
        .ignoresSafeArea(edges: .bottom)
    }
  }

  func performRegistrationUpdates() async {

  }
}
