import SwiftUI

@main
struct Dynamic_BarApp: App {
    @StateObject private var displayMonitor = DisplayMonitor()
    // Initialize shared instance early
    @StateObject private var maskManager = CornerMaskManager.shared
    
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
