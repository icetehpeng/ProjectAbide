import Foundation

struct AppSettings: Codable {
    var translation: BibleTranslation = .kjv
    var fontSize: Double = 16
    var isDarkMode: Bool = false
    var fontFamily: String = "System"
    var enableNotifications: Bool = true
    var verseOfTheDayTime: Date = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
}

enum BibleTranslation: String, Codable, CaseIterable {
    case kjv = "King James Version"
    case esv = "English Standard Version"
    case niv = "New International Version"
    case nkjv = "New King James Version"
    
    var id: String {
        self.rawValue
    }
}

struct Topic: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let keywords: [String]
}

let defaultTopics: [Topic] = [
    Topic(id: "love", name: "Love", description: "God's love and loving others", keywords: ["love", "beloved", "charity"]),
    Topic(id: "faith", name: "Faith", description: "Trust and belief in God", keywords: ["faith", "believe", "trust"]),
    Topic(id: "hope", name: "Hope", description: "Hope in God's promises", keywords: ["hope", "promise", "future"]),
    Topic(id: "grace", name: "Grace", description: "God's unmerited favor", keywords: ["grace", "mercy", "forgive"]),
    Topic(id: "salvation", name: "Salvation", description: "Redemption through Christ", keywords: ["salvation", "saved", "redeem"]),
    Topic(id: "prayer", name: "Prayer", description: "Communication with God", keywords: ["prayer", "pray", "petition"]),
    Topic(id: "wisdom", name: "Wisdom", description: "God's wisdom and understanding", keywords: ["wisdom", "wise", "knowledge"]),
    Topic(id: "peace", name: "Peace", description: "Peace in Christ", keywords: ["peace", "calm", "tranquil"]),
    Topic(id: "joy", name: "Joy", description: "Joy and rejoicing", keywords: ["joy", "rejoice", "glad"]),
    Topic(id: "strength", name: "Strength", description: "God's strength and power", keywords: ["strength", "strong", "mighty"])
]