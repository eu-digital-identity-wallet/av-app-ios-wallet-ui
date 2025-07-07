/*
 * Copyright (c) 2023 European Commission
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
import logic_resources
import logic_business

public struct SplashBackgroundView: View {
    private let appVersion: String
    
    public init(appVersion: String) {
        self.appVersion = appVersion
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Map and Logo Section
            ZStack {
                Theme.shared.image.euMap
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, SPACING_SMALL)

                VStack(spacing: SPACING_MEDIUM) {
                    Theme.shared.image.logo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)

                    Text(LocalizableStringKey.splashTitle.toString)
                        .typography(Theme.shared.font.displayLarge)
                        .foregroundStyle(Theme.shared.color.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }

            Spacer()

            // Version Section
            VStack(spacing: SPACING_SMALL) {
                Text(appVersion)
                    .typography(Theme.shared.font.bodySmall)
                    .foregroundColor(Theme.shared.color.primary)
            }
            .padding(.bottom, SPACING_MEDIUM)

            // Footer Section
            HStack(spacing: SPACING_LARGE_MEDIUM) {
                Spacer()
                    .frame(width: getScreenRect().width * 0.1)

                Text(LocalizableStringKey.splashSponsorsTitle.toString)
                    .typography(Theme.shared.font.bodyLarge)
                    .foregroundColor(Theme.shared.color.onPrimary)

                Theme.shared.image.scytalesLogo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)

                Theme.shared.image.telekomLogo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)

                Spacer()
            }
            .padding(SPACING_MEDIUM)
            .background(
                Rectangle()
                .fill(Theme.shared.color.primary)
                .clipShape(
                    .rect(
                        topLeadingRadius: 24,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 24
                    )
                )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.shared.color.surface)
        .ignoresSafeArea()
    }
}

#Preview {
    Group {
        SplashBackgroundView(appVersion: "1.0.0")
    }
}

#Preview("Dark Mode") {
    Group {
        SplashBackgroundView(appVersion: "1.0.0")
    }
}
