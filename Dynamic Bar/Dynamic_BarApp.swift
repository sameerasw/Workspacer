//
//  Dynamic_BarApp.swift
//  Dynamic Bar
//
//  Created by Sameera Sandakelum on 2026-02-18.
//

import SwiftUI

@main
struct Dynamic_BarApp: App {
    @StateObject private var displayMonitor = DisplayMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(displayMonitor)
        }
    }
}
