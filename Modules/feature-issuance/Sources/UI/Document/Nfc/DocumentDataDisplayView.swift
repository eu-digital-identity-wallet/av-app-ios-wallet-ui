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

import SwiftUI
import logic_ui
import logic_core
import feature_common
import logic_resources

struct DocumentDataDisplayView<Router: RouterHost>: View {
  @State private var viewModel: DocumentDataDisplayViewModel<Router>

  init(with viewModel: DocumentDataDisplayViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
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

        Text(LocalizableStringKey.passportBiometricsVerifyData.toString)
          .typography(Theme.shared.font.displaySmall)
          .fontWeight(.bold)
        VSpacer.large()

        // Card Container
        VStack(alignment: .leading, spacing: 16) {
          // Card Title
          Text(LocalizableStringKey.passportBiometricsPassport.toString)
            .typography(Theme.shared.font.titleLarge)
            .fontWeight(.semibold)

          // Passport Photo
          HStack {
            Spacer()
            if let photoData = viewState.config.documentData?.photo,
               let uiImage = UIImage(data: photoData) {
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
              // Show X icon placeholder when no photo available
              ZStack {
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color(UIColor.systemGray5))
                  .frame(width: 150, height: 190)
                Image(systemName: "xmark")
                  .font(.system(size: 60, weight: .light))
                  .foregroundColor(Color(UIColor.systemGray3))
              }
            }
            Spacer()
          }

          VSpacer.medium()

          // Data Fields
          VStack(alignment: .leading, spacing: 20) {
            if let formattedBirthDate = viewState.formattedBirthDate {
              VStack(alignment: .leading, spacing: 4) {
                Text(LocalizableStringKey.passportBiometricsDob.toString)
                  .typography(Theme.shared.font.bodyMedium)
                  .foregroundColor(viewState.isUnderAge ? .red : Color(.secondaryLabel))
                Text(formattedBirthDate)
                  .typography(Theme.shared.font.titleMedium)
                  .fontWeight(.regular)
                  .foregroundColor(viewState.isUnderAge ? .red : .primary)
              }
            }

            if let formattedExpiryDate = viewState.formattedExpiryDate {
              VStack(alignment: .leading, spacing: 4) {
                Text(LocalizableStringKey.passportBiometricsDoe.toString)
                  .typography(Theme.shared.font.bodyMedium)
                  .foregroundColor(viewState.isPassportExpired ? .red : Color(.secondaryLabel))
                Text(formattedExpiryDate)
                  .typography(Theme.shared.font.titleMedium)
                  .fontWeight(.regular)
                  .foregroundColor(viewState.isPassportExpired ? .red : .primary)
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
      title: LocalizableStringKey.passportBiometricsBack,
      isLoading: false,
      onAction: onBackButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
    WrapButtonView(
      style: .primary,
      title: LocalizableStringKey.passportBiometricsNext,
      isLoading: false,
      isEnabled: viewState.isValid,
      onAction: onContinueButtonTapped()
    )
    .padding(.horizontal, SPACING_SMALL)
  }
  .frame(maxWidth: .infinity)
  .padding(.horizontal, Theme.shared.dimension.padding)
  .padding(.bottom, 64)
}

#Preview {
  let viewState = DocumentDataDisplayViewState(
    config: DocumentEnrollmentUiConfig(
      mrzKey: nil,
      documentData: DocumentEnrollmentUiConfig.DocumentData(
        photo: nil,
        birthDate: "900101",
        expiryDate: "301231"
      )
    ),
    isUnderAge: false,
    isPassportExpired: false,
    formattedBirthDate: "Jan 1, 1990",
    formattedExpiryDate: "Dec 31, 2030"
  )
  content(
    viewState: viewState,
    onBackButtonTapped: {},
    onContinueButtonTapped: {}
  )
}
