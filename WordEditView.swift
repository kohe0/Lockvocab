import SwiftUI

struct WordEditView: View {
    @EnvironmentObject private var store: WordStore
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Word

    init(word: Word) {
        _draft = State(initialValue: word)
    }

    private func binding(_ keyPath: WritableKeyPath<Word, [String: String]>, _ code: String) -> Binding<String> {
        Binding(
            get: { draft[keyPath: keyPath][code] ?? "" },
            set: { draft[keyPath: keyPath][code] = $0 }
        )
    }

    private var canSave: Bool {
        draft.translations.values.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        NavigationStack {
            Form {
                ForEach(Language.all) { lang in
                    Section(lang.name) {
                        TextField("訳語", text: binding(\.translations, lang.code))
                        TextField("例文", text: binding(\.examples, lang.code), axis: .vertical)
                    }
                }
            }
            .navigationTitle("単語")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        var w = draft
                        w.translations = w.translations.filter { !$0.value.trimmingCharacters(in: .whitespaces).isEmpty }
                        w.examples = w.examples.filter { !$0.value.trimmingCharacters(in: .whitespaces).isEmpty }
                        store.upsert(w)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
