import Foundation

@main
struct ProjectAbideApp: App {
    @State private var isInitialized = false
    
    var body: some Scene {
        WindowGroup {
            if isInitialized {
                TabBarView()
            } else {
                ProgressView()
                    .task {
                        do {
                            try await StorageService.shared.configure()
                            try await BibleDataService.shared.loadBible()
                            isInitialized = true
                        } catch {
                            print("Initialization error: \(error)")
                        }
                    }
            }
        }
    }
}