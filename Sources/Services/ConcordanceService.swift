import Foundation

final class ConcordanceService {
    static let shared = ConcordanceService()
    
    private init() {}
    
    func searchByKeyword(_ keyword: String) -> [(reference: VerseReference, text: String)] {
        return BibleDataService.shared.search(query: keyword)
    }
    
    func searchByTopic(_ topic: Topic) -> [(reference: VerseReference, text: String)] {
        var results: [(VerseReference, String)] = []
        
        for keyword in topic.keywords {
            let topicResults = searchByKeyword(keyword)
            results.append(contentsOf: topicResults)
        }
        
        return Array(Set(results.map { $0.reference.display }).map { display in
            results.first { $0.reference.display == display }!
        })
    }
    
    func getTopicsByVerse(book: String, chapter: Int, verse: Int) -> [Topic] {
        guard let verseText = BibleDataService.shared.getVerse(book: book, chapter: chapter, verse: verse)?.text else {
            return []
        }
        
        let lowerText = verseText.lowercased()
        return defaultTopics.filter { topic in
            topic.keywords.contains { keyword in
                lowerText.contains(keyword.lowercased())
            }
        }
    }
}