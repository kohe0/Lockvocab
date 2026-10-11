import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: WordStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("ロック画面に表示する言語(4つ程度が見やすい)") {
                    ForEach(Language.all) { lang in
                        Toggle(lang.name, isOn: Binding(
                            get: { store.displayLangs.contains(lang.code) },
                            set: { on in
                                var l = store.displayLangs
                                if on {
                                    if !l.contains(lang.code) { l.append(lang.code) }
                                } else {
                                    l.removeAll { $0 == lang.code }
                                }
                                store.setLangs(l)   // 空になる場合は無視される
                            }
                        ))
                    }
                }
                Section("最上段に出す言語") {
                    Picker("主言語", selection: Binding(
                        get: { store.displayLangs.first ?? "ja" },
                        set: { code in
                            var l = store.displayLangs.filter { $0 != code }
                            l.insert(code, at: 0)
                            store.setLangs(l)
                        }
                    )) {
                        ForEach(store.displayLangs, id: \.self) { Text(Language.name($0)).tag($0) }
                    }
                }
                Section {
                    Text("単語は1時間ごとに切り替わりますが、実際の切り替えタイミングはiOSが決めるため、数分ずれることがあります。設定変更や単語の編集後も、反映に少し時間がかかることがあります。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") { dismiss() }
                }
            }
        }
    }
}
