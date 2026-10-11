import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: WordStore
    @State private var editing: Word?
    @State private var showSettings = false
    @State private var search = ""

    private var filtered: [Word] {
        guard !search.isEmpty else { return store.words }
        return store.words.filter { w in
            w.translations.values.contains { $0.localizedCaseInsensitiveContains(search) }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if let today = store.todaysWord {
                    Section("いまの単語") {
                        WordRow(word: today, langs: store.displayLangs)
                    }
                }
                Section("単語帳 (\(store.words.count))") {
                    ForEach(filtered) { word in
                        Button { editing = word } label: {
                            WordRow(word: word, langs: store.displayLangs)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        let list = filtered
                        store.delete(ids: offsets.map { list[$0].id })
                    }
                }
            }
            .navigationTitle("LockVocab")
            .searchable(text: $search)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { showSettings = true } label: { Image(systemName: "gearshape") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { editing = Word.blank() } label: { Image(systemName: "plus") }
                }
            }
            .sheet(item: $editing) { word in
                WordEditView(word: word)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct WordRow: View {
    let word: Word
    let langs: [String]

    var body: some View {
        let lines = langs.compactMap { word.text($0) }
        VStack(alignment: .leading, spacing: 2) {
            Text(lines.first ?? "(未入力)").font(.headline)
            if lines.count > 1 {
                Text(lines.dropFirst().joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
