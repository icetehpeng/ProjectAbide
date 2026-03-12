import SwiftUI

struct NotesView: View {
    @State private var notes: [Note] = [
        Note(verseReference: "John 3:16", content: "God's love is unconditional...")
    ]
    @State private var showingNewNote = false
    
    var body: some View {
        NavigationStack {
            List {
                if notes.isEmpty {
                    ContentUnavailableView(
                        "No Notes",
                        systemImage: "note.text",
                        description: Text("Start taking notes on verses")
                    )
                } else {
                    ForEach(notes) { note in
                        NoteRowView(note: note)
                    }
                    .onDelete(perform: deleteNotes)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NoteEditorView(note: nil, onSave: { newNote in
                    notes.append(newNote)
                })
            }
        }
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.verseReference)
                .font(.headline)
            Text(note.content)
                .font(.body)
                .foregroundStyle(.secondary)
            Text(note.date, style: .date)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

struct Note: Identifiable, Codable {
    let id = UUID()
    let verseReference: String
    let content: String
    let date: Date
}

struct NoteEditorView: View {
    let note: Note?
    let onSave: (Note) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var verseReference: String = ""
    @State private var content: String = ""
    
    init(note: Note?, onSave: @escaping (Note) -> Void) {
        self.note = note
        self.onSave = onSave
        if let note = note {
            _verseReference = State(initialValue: note.verseReference)
            _content = State(initialValue: note.content)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Verse Reference") {
                    TextField("e.g., John 3:16", text: $verseReference)
                }
                Section("Note") {
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(note == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newNote = Note(
                            verseReference: verseReference,
                            content: content,
                            date: Date()
                        )
                        onSave(newNote)
                        dismiss()
                    }
                    .disabled(verseReference.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NotesView()
}