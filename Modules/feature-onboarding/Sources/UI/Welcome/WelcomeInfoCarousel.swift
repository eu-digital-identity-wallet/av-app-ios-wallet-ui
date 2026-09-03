//
//  Untitled.swift
//  feature-onboarding
//
//  Created by A200156428 on 23/05/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct WelcomeInfoItem: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
    let body: String
}

struct WelcomeInfoCarousel: View {
    @State private var selection = 0
    let pages: [WelcomeInfoItem] = [
        WelcomeInfoItem(image: Theme.shared.image.ageVerification,
                        title: LocalizableStringKey.welcomeTitle1.toString,
                        body: LocalizableStringKey.welcomePage1.toString),
        WelcomeInfoItem(image: Theme.shared.image.digitalIdIssuance,
                        title: LocalizableStringKey.welcomeTitle2.toString,
                        body: LocalizableStringKey.welcomePage2.toString),
        WelcomeInfoItem(image: Theme.shared.image.successSecuredWallet,
                        title: LocalizableStringKey.welcomeTitle3.toString,
                        body: LocalizableStringKey.welcomePage3.toString)
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                ForEach(pages.indices, id: \.self) { index in
                    let pageItem = pages[index]
                    VStack(spacing: SPACING_LARGE_MEDIUM) {
                        pageItem.image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 74)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {
                            Text(pages[index].title)
                                .multilineTextAlignment(.leading)
                                .font(Theme.shared.font.titleMedium.font)
                                .fontWeight(.medium)
                                .accessibilityAddTraits(.isHeader)
                            Text(pages[index].body)
                                .multilineTextAlignment(.leading)
                                .font(Theme.shared.font.bodyLarge.font)
                        }
                    }
                    .tag(index)
                    .padding(.horizontal)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(maxWidth: .infinity, maxHeight: 300)
            //.frame(maxHeight: 300)
            .frame(idealHeight: 200)

            HStack(spacing: SPACING_LARGE) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selection ? Theme.shared.color.blue : Theme.shared.color.grey)
                        .frame(width: SPACING_MEDIUM_SMALL, height: SPACING_MEDIUM_SMALL)
                        .onTapGesture {
                            withAnimation {
                                selection = index
                            }
                        }
                }
            }
            .padding(.top, SPACING_MEDIUM)
        }
        .padding(.top, SPACING_LARGE)
    }
}
