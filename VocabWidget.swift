import WidgetKit
import SwiftUI

struct VocabEntry: TimelineEntry {
    let date: Date
    let word: Word?
    let langs: [String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> VocabEntry {
        VocabEntry(date: Date(), word: SeedWords.all.first, langs: ["ja", "en", "es", "fr"])
    }

    func getSnapshot(in context: Context, completion: @escaping (VocabEntry) -> Void) {
        let words = SharedStore.loadWords()
        completion(VocabEntry(date: Date(), word: WordPicker.word(on: Date(), from: words),
                              langs: SharedStore.displayLangs))
    }

    /// 今日 + 以降7日分のエントリを先に作り、日付が変わるタイミングでiOSに切り替えてもらう。
    func getTimeline(in context: Context, completion: @escaping (Timeline<VocabEntry>) -> Void) {
        let words = SharedStore.loadWords()
        let langs = SharedStore.displayLangs
        let cal = Calendar.current
        let now = Date()
        let start = cal.startOfDay(for: now)

        var entries = [VocabEntry(date: now, word: WordPicker.word(on: now, from: words), langs: langs)]
        for d in 1...7 {
            if let day = cal.date(byAdding: .day, value: d, to: start) {
                entries.append(VocabEntry(date: day, word: WordPicker.word(on: day, from: words), langs: langs))
            }
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct VocabWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: VocabEntry

    var body: some View {
        let lines: [(String, String)] = entry.langs.compactMap { code in
            entry.word?.text(code).map { (Language.short(code), $0) }
        }

        if lines.isEmpty {
            Text("単語を追加")
        } else {
            switch family {
            case .accessoryInline:
                Text(lines.prefix(2).map { $0.1 }.joined(separator: " · "))

            case .accessoryCircular:
                ZStack {
                    AccessoryWidgetBackground()
                    Text(lines[0].1)
                        .font(.caption)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(4)
                }

            case .accessoryRectangular:
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(Array(lines.prefix(4).enumerated()), id: \.offset) { i, line in
                        HStack(spacing: 4) {
                            Text(line.0)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .frame(width: 18, alignment: .leading)
                            Text(line.1)
                                .font(.system(size: i == 0 ? 13 : 12, weight: i == 0 ? .bold : .regular))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            default:
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(lines.prefix(4).enumerated()), id: \.offset) { i, line in
                        HStack(spacing: 6) {
                            Text(line.0).font(.caption2).foregroundStyle(.secondary)
                                .frame(width: 24, alignment: .leading)
                            Text(line.1)
                                .font(i == 0 ? .title3.bold() : .body)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct VocabWidget: Widget {
    let kind = "VocabWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VocabWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("今日の単語")
        .description("1日1語を複数言語でまとめて表示します。")
        .supportedFamilies([.accessoryRectangular, .accessoryInline, .accessoryCircular,
                            .systemSmall, .systemMedium])
    }
}

@main
struct LockVocabWidgetBundle: WidgetBundle {
    var body: some Widget {
        VocabWidget()
    }
}
