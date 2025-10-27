import SwiftUI
import logic_ui
import logic_resources

struct ChangePinSuccessView<Router: RouterHost>: View {

  @StateObject private var viewModel: ChangePinSuccessViewModel<Router>

  init(with viewModel: ChangePinSuccessViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
    ) {
      content(
        onOkButtonTap: viewModel.onOkButtonTap)
    }

  }
}

@MainActor
@ViewBuilder
private func content(
  onOkButtonTap: @escaping () -> Void
) -> some View {
  VStack {
      Text(.changePinSuccessText)
      .typography(Theme.shared.font.titleMedium)
      .fontWeight(.bold)
    Spacer()
    WrapButtonView(
        style: .primary,
        title: .custom("Ok"),
        onAction: onOkButtonTap()
    )
  }
  .padding()
}

#Preview {
  ContentScreenView {
    content(
        onOkButtonTap: {}
    )
  }
}
