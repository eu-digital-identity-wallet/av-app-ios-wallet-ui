//
//  OnboardingHomeView.swift
//  feature-onboarding
//
//  Created by Bharat Jagtap on 21/05/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct OnboardingHomeView<Router: RouterHost>: View {
    @ObservedObject var viewModel: OnboardingHomeViewModel<Router>

    init(with viewModel: OnboardingHomeViewModel<Router>) {
        self.viewModel = viewModel
    }

    var body: some View {
        ContentScreenView(
            padding: .zero,
            canScroll: true,
            errorConfig: viewModel.viewState.error,
            background: Theme.shared.color.surface,
            navigationTitle: .details
        ) {
            content(state: viewModel.viewState)
        }
    }
}

@MainActor
@ViewBuilder
private func content(state: OnboardingHomeViewState) -> some View {
    VStack {
        AVSegment(items: ["Welcome", "Consent", "Security", "Verification"])
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.surface)
}

struct AVSegment: View {
    var items: [String]
    @State var selectedIndex: Int = 0

    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { index in
                Text(items[index])
                    .font(Theme.shared.font.labelMedium.font)
                    .foregroundColor( selectedIndex == index ? Theme.shared.color.blue : Theme.shared.color.darkGrey)
                    .padding(.all, 8)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Theme.shared.color.surface)
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4)
        .cornerRadius(10.0)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .inset(by: 0.25)
                .stroke(.black.opacity(0.15), lineWidth: 0.5)
        )
    }
}
