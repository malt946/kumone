<div align="right">

**English** | [简体中文](README_CN.md)

</div>

<div align="center">

# SkyHeight

**A SwiftUI iOS app · Query Sky: Children of the Light character height · Tools and a membership store**

</div>

## Overview

SkyHeight is an iOS utility app for players of *Sky: Children of the Light (光·遇)*. It offers height queries, handy tools, and a membership service. This repository is currently a **shell**: the navigation structure, page skeletons, and the first-launch agreement flow are in place; the business logic and APIs will be added later.

> Internal module names (`KumoneCore`, `KumoneIOSFeature`) are temporary placeholders left over from the migration and will be renamed later. The user-facing name is already "光遇身高".

## Features

The app has four main tabs behind a draggable, floating glass tab bar:

| Tab | Description |
| --- | --- |
| **Query** | Enter a friend code / nickname to see height and body type, plus query history |
| **Tools** | Height converter, body-type chart, candle calculator, season progress, ancestor guide, and more |
| **Store** | Membership benefits and plans (monthly / quarterly / yearly / lifetime) |
| **Profile** | Profile info, membership status (start / expiry / remaining days), and settings |

On **first launch**, a user-agreement and privacy-policy consent screen is shown; the app requires agreement before use.

## Build

Requires macOS with Xcode 16+, targeting iOS 16.0+.

```bash
# Regenerate the project if ios/project.yml changed (requires xcodegen)
make project

# Build for the simulator
make ios-build

# Or open ios/KumoneIOS.xcworkspace in Xcode and run
```

Equivalent command line:

```bash
cd ios && xcodegen generate
xcodebuild build \
  -project ios/KumoneIOS.xcodeproj \
  -scheme KumoneIOS \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Project layout

```
Sources/Kumone/
├── App/                 # Entry point, root tab view, floating tab bar, agreement screen
├── Sky/                 # Domain models + pages
│   ├── Core/            # Models, session, settings, toast (local mock for now)
│   └── Views/           # Query / Tools / Store / Profile pages
├── DesignSystem/        # Theme tokens and button styles
└── Resources/           # Localizations and privacy manifest

ios/
├── Config/              # Info.plist, entitlements, xcconfig
├── KumoneIOS/           # Xcode app shell (entry point only)
├── KumoneIOSPackage/    # Swift package holding all feature code
└── project.yml          # XcodeGen project description
```

## Notes

This project is for learning and exchange only, and is not affiliated with *Sky: Children of the Light* or thatgamecompany. The app name and bundle ID are placeholders — replace them before shipping.
