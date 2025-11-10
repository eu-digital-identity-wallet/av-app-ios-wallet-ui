# Building the Reference apps to interact with issuing and verifying services.

## Table of contents

* [Overview](#overview)
* [Setup Apps](#setup-apps)

## Overview

This guide aims to assist developers to build the iOS application.

# Setup Apps

## Prerequisites

- macOS with **Xcode 15 or newer**
- Swift 5.9+
- iOS 16.0+ (simulator or physical device)
- Apple Developer Account (if testing on real devices)
- Internet access (for remote issuer/verifier endpoints)

For all configuration options please refer to [this document](configuration.md)

## Clone the Repository

```bash
git clone https://github.com/eu-digital-identity-wallet/av-app-ios-wallet-ui.git
cd av-app-ios-wallet-ui
```

## Install Dependencies

Xcode will automatically resolve dependencies on first build. If needed, you can also force resolve with:

```bash
xcodebuild -resolvePackageDependencies
```

## Build & Run

- Open the project in Xcode
- Choose a simulator or device (iOS 16.0+)
- Press Cmd + R or click run button to build and run the app
