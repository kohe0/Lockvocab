import Foundation

/// アプリ本体とウィジェットの両方から使う保存層(App Group内のJSONファイル + UserDefaults)
enum SharedStore {
    private static let encoder: JSONEncoder = {
        let e = JSONEncoder(); e.dateEncodingStrategy = .iso8601; return e
    }()
    private static let decoder: JSONDecoder = {
        let d = JSONDecoder(); d.dateDecodingStrategy = .iso8601; return d
    }()

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: AppGroup.id) ?? .standard
    }

    private static var fileURL: URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppGroup.id)?
            .appendingPathComponent("words.json")
    }

    static func loadWords() -> [Word] {
        if let url = fileURL,
           let data = try? Data(contentsOf: url),
           let words = try? decoder.decode([Word].self, from: data) {
            return words
        }
        return SeedWords.all
    }

    static func saveWords(_ words: [Word]) {
        guard let url = fileURL, let data = try? encoder.encode(words) else { return }
        try? data.write(to: url, options: .atomic)
    }

    static var displayLangs: [String] {
        get { defaults.stringArray(forKey: "displayLangs") ?? ["ja", "en", "es", "fr"] }
        set { defaults.set(newValue, forKey: "displayLangs") }
    }
}
