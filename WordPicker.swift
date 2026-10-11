import Foundation

/// 時刻から「その時間の単語」を決める。同じ時間帯なら何度呼んでも同じ結果(ウィジェットとアプリで一致)。
/// 1時間ごとに登録順で次の単語へ進み、最後まで行くと最初に戻る。
enum WordPicker {
    static func hourNumber(_ date: Date, calendar: Calendar = .current) -> Int {
        guard let ref = DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date,
              let hourStart = calendar.dateInterval(of: .hour, for: date)?.start else { return 0 }
        return calendar.dateComponents([.hour], from: ref, to: hourStart).hour ?? 0
    }

    static func word(at date: Date, from words: [Word]) -> Word? {
        guard !words.isEmpty else { return nil }
        let h = max(hourNumber(date), 0)
        return words[h % words.count]
    }
}
