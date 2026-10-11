import Foundation

/// 言語の追加は `Language.all` に1行足すだけ。単語側は [言語コード: 文字列] なのでデータ移行は不要。
struct Language: Identifiable, Hashable {
    let code: String
    let name: String
    let short: String
    var id: String { code }

    static let all: [Language] = [
        Language(code: "ja", name: "日本語", short: "JA"),
        Language(code: "en", name: "English", short: "EN"),
        Language(code: "es", name: "Español", short: "ES"),
        Language(code: "fr", name: "Français", short: "FR"),
    ]

    static func name(_ code: String) -> String { all.first { $0.code == code }?.name ?? code }
    static func short(_ code: String) -> String { all.first { $0.code == code }?.short ?? code.uppercased() }
}

enum StudyStatus: String, Codable, CaseIterable {
    case normal, weak, mastered

    var label: String {
        switch self {
        case .normal: return "学習中"
        case .weak: return "苦手"
        case .mastered: return "覚えた"
        }
    }
}

struct Word: Codable, Identifiable, Hashable {
    var id: String
    var translations: [String: String]   // 言語コード → 訳語
    var examples: [String: String]       // 言語コード → 例文
    var status: StudyStatus
    var isBuiltIn: Bool
    var createdAt: Date
    // 将来追加する項目(発音URL、復習回数、最終復習日など)は Optional にして追加すれば旧データも読める

    func text(_ code: String) -> String? {
        let t = translations[code]?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (t?.isEmpty ?? true) ? nil : t
    }

    static func blank() -> Word {
        Word(id: UUID().uuidString, translations: [:], examples: [:],
             status: .normal, isBuiltIn: false, createdAt: Date())
    }
}
