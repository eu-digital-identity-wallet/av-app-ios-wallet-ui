/*
 * Copyright (c) 2025 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import logic_ui
import logic_business
import feature_common

@MainActor
public final class IssuanceRouter {

  @ViewBuilder
  public static func resolve(module: FeatureIssuanceRouteModule, host: some RouterHost) -> AnyView {
    switch module {
    case .issuanceAddDocument(config: let config):
      return AddDocumentView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            AddDocumentInteractor.self
          ),
          deepLinkController: DIGraph.shared.resolver.force(
            DeepLinkController.self
          ),
          config: config
        )
      )
      .eraseToAnyView()
    case .issuanceSuccess(
      let config,
      let uiModels
    ):
      return DocumentIssuanceSuccessView(
        with: .init(
          router: host,
          config: config,
          deepLinkController: DIGraph.shared.resolver.force(
            DeepLinkController.self
          ),
          requestItems: uiModels.compactMap { $0 as? GenericListItemSection }
        )
      ).eraseToAnyView()
    case .credentialOfferRequest(let config):
      return DocumentOfferView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            DocumentOfferInteractor.self
          ),
          config: config
        )
      ).eraseToAnyView()
    case .issuanceCode(config: let config):
      return OfferCodeView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            DocumentOfferInteractor.self
          ),
          config: config
        )
      ).eraseToAnyView()
    case .documentMRZIntro(let config):
      guard let documentEnrollmentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return MrzDocumentIntroView(
        with: .init(
          router: host,
          config: documentEnrollmentConfig
        )
      ).eraseToAnyView()
    case .documentMRZInstruction(let config):
      guard let documentEnrollmentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return MrzDocumentInstructionView(
        with: .init(
          router: host,
          config: documentEnrollmentConfig
        )
      ).eraseToAnyView()
    case .documentMRZScan(let config):
      guard let documentEnrollmentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return MRZDocumentScanView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            DocumentMRZScanInteractor.self
          ),
          config: documentEnrollmentConfig
        )
      ).eraseToAnyView()
    case .documentNFC(let config):
      guard let documentEnrollmentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return DocumentNFCView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            NFCDocumentReaderInteractor.self
          ),
          config: documentEnrollmentConfig
        )
      ).eraseToAnyView()
    case .documentDataDisplay(let config):
      guard let documentEnrollmentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return DocumentDataDisplayView(
        with: .init(
          router: host,
          config: documentEnrollmentConfig
        )
      ).eraseToAnyView()
    case .livenessCheck(let config):
      guard let documentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return LivenessCheckView(
        with: .init(
          router: host,
          config: documentConfig,
          interactor: DIGraph.shared.resolver.force(
            LivenessCheckInteractor.self
          )
        )
      ).eraseToAnyView()
    case .credentialIssuance(let config):
      guard let documentEnrollmentConfig = config as? DocumentEnrollmentUiConfig else {
        return ContentErrorView(
          config: .init(
            description: .custom("Invalid configuration type"),
            cancelAction: {}()
          )
        ).eraseToAnyView()
      }
      return CredentialIssuanceView(
        with: .init(
          router: host,
          config: documentEnrollmentConfig,
          interactor: DIGraph.shared.resolver.force(
            CredentialIssuanceInteractor.self
          )
        )
      ).eraseToAnyView()
    }
  }
}
