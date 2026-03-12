import Foundation

struct Bible: Codable {
    let books: [Book]
}

struct Book: Codable, Identifiable {
    let id: String
    let name: String
    let chapters: [Chapter]
}

struct Chapter: Codable, Identifiable {
    let id: Int
    let verses: [Verse]
}

struct Verse: Codable, Identifiable {
    let id: Int
    let text: String
}

struct VerseReference: Hashable, Codable {
    let book: String
    let chapter: Int
    let verse: Int
    
    var display: String {
        "\(book) \(chapter):\(verse)"
    }
}

struct Highlight: Identifiable, Codable {
    let id = UUID()
    let reference: VerseReference
    let color: HighlightColor
    let dateCreated: Date
}

enum HighlightColor: String, Codable, CaseIterable {
    case yellow
    case green
    case blue
    case pink
    case orange
    
    var uiColor: String {
        switch self {
        case .yellow: return "yellow"
        case .green: return "green"
        case .blue: return "blue"
        case .pink: return "pink"
        case .orange: return "orange"
        }
    }
}