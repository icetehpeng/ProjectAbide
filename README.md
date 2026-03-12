# Project Abide

A Christian iOS Bible app with interactive features for studying scripture.

## Features

- **Interactive Bible** - Read and navigate through scripture
- **Highlights** - Mark verses with customizable colors
- **Notes** - Take personal notes linked to specific verses
- **Verse Memorizer** - Spaced repetition system for memorizing scripture
- **Audio Playback** - Text-to-speech support (coming soon)

## Requirements

- iOS 17.0+
- Xcode 15.0+
- XcodeGen (`brew install xcodegen`)

## Setup

```bash
chmod +x setup.sh
./setup.sh
open ProjectAbide.xcodeproj
```

## Project Structure

```
Sources/
├── App/                 # App entry point
├── Models/              # Data models (Bible, Verse, Note, etc.)
├── Services/            # Business logic (BibleDataService, StorageService)
└── Views/               # SwiftUI views
```

## Adding Bible Data

Place a Bible JSON file (e.g., `kjv_bible.json`) in Resources and name it `kjv_bible.json`. The file should follow this structure:

```json
{
  "books": [
    {
      "id": "genesis",
      "name": "Genesis",
      "chapters": [
        {
          "id": 1,
          "verses": [
            {"id": 1, "text": "In the beginning..."}
          ]
        }
      ]
    }
  ]
}
```

## License

MIT