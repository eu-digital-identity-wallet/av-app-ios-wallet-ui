//
//  HyperlinkView.swift
//  feature-onboarding
//
//  Created by A200156428 on 25/05/25.
//
import SwiftUI
import feature_common
import logic_resources
import logic_core

struct HyperLinkView: View {
    var label: String
    let onLinkTap: () -> Void

    var body: some View {
        Button(action: {
            onLinkTap()
        }, label: {
            HStack {
                Text(label)
                    .underline()
                    .font(Theme.shared.font.headlineSmall.font)
                Image(systemName: "arrow.up.right")
                    .resizable()
                    .frame(width: 10, height: 10)
            }
            .foregroundStyle(Theme.shared.color.primary)
        })
    }
}
