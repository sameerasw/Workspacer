import Foundation
import AppKit
internal import Combine

class MenuBarManager: ObservableObject {
    static let shared = MenuBarManager()
    
    @Published var isAutoHideEnabled: Bool = false
    
    enum MenuBarOption {
        case always     // Hide on desktop, hide in full screen
        case never      // Show on desktop, show in full screen
        
        var visibilityInFullscreen: Int {
            switch self {
            case .always: return 0
            case .never: return 1
            }
        }
        
        var autohideOnDesktop: Bool {
            switch self {
            case .always: return true
            case .never: return false
            }
        }
    }

    func setMenuBarAutoHide(enabled: Bool) {
        let option: MenuBarOption = enabled ? .always : .never
        print("MenuBarManager: Setting menu bar to \(enabled ? "Always Hide" : "Never Hide")")
        
        // 1. Set Fullscreen visibility via defaults
        setFullscreenVisibility(option.visibilityInFullscreen)
        
        // 2. Set Desktop autohide via AppleScript
        setDesktopAutohide(option.autohideOnDesktop)
        
        DispatchQueue.main.async {
            self.isAutoHideEnabled = enabled
        }
    }
    
    private func setFullscreenVisibility(_ value: Int) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/defaults")
        process.arguments = ["write", "NSGlobalDomain", "AppleMenuBarVisibleInFullscreen", "-int", "\(value)"]
        
        do {
            try process.run()
            process.waitUntilExit()
            print("MenuBarManager: Set AppleMenuBarVisibleInFullscreen to \(value)")
        } catch {
            print("MenuBarManager: Failed to set fullscreen visibility: \(error)")
        }
    }
    
    private func setDesktopAutohide(_ enabled: Bool) {
        let scriptSource = """
        if application "System Events" is not running then
            launch application "System Events"
        end if
        tell application "System Events"
            set autohide menu bar of dock preferences to \(enabled)
        end tell
        """
        
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            
            if let err = error {
                print("MenuBarManager: AppleScript Error: \(err)")
                
                // Fallback to Shell osascript
                let osascript = "tell application \"System Events\" to set autohide menu bar of dock preferences to \(enabled)"
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
                process.arguments = ["-e", osascript]
                try? process.run()
            } else {
                print("MenuBarManager: Desktop autohide set to \(enabled)")
            }
        }
    }
}
