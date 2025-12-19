import SwiftUI
import logic_ui
import logic_resources

struct ChangePinSuccessView<Router: RouterHost>: View {

  @State private var viewModel: ChangePinSuccessViewModel<Router>

  init(with viewModel: ChangePinSuccessViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
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
    HStack {
      ThemeManager.shared.image.logoEuDigitalIndentityWallet
        .resizable()
        .frame(width: 60, height: 60)
    }
    .frame(maxWidth: .infinity)
    Text(.quickPinChangeSuccessText)
      .typography(Theme.shared.font.titleMedium)
      .fontWeight(.bold)
    Spacer()
    WrapButtonView(
      style: .primary,
      title: .genericOk,
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
