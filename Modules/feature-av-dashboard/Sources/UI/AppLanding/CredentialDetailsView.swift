//
//  CredentialDetailsView.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 02/06/25.
//

import SwiftUI
import feature_common
import logic_resources
import logic_core

struct CredentialDetailsView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(LocalizableStringKey.credentialDetailsTitle.toString)
                .typography(Theme.shared.font.labelMedium)
                .foregroundStyle(Theme.shared.color.primary)
                .padding(.bottom, SPACING_EXTRA_SMALL)
            HStack {
                VStack(alignment: .leading) {
                    Text(LocalizableStringKey.ageOver18Label.toString)
                        .typography(Theme.shared.font.bodyLarge)
                    Text("true")
                        .typography(Theme.shared.font.bodyLarge)
                        .foregroundStyle(Theme.shared.color.lightText)
                }
                .padding()
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(Theme.shared.color.surfaceContainer)
                .clipped()
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4))
        }
        .padding(.bottom, SPACING_LARGE)
    }
}
