import SwiftUI
import WidgetKit

@MainActor
final class WordStore: ObservableObject {
    @Published private(set) var words: [Word]
    @Published private(set) var displayLangs: [String]

    init() {
        words = SharedStore.loadWords()
        displayLangs = SharedStore.displayLangs
        persist()   // 初回起動時に初期単語をApp Groupへ書き出す
    }

    var todaysWord: Word? { WordPicker.word(on: Date(), from: words) }

    func upsert(_ word: Word) {
        if let i = words.firstIndex(where: { $0.id == word.id }) {
            words[i] = word
        } else {
            words.append(word)
        }
        persist()
    }

    func delete(ids: [String]) {
        words.removeAll { ids.contains($0.id) }
        persist()
    }

    func setStatus(_ id: String, _ status: StudyStatus) {
        guard let i = words.firstIndex(where: { $0.id == id }) else { return }
        words[i].status = status
        persist()
    }

    func setLangs(_ langs: [String]) {
        guard !langs.isEmpty else { return }
        displayLangs = langs
        SharedStore.displayLangs = langs
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func persist() {
        SharedStore.saveWords(words)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
