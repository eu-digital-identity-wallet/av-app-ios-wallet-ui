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

struct CarousalView: View {

    @State private var selection = 0
    
    let pages: [PageItem] = [
        PageItem(image: Theme.shared.image.digitalIdIssuance, title: "Welcome", body: "The Anonymous Age Verification App quickly and securely confirms your age for accessing age-restricted services."),
        PageItem(image: Theme.shared.image.ageVerification, title: "Simple Age Verification", body: "Simply verify your age once using a national eID or biometric check and receive a proof of age that allows seamless access to age-limited services"),
        PageItem(image: Theme.shared.image.successSecuredWallet, title: "Privacy Protection", body: "You stay in control of your data—only your proof of age is shared, never your personal identification details.")
    ]

    var body: some View {
        VStack() {
            TabView(selection: $selection) {
                ForEach(pages.indices) { index in
                    let pageItem = pages[index]
                    VStack(spacing: 24) {
                        pageItem.image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 74)
                        VStack(alignment: .leading, spacing: 24) {
                            Text(pages[index].title)
                                .font(Theme.shared.font.titleMedium.font)
                                .bold()
                            Text(pages[index].body)
                                .font(Theme.shared.font.bodyLarge.font)
                        }
                    }
                    .tag(index)
                    .padding(.horizontal, 24)
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: 270)
            
            HStack(spacing: 32) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selection ? Theme.shared.color.blue : Theme.shared.color.grey)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .padding(.top, 32)
    }
}
