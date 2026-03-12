import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            BibleView()
                .tabItem { Label("Bible", systemImage: "book.fill") }
            
            TopicalIndexView()
                .tabItem { Label("Topics", systemImage: "tag.fill") }
            
            MemorizerView()
                .tabItem { Label("Memorize", systemImage: "brain.head.profile") }
            
            QuizView()
                .tabItem { Label("Quiz", systemImage: "questionmark.circle") }
            
            NotesView()
                .tabItem { Label("Notes", systemImage: "note.text") }
            
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    TabBarView()
}