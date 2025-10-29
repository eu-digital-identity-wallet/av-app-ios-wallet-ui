import SwiftUI
import logic_ui
import logic_core
import feature_common
import logic_resources

struct DocumentDataDisplayView<Router: RouterHost>: View {
  @StateObject private var viewModel: DocumentDataDisplayViewModel<Router>

  init(with viewModel: DocumentDataDisplayViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true
    ) {
      content(
        viewState: viewModel.viewState,
        onBackButtonTapped: viewModel.backButtonTapped,
        onContinueButtonTapped: viewModel.continueButtonTapped
      )
    }
    .navigationBarHidden(true)
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentDataDisplayViewState,
  onBackButtonTapped: @escaping () -> Void,
  onContinueButtonTapped: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: .zero) {
      VSpacer.largeMedium()
      OnboardingTabsView(steps: PassportEnrollmentSteps.allCases,
                         selectedIndex: 2)

      VStack(alignment: .leading, spacing: .zero) {
        VSpacer.large()

        Text(LocalizableStringKey.passportDataReviewHeader.toString)
          .typography(Theme.shared.font.displaySmall)
          .fontWeight(.bold)
        VSpacer.large()

        // Card Container
        VStack(alignment: .leading, spacing: 16) {
          // Card Title
          Text(LocalizableStringKey.passportIdCardTitle.toString)
            .typography(Theme.shared.font.titleLarge)
            .fontWeight(.semibold)

          // Passport Photo
          if let photoData = viewState.photo,
             let uiImage = UIImage(data: photoData) {
            HStack {
              Spacer()
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 8))
              Spacer()
            }
          }

          VSpacer.medium()

          // Data Fields
          VStack(alignment: .leading, spacing: 20) {
            if let birthDate = viewState.birthDate {
              VStack(alignment: .leading, spacing: 4) {
                Text(LocalizableStringKey.passportBirthDate.toString)
                  .typography(Theme.shared.font.bodyMedium)
                  .foregroundColor(Color(.secondaryLabel))
                Text(formatDate(birthDate))
                  .typography(Theme.shared.font.titleMedium)
                  .fontWeight(.regular)
              }
            }

            if let expiryDate = viewState.expiryDate {
              VStack(alignment: .leading, spacing: 4) {
                Text(LocalizableStringKey.passportExpiryDate.toString)
                  .typography(Theme.shared.font.bodyMedium)
                  .foregroundColor(Color(.secondaryLabel))
                Text(formatDate(expiryDate))
                  .typography(Theme.shared.font.titleMedium)
                  .fontWeight(.regular)
              }
            }
          }
        }
        .padding(20)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)

        VSpacer.large()
      }
      .padding(.horizontal, 16)
    }
  }

  HStack {
    WrapButtonView(
      style: .secondary,
      title: LocalizableStringKey.back,
      isLoading: false,
      onAction: onBackButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.continueButton,
      isLoading: false,
      onAction: onContinueButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)
}

@MainActor
private func formatDate(_ mrzDate: String) -> String {
  // MRZ date format is YYMMDD
  guard mrzDate.count == 6 else { return mrzDate }

  let formatter = DateFormatter()
  formatter.dateFormat = "yyMMdd"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)

  guard let date = formatter.date(from: mrzDate) else { return mrzDate }

  let displayFormatter = DateFormatter()
  displayFormatter.dateFormat = "MMM d, yyyy"  // e.g., "Jan 1, 1987"
  displayFormatter.timeZone = TimeZone(secondsFromGMT: 0)

  return displayFormatter.string(from: date)
}

#Preview {
  let viewState = DocumentDataDisplayViewState(
    photo: nil,
    birthDate: "900101",
    expiryDate: "301231"
  )
  content(
    viewState: viewState,
    onBackButtonTapped: {},
    onContinueButtonTapped: {}
  )
}
