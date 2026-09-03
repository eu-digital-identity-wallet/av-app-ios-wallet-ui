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
      canScroll: true
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
      ScrollView {
        VStack {
          HStack {
            ThemeManager.shared.image.logoEuDigitalIndentityWallet
            .resizable()
            .frame(width: 60, height: 60)
            .accessibilityHidden(true)
          }
          .frame(maxWidth: .infinity)
          Spacer()
                
          VStack {
            Image(systemName: "checkmark.circle")
            .resizable()
            .frame(width: 180, height: 180)
            .foregroundColor(Theme.shared.color.success.opacity(0.5))
            .accessibilityHidden(true)
              
            Text(.quickPinChangeSuccessText)
            .typography(Theme.shared.font.displayLarge)
            .foregroundColor(Theme.shared.color.success.opacity(0.7))
              
            Text(.quickPinChangeSuccessDescription)
            .typography(Theme.shared.font.bodyMedium)
          }
          .accessibilityAnnouncement(for: LocalizableStringKey.quickPinChangeSuccessDescription.toString, message: LocalizableStringKey.quickPinChangeSuccessDescription.toString)
                
          Spacer()
        }
        
      }
      Spacer()
      WrapButtonView(
        style: .primary,
        title: .quickPinChangeSuccessBtn,
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
