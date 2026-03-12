import Foundation

final class SettingsService: ObservableObject {
    static let shared = SettingsService()
    
    @Published var settings: AppSettings {
        didSet {
            save()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "appSettings"
    
    private init() {
        if let data = userDefaults.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = AppSettings()
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: settingsKey)
        }
    }
    
    func updateTranslation(_ translation: BibleTranslation) {
        settings.translation = translation
    }
    
    func updateFontSize(_ size: Double) {
        settings.fontSize = size
    }
    
    func toggleDarkMode() {
        settings.isDarkMode.toggle()
    }
    
    func updateFontFamily(_ family: String) {
        settings.fontFamily = family
    }
    
    func updateNotifications(_ enabled: Bool) {
        settings.enableNotifications = enabled
    }
}