import Foundation

/// 日付から「その日の単語」を決める。同じ日なら何度呼んでも同じ結果(ウィジェットとアプリで一致)。
/// 奇数日は苦手語を優先、偶数日は通常語を登録順に進める。覚えた語は除外。
enum WordPicker {
    static func dayNumber(_ date: Date, calendar: Calendar = .current) -> Int {
        guard let ref = DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date else { return 0 }
        return calendar.dateComponents([.day], from: ref, to: calendar.startOfDay(for: date)).day ?? 0
    }

    static func word(on date: Date, from words: [Word]) -> Word? {
        let pool = words.filter { $0.status != .mastered }
        guard !pool.isEmpty else { return nil }
        let day = max(dayNumber(date), 0)
        let weak = pool.filter { $0.status == .weak }
        let normal = pool.filter { $0.status != .weak }
        if !weak.isEmpty && (normal.isEmpty || day % 2 == 1) {
            return weak[(day / 2) % weak.count]
        }
        return normal[(day / 2) % normal.count]
    }
}
