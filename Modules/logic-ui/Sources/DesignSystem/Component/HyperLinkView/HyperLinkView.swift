import SwiftUI
import logic_resources

public struct HyperLinkView: View {
  var label: String
  let onLinkTap: () -> Void

  public init(label: String,
              onLinkTap: @escaping () -> Void) {
    self.label = label
    self.onLinkTap = onLinkTap
  }

  public var body: some View {
    Button(action: {
      onLinkTap()
    }, label: {
      HStack {
        Text(label)
          .underline()
          .font(Theme.shared.font.headlineMedium.font)
      }
      .foregroundStyle(Theme.shared.color.primary)
    })
  }
}
