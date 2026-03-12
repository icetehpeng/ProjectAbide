# Project Abide

A comprehensive Christian iOS Bible app designed for deep scripture study, memorization, and spiritual growth.

Abide in me, and I in you. As the branch cannot bear fruit by itself, unless it abides in the vine, neither can you, unless you abide in me. - John 15:4

## Overview

Project Abide provides an interactive Bible experience with powerful study tools, memorization features, and personalization options. Whether you're reading daily devotions, memorizing scripture, or conducting topical studies, Project Abide helps you engage with God's Word.

## Features

### 📖 Bible Reading
- **Interactive Bible** - Smooth navigation through all books, chapters, and verses
- **Multiple Translations** - Support for KJV, ESV, NIV, NKJV
- **Highlights** - Mark verses with 5 customizable colors (yellow, green, blue, pink, orange)
- **Notes** - Attach personal notes to any verse for deeper reflection
- **Bookmarks** - Save favorite verses for quick access
- **Reading History** - Track your reading progress over time

### 🔍 Study Tools
- **Topical Index** - Browse 10 default topics (Love, Faith, Hope, Grace, Salvation, Prayer, Wisdom, Peace, Joy, Strength)
- **Concordance Search** - Full-text search across all verses
- **Verse of the Day** - Daily notifications with featured verses
- **Collections** - Organize bookmarks into custom folders by theme or study

### 🧠 Memorization
- **Verse Memorizer** - Add verses to your memorization queue
- **Spaced Repetition** - SM-2 algorithm for optimal retention
- **Quiz Mode** - Test yourself with flip-card style quizzes
- **Streak Tracking** - Maintain daily streaks and view statistics
- **Progress Stats** - Track correct/incorrect attempts and improvement

### ⚙️ Personalization
- **Dark Mode** - Eye-friendly reading at night
- **Font Customization** - Adjust text size (12-24pt)
- **Font Family** - Choose your preferred font
- **Translation Selection** - Switch between Bible versions instantly
- **Notification Settings** - Customize Verse of the Day timing

### 💾 Data Management
- **Export Notes** - Save notes as text or CSV files
- **Export Highlights** - Export all highlights with metadata
- **Share** - Share exported files via email, messaging, or cloud storage
- **iCloud Sync** - Sync across devices (coming soon)
- **Offline Mode** - Download Bible for offline reading (coming soon)

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- XcodeGen (install via `brew install xcodegen`)
- Swift 5.9+

## Installation

1. Clone the repository
2. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
3. Open the generated project:
   ```bash
   open ProjectAbide.xcodeproj
   ```
4. Add a Bible JSON file to `Resources/` (see below)
5. Build and run in Xcode (Cmd+R)

## Project Structure

```
ProjectAbide/
├── project.yml                  # XcodeGen configuration
├── setup.sh                     # Setup script
├── README.md                    # This file
├── Sources/
│   ├── App/
│   │   └── ProjectAbideApp.swift
│   ├── Models/
│   │   ├── Bible.swift          # Bible data structures
│   │   ├── AppSettings.swift    # User preferences & topics
│   │   └── UserData.swift       # SwiftData models
│   ├── Services/
│   │   ├── BibleDataService.swift       # Bible loading & search
│   │   ├── StorageService.swift         # SwiftData persistence
│   │   ├── SettingsService.swift        # User preferences
│   │   ├── NotificationService.swift    # Push notifications
│   │   ├── ConcordanceService.swift     # Keyword & topic search
│   │   ├── ExportService.swift          # Export functionality
│   │   └── MemorizationService.swift    # Spaced repetition & streaks
│   └── Views/
│       ├── TabBarView.swift             # Main tab navigation
│       ├── BibleView.swift              # Bible reading
│       ├── TopicalIndexView.swift       # Topic browsing
│       ├── MemorizerView.swift          # Memorization cards
│       ├── QuizView.swift               # Quiz mode
│       ├── NotesView.swift              # Notes management
│       └── SettingsView.swift           # Settings & export
└── Resources/
    └── Assets.xcassets/
```

## Adding Bible Data

1. Obtain a Bible JSON file (public domain versions available online)
2. Place it in the `Resources/` folder
3. Name it `kjv_bible.json` (or update `BibleDataService.swift` with your filename)

### Bible JSON Format

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
            {
              "id": 1,
              "text": "In the beginning God created the heaven and the earth."
            },
            {
              "id": 2,
              "text": "And the earth was without form, and void..."
            }
          ]
        }
      ]
    }
  ]
}
```

## Architecture

### Data Persistence
- **SwiftData** for local storage (notes, highlights, bookmarks, collections, reading history, streaks, quiz attempts)
- **UserDefaults** for app settings
- **FileManager** for export functionality

### Services
- **BibleDataService** - Loads and searches Bible data
- **StorageService** - Manages all SwiftData operations
- **SettingsService** - Handles user preferences
- **NotificationService** - Schedules push notifications
- **ConcordanceService** - Performs keyword and topic searches
- **ExportService** - Exports data as text/CSV
- **MemorizationService** - Implements SM-2 spaced repetition algorithm

### UI
- SwiftUI for all views
- Tab-based navigation with 6 main sections
- Responsive design for all iPhone sizes

## Usage

### Reading Scripture
1. Open the **Bible** tab
2. Select a book and chapter
3. Tap a verse to view details
4. Use the bookmark icon to save favorites
5. Highlight verses with your preferred color

### Taking Notes
1. Open the **Notes** tab
2. Tap the + button to create a new note
3. Enter the verse reference and your thoughts
4. Notes are automatically saved

### Memorizing Verses
1. Open the **Memorize** tab
2. Add verses to your memorization queue
3. Review cards daily using the flip-card interface
4. The app uses spaced repetition to optimize learning

### Testing Knowledge
1. Open the **Quiz** tab
2. Answer questions about memorized verses
3. View your score and accuracy percentage
4. Track your progress over time

### Exploring Topics
1. Open the **Topics** tab
2. Select a topic (Love, Faith, Hope, etc.)
3. Browse all related verses
4. Bookmark verses for later study

### Exporting Data
1. Open **Settings** → **Export Notes**
2. Choose format (Text or CSV)
3. Tap Export and share via email or cloud storage

## Roadmap

- [ ] Audio Bible integration (YouVersion API)
- [ ] iCloud sync across devices
- [ ] Offline Bible download
- [ ] Devotional content
- [ ] Bible reading plans
- [ ] Community features (sharing, discussion)
- [ ] Advanced word studies (Greek/Hebrew)
- [ ] Prayer journal
- [ ] Podcast integration

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

MIT License - See LICENSE file for details

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Made with ❤️ for Bible study and spiritual growth**