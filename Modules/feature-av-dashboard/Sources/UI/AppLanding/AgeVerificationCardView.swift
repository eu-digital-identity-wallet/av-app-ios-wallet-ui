//
//  AgeVerificationCardView.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 02/06/25.
//


import SwiftUI
import feature_common
import logic_resources
import logic_core

struct AgeVerificationCardView: View {
    let cardHeight: CGFloat = 129
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Theme.shared.color.surfaceContainer)
                .frame(height: cardHeight)
                //.stroke(Color.gray, lineWidth: 0.5)
                .clipped()
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            
            HStack(alignment: .top, spacing: .zero) {
                Rectangle()
                    .fill(Theme.shared.color.primary)
                    .frame(width: 9, height: cardHeight)
                    .padding(.trailing, SPACING_EXTRA_SMALL)
                Rectangle()
                    .fill(Theme.shared.color.primary)
                    .frame(width: 5, height: cardHeight)
                    .padding(.trailing, SPACING_SMALL)
                VStack(spacing: .zero){
                    HStack(alignment: .top) {
                        HStack(alignment: .center, spacing: .zero) {
                            Theme.shared.image.europeanUnionLogo
                                .resizable()
                                .frame(width: 38, height: 26)
                                .padding(.trailing, SPACING_SMALL)
                            Text(LocalizableStringKey.europeanUnionLabel1.toString)
                                .font(Theme.shared.font.labelSmall.font)
                                .foregroundStyle(Theme.shared.color.lightText)
                        }
                        Spacer()
                        HStack(alignment: .center, spacing: .zero){
                            Theme.shared.image.euCredentialLogo
                                .resizable()
                                .frame(width: 10, height: 10)
                                .padding(.trailing, SPACING_EXTRA_SMALL)
                            Text(LocalizableStringKey.europeanUnionLabel2.toString)
                                .font(Theme.shared.font.labelSmall.font)
                                .foregroundStyle(Theme.shared.color.lightText)
                        }
                    }
                    .padding(.top, SPACING_SMALL)
                    .padding(.trailing, SPACING_MEDIUM)
                    Spacer()
                    HStack {
                        Theme.shared.image._18PlusLogo
                            .resizable()
                            .frame(width: 64, height: 61)
                        Text(LocalizableStringKey.splashTitle.toString)
                            .font(Theme.shared.font.titleMedium.font)
                            .foregroundStyle(Theme.shared.color.primary)
                    }
                    .padding(.bottom, SPACING_MEDIUM)
                }
                .frame(height: cardHeight)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.bottom, SPACING_MEDIUM_LARGE)
    }
}

