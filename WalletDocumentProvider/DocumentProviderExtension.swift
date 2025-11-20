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

@main
struct DocumentProviderExtension: IdentityDocumentProvider {
  let dcApiHandler = DcApiHandler(serviceName: "eu.europa.ec.euidi.tsi.dev.eudi.document.storage",
    accessGroup: "K2GH358D95.tsi.com.scytales.av.dev")

    var body: some IdentityDocumentRequestScene {
      ISO18013MobileDocumentRequestScene { context in
            // Insert your view here
            RequestAuthorizationView(context: context, dcApiHandler: dcApiHandler)
          }
    }

    func performRegistrationUpdates() async {

    }
}
