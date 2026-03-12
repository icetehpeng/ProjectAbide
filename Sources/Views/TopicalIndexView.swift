import SwiftUI

struct TopicalIndexView: View {
    @State private var selectedTopic: Topic?
    @State private var searchResults: [(reference: VerseReference, text: String)] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(defaultTopics) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        VStack(alignment: .leading) {
                            Text(topic.name)
                                .font(.headline)
                            Text(topic.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Topics")
        }
    }
}

struct TopicDetailView: View {
    let topic: Topic
    @State private var results: [(reference: VerseReference, text: String)] = []
    @State private var isLoading = true
    
    var body: some View {
        List {
            if isLoading {
                ProgressView()
            } else if results.isEmpty {
                ContentUnavailableView(
                    "No Verses Found",
                    systemImage: "book",
                    description: Text("No verses match this topic")
                )
            } else {
                ForEach(results, id: \.reference.display) { result in
                    NavigationLink(destination: VerseDetailView(reference: result.reference)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.reference.display)
                                .font(.headline)
                            Text(result.text)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .navigationTitle(topic.name)
        .task {
            results = ConcordanceService.shared.searchByTopic(topic)
            isLoading = false
        }
    }
}

struct VerseDetailView: View {
    let reference: VerseReference
    @State private var verseText: String = ""
    @State private var isBookmarked = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(reference.display)
                    .font(.headline)
                
                Text(verseText)
                    .font(.body)
                    .lineSpacing(6)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Verse")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: toggleBookmark) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
            }
        }
        .task {
            let parts = reference.display.split(separator: " ")
            if parts.count >= 2 {
                let book = String(parts[0])
                let chapterVerse = String(parts[1]).split(separator: ":")
                if let chapter = Int(chapterVerse[0]), let verse = Int(chapterVerse[1]) {
                    if let text = BibleDataService.shared.getVerse(book: book, chapter: chapter, verse: verse)?.text {
                        verseText = text
                    }
                }
            }
        }
    }
    
    private func toggleBookmark() {
        isBookmarked.toggle()
    }
}

#Preview {
    TopicalIndexView()
}