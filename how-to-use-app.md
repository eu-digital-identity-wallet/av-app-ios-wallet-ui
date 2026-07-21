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

## Issuance and presentation

To test the app, there is an issuer and verifier service available online. This allows you to perform the enrollment directly from within the app or via the online issuer in order to receive a proof of age attestation. With the verifier, you can then present this attestation.

A step-by-step guide covering installation, issuing and presenting a proof of age attestation using the online test/demo services is available at [Getting started](https://ageverification.dev/Getting%20started/app_installation/).