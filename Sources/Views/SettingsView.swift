import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsService = SettingsService.shared
    @State private var showNotificationAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Picker("Translation", selection: $settingsService.settings.translation) {
                        ForEach(BibleTranslation.allCases, id: \.self) { translation in
                            Text(translation.rawValue).tag(translation)
                        }
                    }
                    
                    Slider(value: $settingsService.settings.fontSize, in: 12...24, step: 1) {
                        Text("Font Size")
                    }
                    Text("\(Int(settingsService.settings.fontSize))pt")
                        .foregroundStyle(.secondary)
                    
                    Toggle("Dark Mode", isOn: $settingsService.settings.isDarkMode)
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $settingsService.settings.enableNotifications)
                    
                    if settingsService.settings.enableNotifications {
                        DatePicker(
                            "Verse of the Day",
                            selection: $settingsService.settings.verseOfTheDayTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
                
                Section("Data") {
                    NavigationLink("Export Notes", destination: ExportView())
                    NavigationLink("Bookmarks", destination: BookmarksView())
                    NavigationLink("Collections", destination: CollectionsView())
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ExportView: View {
    @State private var exportFormat: ExportFormat = .text
    @State private var showShareSheet = false
    @State private var fileURL: URL?
    
    enum ExportFormat: String, CaseIterable {
        case text = "Text"
        case csv = "CSV"
    }
    
    var body: some View {
        List {
            Section("Format") {
                Picker("Export As", selection: $exportFormat) {
                    ForEach(ExportFormat.allCases, id: \.self) { format in
                        Text(format.rawValue).tag(format)
                    }
                }
            }
            
            Section {
                Button(action: exportData) {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationTitle("Export")
        .sheet(isPresented: $showShareSheet) {
            if let fileURL = fileURL {
                ShareSheet(items: [fileURL])
            }
        }
    }
    
    private func exportData() {
        Task {
            do {
                let notes = try await StorageService.shared.fetchNotes()
                let content = exportFormat == .text ?
                    ExportService.shared.exportNotesAsText(notes: notes) :
                    ExportService.shared.exportAsCSV(notes: notes)
                
                let filename = "ProjectAbide_Export_\(Date().formatted(date: .numeric, time: .omitted)).\(exportFormat == .text ? "txt" : "csv")"
                
                if let url = ExportService.shared.saveToFile(content, filename: filename) {
                    fileURL = url
                    showShareSheet = true
                }
            } catch {
                print("Export error: \(error)")
            }
        }
    }
}

struct BookmarksView: View {
    @State private var bookmarks: [BookmarkItem] = []
    
    var body: some View {
        List {
            if bookmarks.isEmpty {
                ContentUnavailableView(
                    "No Bookmarks",
                    systemImage: "bookmark",
                    description: Text("Bookmark verses to save them for later")
                )
            } else {
                ForEach(bookmarks) { bookmark in
                    Text("\(bookmark.book) \(bookmark.chapter):\(bookmark.verse)")
                }
                .onDelete(perform: deleteBookmark)
            }
        }
        .navigationTitle("Bookmarks")
        .task {
            do {
                bookmarks = try await StorageService.shared.fetchBookmarks()
            } catch {
                print("Error fetching bookmarks: \(error)")
            }
        }
    }
    
    private func deleteBookmark(at offsets: IndexSet) {
        Task {
            for index in offsets {
                try await StorageService.shared.deleteBookmark(bookmarks[index])
            }
            bookmarks.remove(atOffsets: offsets)
        }
    }
}

struct CollectionsView: View {
    @State private var collections: [CollectionItem] = []
    @State private var showNewCollection = false
    
    var body: some View {
        List {
            if collections.isEmpty {
                ContentUnavailableView(
                    "No Collections",
                    systemImage: "folder",
                    description: Text("Create collections to organize your bookmarks")
                )
            } else {
                ForEach(collections) { collection in
                    NavigationLink(destination: CollectionDetailView(collection: collection)) {
                        VStack(alignment: .leading) {
                            Text(collection.name)
                                .font(.headline)
                            Text("\(collection.bookmarks.count) verses")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteCollection)
            }
        }
        .navigationTitle("Collections")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showNewCollection = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewCollection) {
            NewCollectionView(onSave: { collection in
                collections.append(collection)
            })
        }
        .task {
            do {
                collections = try await StorageService.shared.fetchCollections()
            } catch {
                print("Error fetching collections: \(error)")
            }
        }
    }
    
    private func deleteCollection(at offsets: IndexSet) {
        Task {
            for index in offsets {
                try await StorageService.shared.deleteCollection(collections[index])
            }
            collections.remove(atOffsets: offsets)
        }
    }
}

struct CollectionDetailView: View {
    let collection: CollectionItem
    
    var body: some View {
        List {
            ForEach(collection.bookmarks) { bookmark in
                Text("\(bookmark.book) \(bookmark.chapter):\(bookmark.verse)")
            }
        }
        .navigationTitle(collection.name)
    }
}

struct NewCollectionView: View {
    let onSave: (CollectionItem) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Collection Name", text: $name)
                TextField("Description", text: $description)
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let collection = CollectionItem(name: name, description: description)
                        onSave(collection)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
}