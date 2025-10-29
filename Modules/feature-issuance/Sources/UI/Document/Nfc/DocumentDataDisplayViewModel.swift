import Foundation
import feature_common
import logic_ui

@Copyable
struct DocumentDataDisplayViewState: ViewState {
  let photo: Data?
  let birthDate: String?
  let expiryDate: String?
}

final class DocumentDataDisplayViewModel<Router: RouterHost>: ViewModel<Router, DocumentDataDisplayViewState> {

  init(
    router: Router,
    photo: Data?,
    birthDate: String?,
    expiryDate: String?
  ) {
    super.init(
      router: router,
      initialState: .init(
        photo: photo,
        birthDate: birthDate,
        expiryDate: expiryDate
      )
    )
  }

  func backButtonTapped() {
    router.pop()
  }

  func continueButtonTapped() {
    // TODO: Navigate to liveliness chec
    router.popTo(with: AppRoute.featureAVDashboardModule(.appLanding))
  }
}
