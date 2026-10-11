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
                    Section("今日の単語") {
                        WordRow(word: today, langs: store.displayLangs)
                    }
                }
                Section("単語帳 (\(store.words.count))") {
                    ForEach(filtered) { word in
                        Button { editing = word } label: {
                            WordRow(word: word, langs: store.displayLangs)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .leading) {
                            Button("苦手") { store.setStatus(word.id, .weak) }.tint(.orange)
                            Button("覚えた") { store.setStatus(word.id, .mastered) }.tint(.green)
                        }
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
            HStack {
                Text(lines.first ?? "(未入力)").font(.headline)
                if word.status != .normal {
                    Text(word.status.label)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(word.status == .weak ? Color.orange.opacity(0.25) : Color.green.opacity(0.25))
                        .clipShape(Capsule())
                }
            }
            if lines.count > 1 {
                Text(lines.dropFirst().joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
