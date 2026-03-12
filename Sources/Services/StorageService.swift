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
            MemorizationCardItem.self,
            BookmarkItem.self,
            CollectionItem.self,
            ReadingHistoryItem.self,
            StreakItem.self,
            QuizAttempt.self
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

    
    // MARK: - Bookmarks
    
    func saveBookmark(_ bookmark: BookmarkItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(bookmark)
        try context.save()
    }
    
    func fetchBookmarks() throws -> [BookmarkItem] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<BookmarkItem>(sortBy: [SortDescriptor(\.dateCreated, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func deleteBookmark(_ bookmark: BookmarkItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.delete(bookmark)
        try context.save()
    }
    
    // MARK: - Collections
    
    func saveCollection(_ collection: CollectionItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(collection)
        try context.save()
    }
    
    func fetchCollections() throws -> [CollectionItem] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<CollectionItem>(sortBy: [SortDescriptor(\.dateCreated, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func deleteCollection(_ collection: CollectionItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.delete(collection)
        try context.save()
    }
    
    // MARK: - Reading History
    
    func saveReadingHistory(_ history: ReadingHistoryItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(history)
        try context.save()
    }
    
    func fetchReadingHistory() throws -> [ReadingHistoryItem] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<ReadingHistoryItem>(sortBy: [SortDescriptor(\.dateRead, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    // MARK: - Streak
    
    func saveStreak(_ streak: StreakItem) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(streak)
        try context.save()
    }
    
    func fetchStreak() throws -> StreakItem? {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<StreakItem>()
        return try context.fetch(descriptor).first
    }
    
    // MARK: - Quiz Attempts
    
    func saveQuizAttempt(_ attempt: QuizAttempt) throws {
        guard let context = modelContext else { throw StorageError.notConfigured }
        context.insert(attempt)
        try context.save()
    }
    
    func fetchQuizAttempts() throws -> [QuizAttempt] {
        guard let context = modelContext else { throw StorageError.notConfigured }
        let descriptor = FetchDescriptor<QuizAttempt>(sortBy: [SortDescriptor(\.attemptDate, order: .reverse)])
        return try context.fetch(descriptor)
    }