import feature_common

struct ButtonContainer: View {
    let secondaryTitle: LocalizableStringKey?
    let primaryTitle: LocalizableStringKey
    let secondaryAction: (() -> Void)?
    let primaryAction: () -> Void

    init(
        secondaryTitle: LocalizableStringKey? = nil,
        primaryTitle: LocalizableStringKey,
        secondaryAction: (() -> Void)? = nil,
        primaryAction: @escaping () -> Void
    ) {
        self.secondaryTitle = secondaryTitle
        self.primaryTitle = primaryTitle
        self.secondaryAction = secondaryAction
        self.primaryAction = primaryAction
    }

    var body: some View {
        HStack(spacing: 12) {
            if let secondaryTitle = secondaryTitle,
               let secondaryAction = secondaryAction {
              SecondaryButton(title: secondaryTitle, action: secondaryAction)
            }
            PrimaryButton(title: primaryTitle, action: primaryAction)
        }
    }
}

struct PrimaryButton: View {
    let title: LocalizableStringKey
    let action: () -> Void

    var body: some View {
      Button(action: action) {
        Text(title)
          .typography(Theme.shared.font.headlineMedium)
          .foregroundColor(Theme.shared.color.white)
          .frame(maxWidth: .infinity)
          .frame(height: 39)
          .background(.primary)
          .cornerRadius(8)
      }
    }
}

struct SecondaryButton: View {
    let title: LocalizableStringKey
    let action: () -> Void

    var body: some View {
      Button(action: action) {
        Text(title)
          .typography(Theme.shared.font.headlineMedium)
          .foregroundColor(Theme.shared.color.primary)
          .frame(maxWidth: .infinity)
          .frame(height: 39)
          .background(Theme.shared.color.white)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.blue, lineWidth: 2)
          )
          .cornerRadius(8)
      }
    }
}

#Preview {
  ButtonContainer(
    secondaryTitle: LocalizableStringKey.back,
    primaryTitle: LocalizableStringKey.startProcedure,
    secondaryAction: {},
    primaryAction: {}
  )
}
