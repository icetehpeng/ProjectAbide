import Foundation
import SwiftData

@MainActor
final class StorageService {
    static let shared = StorageService()
    
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    private init() {}
    
    func configure() throws {
        let schema = Schema([
            NoteItem.self,
            HighlightItem.self,
            MemorizationCardItem.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        modelContext = modelContainer?.mainContext
    }
    
    // MARK: - Notes
    
    func saveNote(_ note: NoteItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(note)
        try context.save()
    }
    
    func fetchNotes() throws -> [NoteItem] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<NoteItem>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func deleteNote(_ note: NoteItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.delete(note)
        try context.save()
    }
    
    // MARK: - Highlights
    
    func saveHighlight(_ highlight: HighlightItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(highlight)
        try context.save()
    }
    
    func fetchHighlights() throws -> [HighlightItem] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<HighlightItem>(sortBy: [SortDescriptor(\.dateCreated)])
        return try context.fetch(descriptor)
    }
    
    func deleteHighlight(_ highlight: HighlightItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.delete(highlight)
        try context.save()
    }
    
    // MARK: - Memorization Cards
    
    func saveCard(_ card: MemorizationCardItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(card)
        try context.save()
    }
    
    func fetchCards() throws -> [MemorizationCardItem] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<MemorizationCardItem>(sortBy: [SortDescriptor(\.nextReviewDate)])
        return try context.fetch(descriptor)
    }
    
    func updateCard(_ card: MemorizationCardItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        try context.save()
    }
    
    func deleteCard(_ card: MemorizationCardItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.delete(card)
        try context.save()
    }
}

enum StorageError: LocalizedError {
    case notConfigured
    
    var errorDescription: String? {
        "Storage service not configured"
    }
}

// MARK: - SwiftData Models

@Model
final class NoteItem {
    var verseReference: String
    var content: String
    var date: Date
    
    init(verseReference: String, content: String, date: Date = Date()) {
        self.verseReference = verseReference
        self.content = content
        self.date = date
    }
}

@Model
final class HighlightItem {
    var book: String
    var chapter: Int
    var verse: Int
    var color: String
    var dateCreated: Date
    
    init(book: String, chapter: Int, verse: Int, color: String, dateCreated: Date = Date()) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.color = color
        self.dateCreated = dateCreated
    }
}

@Model
final class MemorizationCardItem {
    var reference: String
    var text: String
    var nextReviewDate: Date
    var easeFactor: Double
    var interval: Int
    var repetitions: Int
    
    init(reference: String, text: String) {
        self.reference = reference
        self.text = text
        self.nextReviewDate = Date()
        self.easeFactor = 2.5
        self.interval = 0
        self.repetitions = 0
    }
}