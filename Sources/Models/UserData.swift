import Foundation
import SwiftData

@Model
final class BookmarkItem {
    var book: String
    var chapter: Int
    var verse: Int
    var dateCreated: Date
    
    init(book: String, chapter: Int, verse: Int, dateCreated: Date = Date()) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.dateCreated = dateCreated
    }
}

@Model
final class CollectionItem {
    var name: String
    var description: String
    var bookmarks: [BookmarkItem]
    var dateCreated: Date
    
    init(name: String, description: String = "", bookmarks: [BookmarkItem] = [], dateCreated: Date = Date()) {
        self.name = name
        self.description = description
        self.bookmarks = bookmarks
        self.dateCreated = dateCreated
    }
}

@Model
final class ReadingHistoryItem {
    var book: String
    var chapter: Int
    var verse: Int
    var dateRead: Date
    
    init(book: String, chapter: Int, verse: Int, dateRead: Date = Date()) {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.dateRead = dateRead
    }
}

@Model
final class StreakItem {
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActivityDate: Date?
    var totalDaysActive: Int = 0
    
    init() {}
}

@Model
final class QuizAttempt {
    var cardId: String
    var isCorrect: Bool
    var attemptDate: Date
    
    init(cardId: String, isCorrect: Bool, attemptDate: Date = Date()) {
        self.cardId = cardId
        self.isCorrect = isCorrect
        self.attemptDate = attemptDate
    }
}