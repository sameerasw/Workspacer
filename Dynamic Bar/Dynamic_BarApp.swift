import SwiftUI

@main
struct Dynamic_BarApp: App {
    @StateObject private var displayMonitor = DisplayMonitor()
    
    var body: some Scene {
        MenuBarExtra {
            MenubarView()
                .environmentObject(displayMonitor)
        } label: {
            MenuBarLabelView()
                .environmentObject(displayMonitor)
        }
        .menuBarExtraStyle(.window)
    }
}
