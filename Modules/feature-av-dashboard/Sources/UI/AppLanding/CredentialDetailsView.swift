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
    
    var claims: [DocClaim]
    
    public init(claims: [DocClaim]) {
        self.claims = claims
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(LocalizableStringKey.credentialDetailsTitle.toString)
                .typography(Theme.shared.font.labelLarge)
                .foregroundStyle(Theme.shared.color.primary)
                .padding(.bottom, SPACING_EXTRA_SMALL)
            VStack(alignment: .leading, spacing: 15){
                ForEach(claims) { claim in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(claim.name)
                            .typography(Theme.shared.font.bodyLarge)
                        Text(claim.stringValue)
                            .typography(Theme.shared.font.bodyLarge)
                            .foregroundStyle(Theme.shared.color.lightText)
                        if claim != claims.last {
                            Divider()
                                .padding(.top, 10)
                        }
                    }
                }
            }
            .padding()
            
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(Theme.shared.color.surfaceContainer)
                .clipped()
            )
        }
        .padding(.bottom, SPACING_LARGE)
    }
}
