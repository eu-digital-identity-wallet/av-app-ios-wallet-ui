# How to use the Age Verification App

Minimum device requirements

- Any device that supports iOS 26.2

## Prerequisites

To complete the flows described below you need to build and run the application with Xcode.

Clone this repo and make sure you have access to the dependencies below:

[iso18013-data-model](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-model.git)

[iso18013-data-transfer](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-transfer.git)

[iso18013-security](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-security.git)

[wallet-storage](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-storage.git)

[wallet-kit](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit)

[openid4vp-swift](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-siop-openid4vp-swift.git)

[presentation-exchange-swift](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-presentation-exchange-swift.git)

[openid4vci-swift](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-openid4vci-swift)

## App launch

1. Launch the application
2. You will be presented with a welcome screen where you will be asked to create a PIN for future logins.

## Issuance flow (Scoped)

1. Open the "Add document" screen or if it's the first time you open the app, you will be redirected there after you enter or set up your PIN.
2. Pick "National ID".
3. From the web view that appears select the "FormEU" option and tap submit.
4. Fill in the form. Any data will do.
5. You will be shown a success screen. Tap next.
6. Your "National ID" is displayed. Tap "Continue".
7. You are now on the "Dashboard" screen.

## Issuance flow (Credential Offer)

1. Open the "Add document" screen or if it's the first time you open the app, you will be redirected there after you enter or set up your PIN.
2. Tap "SCAN QR".
3. Scan The QR Code from the issuer's website [EUDI Issuer](https://issuer.eudiw.dev/credential_offer_choice)
4. Review the documents contained in the credential offer and tap "Issue".
5. You will be shown a success screen. Tap "Continue".
6. You are now on the "Dashboard" screen.

While on the "Dashboard" screen you can tap "Add doc" and issue a new document, e.g. "Driving License".

If you want to re-issue a document you must delete it first by tapping on the document in the "Dashboard" screen and tapping the delete icon in the "Document details" view.

## Presentation (Online authentication/Same device) flow.

1. Go to the browser application on your device and enter "https://verifier.eudiw.dev"
2. Tap the first option (selectable) and pick the fields you want to share (e.g. "Family Name" and "Given Name")
3. Tap "Next" and then "Authorize".
4. When asked to open the wallet app tap "Open".
5. You will be returned to the app to the "Request" screen. Tap "Share".
6. Enter the PIN you added in the initial steps.
7. On success tap "Continue".
8. A browser will open showing that the Verifier has accepted your request.
9. Return to the app. You are back to the "Dashboard" screen and the flow is complete.

## Digital Credentails API flow

1. Open the browser application on your device and navigate to "https://verifier.dev.ageverification.dev"
2. Tap on the "DC API" button to initiate the credential sharing flow
3. The system will display the verifier's details and the credential information that will be shared, along with two action buttons: "Accept" and "Close"
4. Tap "Accept" to consent to sharing your credentials, then tap "Authorize" to confirm the transaction
5. The browser will display the verification result with verification checks.