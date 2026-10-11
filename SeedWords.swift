import Foundation

/// 初期収録の基本単語(日・英・西・仏)。例文は空なのでアプリ内で追加できる。
enum SeedWords {
    static let all: [Word] = rows.enumerated().map { i, r in
        Word(id: String(format: "seed-%03d", i + 1),
             translations: ["ja": r[0], "en": r[1], "es": r[2], "fr": r[3]],
             examples: [:], isBuiltIn: true,
             createdAt: Date(timeIntervalSince1970: 0))
    }

    private static let rows: [[String]] = [
        ["猫", "cat", "gato", "chat"],
        ["犬", "dog", "perro", "chien"],
        ["水", "water", "agua", "eau"],
        ["本", "book", "libro", "livre"],
        ["家", "house", "casa", "maison"],
        ["学校", "school", "escuela", "école"],
        ["友達", "friend", "amigo", "ami"],
        ["食べ物", "food", "comida", "nourriture"],
        ["時間", "time", "tiempo", "temps"],
        ["愛", "love", "amor", "amour"],
        ["太陽", "sun", "sol", "soleil"],
        ["月", "moon", "luna", "lune"],
        ["空", "sky", "cielo", "ciel"],
        ["海", "sea", "mar", "mer"],
        ["山", "mountain", "montaña", "montagne"],
        ["花", "flower", "flor", "fleur"],
        ["朝", "morning", "mañana", "matin"],
        ["夜", "night", "noche", "nuit"],
        ["今日", "today", "hoy", "aujourd'hui"],
        ["明日", "tomorrow", "mañana", "demain"],
        ["ありがとう", "thank you", "gracias", "merci"],
        ["こんにちは", "hello", "hola", "bonjour"],
        ["車", "car", "coche", "voiture"],
        ["電車", "train", "tren", "train"],
        ["駅", "station", "estación", "gare"],
        ["仕事", "work", "trabajo", "travail"],
        ["音楽", "music", "música", "musique"],
        ["旅行", "trip", "viaje", "voyage"],
        ["幸せ", "happiness", "felicidad", "bonheur"],
        ["窓", "window", "ventana", "fenêtre"],
    ]
}
