import Foundation
import logic_ui
import logic_resources
import feature_common

// For some reason, the `@Copyable` macro is acting weird here.
// Doing it manually until resolved.
struct DocumentNFCViewState: ViewState, Copyable {
  let error: ContentErrorView.Config?

  internal func copy(error: ContentErrorView.Config?) -> Self {
      .init(error: error)
  }
}

final class DocumentNFCViewModel<Router: RouterHost>: ViewModel<Router, DocumentNFCViewState> {
  private let interactor: NFCPassportReaderInteractor
  private let mrzKey: String

  init(
    router: Router,
    interactor: NFCPassportReaderInteractor,
    mrzKey: String
  ) {
    self.interactor = interactor
    self.mrzKey = mrzKey
    super.init(
      router: router,
      initialState: .init(error: nil)
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func nextButtonTapped() {
    // Start NFC reading immediately - native NFC dialog will be shown
    startReading()
  }

  func helpLinkTapped() {
    debugPrint("Do you need help? link tapped")
  }

  private func startReading() {
    Task {
      let result = await interactor.readPassport(mrzKey: mrzKey)

      await MainActor.run {
        switch result {
        case .success(let passportData):
          // Validate that we have the required data
          guard passportData.birthDate != nil,
                passportData.expiryDate != nil,
                passportData.photo != nil else {
            setState {
              $0.copy(
                error: .init(
                  description: .custom(NFCError.missingData.localizedDescription),
                  cancelAction: { [weak self] in
                    self?.onErrorDismissed()
                  }()
                )
              )
            }
            return
          }

          // Success - navigate to display screen with data
          router.push(with: AppRoute.featureIssuanceModule(
            .documentDataDisplay(
              photo: passportData.photo,
              birthDate: passportData.birthDate,
              expiryDate: passportData.expiryDate
            )
          ))

        case .failure(let error):
          // Don't show error if user canceled
          guard case .userCanceled = error else {
            setState {
              $0.copy(
                error: .init(
                  description: .custom(error.localizedDescription),
                  cancelAction: { [weak self] in
                    self?.onErrorDismissed()
                  }()
                )
              )
            }
            return
          }

          // User canceled - no action needed, native dialog was dismissed
        }
      }
    }
  }

  func onErrorDismissed() {
    setState {
      $0.copy(error: nil)
    }
  }
}
