import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            BibleView()
                .tabItem { Label("Bible", systemImage: "book.fill") }
            
            MemorizerView()
                .tabItem { Label("Memorize", systemImage: "brain.head.profile") }
            
            NotesView()
                .tabItem { Label("Notes", systemImage: "note.text") }
        }
    }
}

#Preview {
    TabBarView()
}