import SwiftUI
import logic_ui
import logic_resources

struct ChangePinView<Router: RouterHost>: View {

  @State private var viewModel: ChangePinViewModel<Router>
  @FocusState var uiPinInputFieldInFocus: Bool
  @FocusState var uiPinInputFieldConfirmInFocus: Bool
  @State private var keyboardHeight: CGFloat = 0
  @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?

  init(with viewModel: ChangePinViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      toolbarContent: viewModel.viewState.showBackButton ? viewModel.backActionToolbar() : nil
    ) {
      content(
        viewState: viewModel.viewState,
        uiPinInputField: Binding(
          get: { viewModel.viewState.pin1 },
          set: { newPin in viewModel.updatePin1(newPin) }
        ),
        uiPinInputFieldInfocus: $uiPinInputFieldInFocus,
        uiPinInputFieldConfirm: Binding(
          get: { viewModel.viewState.pin2 },
          set: { newPin in viewModel.updatePin2(newPin) }
        ),
        uiPinInputFieldConfirmInfocus: $uiPinInputFieldConfirmInFocus,
        onValidate: {
          self.viewModel.validatePinsMatch()
        },
        onFirstPinCompletion: {
          self.viewModel.validateFirstPin()
          if viewModel.viewState.uiPinInputFieldError == nil {
            uiPinInputFieldInFocus = false
            uiPinInputFieldConfirmInFocus = true
          } else {
            uiPinInputFieldInFocus = true
            uiPinInputFieldConfirmInFocus = false
          }
        },
        onFirstPinChange: {
          self.viewModel.isFirstPinIncomplete()
        },
        onConfirmPinChange: {
          self.viewModel.clearConfirmError()
        },
        keyboardHeight: keyboardHeight,
        isLandscape: verticalSizeClass == .compact
      )
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        uiPinInputFieldInFocus = true
        uiPinInputFieldConfirmInFocus = false
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
      guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
        return
      }
      let screenHeight = UIApplication.shared.currentUIWindow?.bounds.height ?? 0
      keyboardHeight = (screenHeight > 0 && endFrame.minY >= screenHeight) ? 0 : max(0, endFrame.height)
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: ChangePinState,
  uiPinInputField: Binding<String>,
  uiPinInputFieldInfocus: FocusState<Bool>.Binding,
  uiPinInputFieldConfirm: Binding<String>,
  uiPinInputFieldConfirmInfocus: FocusState<Bool>.Binding,
  onValidate: @escaping () -> Void,
  onFirstPinCompletion: @escaping () -> Void,
  onFirstPinChange: @escaping () -> Void,
  onConfirmPinChange: @escaping () -> Void,
  keyboardHeight: CGFloat,
  isLandscape: Bool
) -> some View {
  let sectionSpacing: CGFloat = isLandscape ? SPACING_MEDIUM_SMALL : SPACING_LARGE_MEDIUM

  ScrollViewReader { proxy in
    ScrollView {
      VStack(alignment: .leading) {
        HStack {
          Text(viewState.title)
            .typography(Theme.shared.font.titleLarge)
            .fontWeight(.bold)
          Spacer()
        }
        Spacer().frame(height: sectionSpacing)

        Text(LocalizableStringKey.quickPinChangeEnterNewSubtitle.toString)
          .typography(Theme.shared.font.bodyLarge)

        Spacer().frame(height: sectionSpacing)
        Text(LocalizableStringKey.quickPinChangeEnterNewSubtitle.toString)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.lightText)
        PinView(pin: uiPinInputField,
         error: viewState.uiPinInputFieldError,
         isFocused: uiPinInputFieldInfocus,
         length: viewState.quickPinSize,
            onChange: { _ in
              onFirstPinChange()
            },
          onCompletion: {
            onFirstPinCompletion()
        })
        .id("pin1")

        if let error = viewState.uiPinInputFieldError {
          HStack {
            Text(error)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundColor(Theme.shared.color.error)
            Spacer()
          }
        }

        Spacer().frame(height: sectionSpacing)
        Text(LocalizableStringKey.quickPinChangeReenterNewSubtitle.toString)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.lightText)
        PinView(pin: uiPinInputFieldConfirm,
            error: viewState.uiPinInputFieldConfirmError,
            isFocused: uiPinInputFieldConfirmInfocus,
            length: viewState.quickPinSize,
            onChange: { pin in
              if pin.isEmpty {
                uiPinInputFieldConfirmInfocus.wrappedValue = false
                uiPinInputFieldInfocus.wrappedValue = true
              }
          onConfirmPinChange()
          }, onCompletion: {
            onValidate()
        })
        .id("pin2")
        if let error = viewState.uiPinInputFieldConfirmError {
          HStack {
            Text(error)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundColor(Theme.shared.color.error)
            Spacer()
          }
        }

        Spacer().frame(height: sectionSpacing)
        Text(LocalizableStringKey.quickPinChangeHelpText.toString)
          .typography(Theme.shared.font.bodyLarge)
        Spacer()
      }
      .padding()
    }
    .scrollDismissesKeyboard(.interactively)
    .safeAreaInset(edge: .bottom, spacing: 0) {
      Color.clear.frame(height: keyboardHeight)
    }
    .onChange(of: keyboardHeight) { _, newValue in
      guard newValue > 0 else { return }
      withAnimation {
        proxy.scrollTo(uiPinInputFieldConfirmInfocus.wrappedValue ? "pin2" : "pin1", anchor: .center)
      }
    }
    .onChange(of: uiPinInputFieldInfocus.wrappedValue) { _, focused in
      guard focused else { return }
      withAnimation { proxy.scrollTo("pin1", anchor: .center) }
    }
    .onChange(of: uiPinInputFieldConfirmInfocus.wrappedValue) { _, focused in
      guard focused else { return }
      withAnimation { proxy.scrollTo("pin2", anchor: .center) }
    }
  }
}

