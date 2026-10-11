import SwiftUI

@main
struct LockVocabApp: App {
    @StateObject private var store = WordStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
