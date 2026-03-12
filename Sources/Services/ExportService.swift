import Foundation

final class ExportService {
    static let shared = ExportService()
    
    private init() {}
    
    func exportNotesAsText(notes: [NoteItem]) -> String {
        var text = "Project Abide - Notes Export\n"
        text += "Exported: \(Date().formatted())\n"
        text += String(repeating: "=", count: 50) + "\n\n"
        
        for note in notes {
            text += "Verse: \(note.verseReference)\n"
            text += "Date: \(note.date.formatted())\n"
            text += "Note: \(note.content)\n"
            text += String(repeating: "-", count: 50) + "\n\n"
        }
        
        return text
    }
    
    func exportHighlightsAsText(highlights: [HighlightItem]) -> String {
        var text = "Project Abide - Highlights Export\n"
        text += "Exported: \(Date().formatted())\n"
        text += String(repeating: "=", count: 50) + "\n\n"
        
        for highlight in highlights {
            text += "Reference: \(highlight.book) \(highlight.chapter):\(highlight.verse)\n"
            text += "Color: \(highlight.color)\n"
            text += "Date: \(highlight.dateCreated.formatted())\n"
            text += String(repeating: "-", count: 50) + "\n\n"
        }
        
        return text
    }
    
    func exportAsCSV(notes: [NoteItem]) -> String {
        var csv = "Verse Reference,Date,Note\n"
        
        for note in notes {
            let escapedContent = note.content.replacingOccurrences(of: "\"", with: "\"\"")
            csv += "\"\(note.verseReference)\",\"\(note.date.formatted())\",\"\(escapedContent)\"\n"
        }
        
        return csv
    }
    
    func saveToFile(_ content: String, filename: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error saving file: \(error.localizedDescription)")
            return nil
        }
    }
}