struct PinView: View {
  @Binding var pin: String
  var error: LocalizableStringKey?
  var isFocused: FocusState<Bool>.Binding
  let length: Int
  var onChange: ((String) -> Void)?
  var onCompletion: (() -> Void)?
  var onClear: (() -> Void)?
  @State private var maskedDigits: [String] = []
  @State private var showCursor = true
  let cursorTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 13) {
        ForEach(0..<length, id: \.self) {index in
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .stroke(.gray, lineWidth: 1)
              .frame(width: 50, height: 55)
               if index < maskedDigits.count {
                 Text(maskedDigits[index])
                   .font(.title2)
                   .bold()
                   .transition(.opacity)
                 } else if index == pin.count && isFocused.wrappedValue && showCursor {

                    Rectangle()
                      .fill(.green)
                      .frame(width: 2, height: 28)
                      .transition(.opacity)
                 }
              }
          }
      }
      .background(content: {
        TextField("", text: $pin)
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .focused(isFocused)
          .foregroundColor(.clear)
          .accentColor(.clear)
          .frame(width: 0, height: 0)
          .submitLabel(.done)
          .onChange(of: pin) { newValue in
            handlePinChange(newValue)
          }
      })
      .onTapGesture {
        isFocused.wrappedValue = true
      }
    }
    .onAppear {
      maskedDigits = []
    }
    .onReceive(cursorTimer) { _ in
      showCursor.toggle()
    }
  }

  private func handlePinChange(_ newValue: String) {
    let cleaned = String(newValue.prefix(length).filter(\.isWholeNumber))
    pin = cleaned

    if cleaned.count > maskedDigits.count {
      let index = cleaned.count - 1
      let digit = String(cleaned.last!)

      maskedDigits.append(digit)

      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
        if pin.count > index {
          withAnimation {
            maskedDigits[index] = "•"
          }
        }
      }
    } else if cleaned.count < maskedDigits.count {
      // Digit deleted
      maskedDigits = Array(maskedDigits.prefix(cleaned.count))
    }

    if pin.count == length {
      onCompletion?()
    } else {
      onChange?(pin)
    }
  }
}

#Preview {
  @FocusState var uiPinInputFieldInFocus: Bool
  @FocusState var uiPinInputFieldConfirmInFocus: Bool
  let pin1 = Binding<String>(
    get: { "" },
    set: { _ in}
  )
  let pin2 = Binding<String>(
    get: { "" },
    set: { _ in}
  )

  let viewState = ChangePinState(
    config: QuickPinUiConfig(flow: .update),
    navigationTitle: .quickPinChangeTitle,
    title: .quickPinChangeEnterNewSubtitle,
    caption: .custom(""),
    button: .quickPinNextButton,
    success: .quickPinChangeSuccessText,
    successButton: .quickPinChangeSuccessBtn,
    successNavigationType: .push(screen: .featureAVDashboardModule(.appLanding)),
    isCancellable: true,
    isButtonActive: true,
    quickPinSize: 6,
    isLoading: false
  )

  ContentScreenView {
    content(
      viewState: viewState,
      uiPinInputField: pin1,
      uiPinInputFieldInfocus: $uiPinInputFieldInFocus,
      uiPinInputFieldConfirm: pin2,
      uiPinInputFieldConfirmInfocus: $uiPinInputFieldConfirmInFocus,
      onValidate: {},
      onFirstPinCompletion: {},
      onFirstPinChange: {},
      onConfirmPinChange: {},
      keyboardHeight: 0,
      isLandscape: false
    )
  }
  .onAppear {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      uiPinInputFieldInFocus = true
      uiPinInputFieldConfirmInFocus = false
    }
  }
}
