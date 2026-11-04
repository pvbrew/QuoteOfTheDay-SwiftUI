# QuoteOfTheDay-SwiftUI

A SwiftUI iOS app that fetches a random quote and lets you save your favourites.

![CI](https://github.com/pvbrew/QuoteOfTheDay-SwiftUI/actions/workflows/ci.yml/badge.svg)

## Features

- Fetch a random quote from a remote API
- Mark quotes as favourites and browse them in a dedicated list
- Loading and error states with retry
- Accessibility support

## Architecture

- **SwiftUI** views (`Views/`)
- **Aggregate model** (`QuoteAggregateModel`) coordinating fetching and favourites
- **Networking** layer built on protocols (`APIClient`, `SessionAdapter`, `URLBuilder`) so every piece can be mocked
- **Storage** for favourite quotes

## Requirements

- Xcode 27+
- iOS 27+

## Getting started

```bash
git clone https://github.com/pvbrew/QuoteOfTheDay-SwiftUI.git
cd QuoteOfTheDay-SwiftUI
open QuoteOfTheDay-SwiftUI.xcodeproj
```

Select the `QuoteOfTheDay-SwiftUI` scheme and run on a simulator.

## Tests

Unit tests use XCTest with protocol-based mocks. Run them with `Cmd+U` in Xcode or:

```bash
xcodebuild test -scheme QuoteOfTheDay-SwiftUI -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## License

Released under the [MIT License](LICENSE).
