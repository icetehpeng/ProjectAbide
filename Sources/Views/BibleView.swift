import SwiftUI

struct BibleView: View {
    @State private var selectedBook: String = "Genesis"
    @State private var selectedChapter: Int = 1
    
    var body: some View {
        NavigationStack {
            List {
                Section("Book") {
                    Text(selectedBook)
                }
                Section("Chapter") {
                    Text("Chapter \(selectedChapter)")
                }
                Section("Verses") {
                    ForEach(1...50, id: \.self) { verse in
                        VerseRowView(verseNumber: verse)
                    }
                }
            }
            .navigationTitle("Bible")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "speaker.wave.2")
                    }
                }
            }
        }
    }
}

struct VerseRowView: View {
    let verseNumber: Int
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(verseNumber)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 30)
            Text("Verse \(verseNumber) content will go here...")
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    BibleView()
}