import Foundation

final class BibleDataService {
    static let shared = BibleDataService()
    private(set) var bible: Bible?
    
    private init() {}
    
    func loadBible() async throws {
        guard let url = Bundle.main.url(forResource: "kjv_bible", withExtension: "json") else {
            throw BibleError.resourceNotFound
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        bible = try decoder.decode(Bible.self, from: data)
    }
    
    func getVerses(book: String, chapter: Int) -> [Verse]? {
        guard let bookData = bible?.books.first(where: { $0.name == book }) else {
            return nil
        }
        guard chapter > 0 && chapter <= bookData.chapters.count else {
            return nil
        }
        return bookData.chapters[chapter - 1].verses
    }
    
    func getVerse(book: String, chapter: Int, verse: Int) -> Verse? {
        guard let verses = getVerses(book: book, chapter: chapter) else {
            return nil
        }
        return verses.first { $0.id == verse }
    }
    
    func search(query: String) -> [(reference: VerseReference, text: String)] {
        guard let bible = bible else { return [] }
        var results: [(VerseReference, String)] = []
        
        for book in bible.books {
            for (chapterIndex, chapter) in book.chapters.enumerated() {
                for verse in chapter.verses {
                    if verse.text.localizedCaseInsensitiveContains(query) {
                        let reference = VerseReference(
                            book: book.name,
                            chapter: chapterIndex + 1,
                            verse: verse.id
                        )
                        results.append((reference, verse.text))
                    }
                }
            }
        }
        return results
    }
}

enum BibleError: LocalizedError {
    case resourceNotFound
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return "Bible data file not found"
        case .parsingError:
            return "Failed to parse Bible data"
        }
    }
}