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
    
    var documentFields: [GenericExpandableItem]
    
    public init(documentFields: [GenericExpandableItem]) {
        self.documentFields = documentFields
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(LocalizableStringKey.credentialDetailsTitle.toString)
                .typography(Theme.shared.font.labelLarge)
                .foregroundStyle(Theme.shared.color.primary)
                .padding(.bottom, SPACING_EXTRA_SMALL)
            WrapExpandableListView(items: documentFields, hideSensitiveContent: false)
        }
        .padding(.bottom, SPACING_LARGE)
    }
}
