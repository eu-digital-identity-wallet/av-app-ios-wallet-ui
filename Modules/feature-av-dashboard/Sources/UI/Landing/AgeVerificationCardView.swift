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
  let credentialsCount: Int?
  var onTap: (() -> Void)?

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .fill(Theme.shared.color.surfaceContainer)
        .frame(height: cardHeight)
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
        VStack(spacing: .zero) {
          HStack(alignment: .top) {
            HStack(alignment: .center, spacing: .zero) {
              Theme.shared.image.europeanUnionLogo
                .resizable()
                .frame(width: 38, height: 26)
                .padding(.trailing, SPACING_SMALL)
              Text(LocalizableStringKey.europeanUnionLabel1.toString)
                .typography(Theme.shared.font.labelSmall)
                .foregroundStyle(Theme.shared.color.lightText)
            }
            Spacer()
            if let credentialsCount = credentialsCount {
              WrapCardView(cornerRadius: SPACING_MEDIUM_SMALL,
                           backgroundColor: credentialsCount > 0 ? Theme.shared.color.primary : Theme.shared.color.error) {
                WrapTextView(text: credentialsCount > 0 ? .landingCredentialsLeft(credentialsCount) : .addMoreCredentials,
                             textConfig: TextConfig(font: Theme.shared.font.labelSmall.font,
                                                    color: credentialsCount > 0 ? Theme.shared.color.onPrimary : Theme.shared.color.onError,
                                                    textAlign: .center,
                                                    fontWeight: .bold
                                                   ))
                .padding(SPACING_SMALL)
              }
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
              .typography(Theme.shared.font.titleMedium)
              .foregroundStyle(Theme.shared.color.primary)
          }
          .padding(.bottom, SPACING_MEDIUM)
        }
        .frame(height: cardHeight)
      }
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding(.bottom, SPACING_LARGE)
    .contentShape(Rectangle())
    .onTapGesture {
      onTap?()
    }
  }
}
