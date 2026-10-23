import SwiftUI

@main
struct MesureRameApp: App {
    @StateObject private var store = Store()
    var body: some Scene {
        WindowGroup { ContentView().environmentObject(store) }
    }
}
