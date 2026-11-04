# QuoteOfTheDay-SwiftUI

[![CI](https://github.com/pvbrew/QuoteOfTheDay-SwiftUI/actions/workflows/ci.yml/badge.svg)](https://github.com/pvbrew/QuoteOfTheDay-SwiftUI/actions/workflows/ci.yml)
![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A SwiftUI quote app using the MV (Observable models) pattern, showing random quotes via the public [ZenQuotes](https://zenquotes.io) API.

<!-- TODO: add screenshots / demo GIF, e.g. docs/screenshots/main.png -->

## Features

- Fetch a random quote from the ZenQuotes API
- Save quotes to a favourites list and remove them again
- Loading and error states with a retry path
- Accessibility labels for VoiceOver

## Architecture

The app follows the **MV** pattern: views bind directly to an `@Observable` model, and there are no view models.

| Layer | Responsibility |
| --- | --- |
| `Views` | SwiftUI views (`MainView`, `QuoteView`, `FavouritesView`, loading and error views) |
| `AggregateModels` | `QuoteAggregateModel`: `@Observable` model holding app state and business logic |
| `APIClient` | Fetches and decodes quotes |
| `Adapters` / `URLSession` | Thin protocol wrapper around `URLSession` so networking can be mocked |
| `Builders` | `URLBuilder` builds endpoint URLs |
| `Storage` | Favourite quote persistence |
| `Models` | `Quote` (`Codable`) |

Dependencies are injected through protocols (`URLBuildable`, the session adapter, the API client), so every layer can be tested in isolation with mocks.

## Tech stack

- Swift, SwiftUI
- Observation framework (`@Observable`)
- async/await, `URLSession`
- XCTest (unit and UI tests)
- GitHub Actions

## Requirements

- Xcode 27 or later
- iOS 27.0 or later (current deployment target)

## Getting started

```bash
git clone https://github.com/pvbrew/QuoteOfTheDay-SwiftUI.git
cd QuoteOfTheDay-SwiftUI
open QuoteOfTheDay-SwiftUI.xcodeproj
```

Select the `QuoteOfTheDay-SwiftUI` scheme and run on an iPhone simulator. No API key is needed.

## Tests

In Xcode press `⌘U`, or from the command line:

```bash
xcodebuild test \
  -project QuoteOfTheDay-SwiftUI.xcodeproj \
  -scheme QuoteOfTheDay-SwiftUI \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:QuoteOfTheDay-SwiftUITests
```

Unit tests cover the API client, session adapter, URL builder, aggregate model and `Quote` decoding, using protocol-based mocks and JSON fixtures.

## Attribution

Quotes provided by [ZenQuotes.io](https://zenquotes.io).

## License

Released under the [MIT License](LICENSE).
