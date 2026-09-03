/*
 * Copyright (c) 2026 European Commission
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
import logic_resources

struct UnsupportedDeviceView: View {

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      background: Theme.shared.color.surface
    ) {
      content
    }
  }

  @ViewBuilder
  private var content: some View {
    VStack(alignment: .center, spacing: .zero) {
      Spacer()
      Theme.shared.image.exclamationmarkCircle
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
      VSpacer.large()
      Text(.unsupportedDeviceTitle)
        .typography(Theme.shared.font.titleMedium)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
      VSpacer.small()
      Text(.unsupportedDeviceMessage)
        .typography(Theme.shared.font.bodyMedium)
        .multilineTextAlignment(.center)
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, Theme.shared.dimension.padding)
  }
}

#Preview {
  UnsupportedDeviceView()
}
