//
//  CheckboxView.swift
//  feature-onboarding
//
//  Created by A200156428 on 25/05/25.
//
import SwiftUI
import feature_common
import logic_resources
import logic_core
import logic_ui

struct CheckboxView: View {
    @State var isChecked: Bool
    var label: String
    let action: (Bool) -> Void

    var body: some View {
        Button(action: {
            isChecked.toggle()
            action(isChecked)
        }) {
            HStack(alignment: .top) {
                isChecked ? Theme.shared.image.checkboxChecked : Theme.shared.image.checkboxUnchecked

                Text(label)
                    .font(Theme.shared.font.bodyLarge.font)
            }
        }
        .buttonStyle(.plain)
        .padding(.bottom, SPACING_MEDIUM)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(
            isChecked
            ? LocalizableStringKey.accessibilityCheckboxChecked.toString
            : LocalizableStringKey.accessibilityCheckboxUnchecked.toString
        )
    }
}
