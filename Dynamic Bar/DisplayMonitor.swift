import Foundation
import AppKit
internal import Combine

class DisplayMonitor: ObservableObject {
    @Published var isInternalDisplayActive: Bool = true
    @Published var isEnabled: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Watch for screen changes (Lid open/close or Monitor plug/unplug)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(evaluateState),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        
        // Initial evaluation
        evaluateState()
    }

    @objc func evaluateState() {
        guard isEnabled else { return }
        
        let screens = NSScreen.screens
        
        // Logic: If no built-in screen is found, we are in Clamshell mode
        let internalDisplay = screens.first { screen in
            // Checking for the built-in retina or LCD display
            let description = screen.deviceDescription
            if let _ = description[NSDeviceDescriptionKey("NSScreenNumber")] {
                return screen.localizedName.lowercased().contains("built-in") || 
                       screen.localizedName.lowercased().contains("retina")
            }
            return false
        }

        let isActive = internalDisplay != nil
        
        DispatchQueue.main.async {
            self.isInternalDisplayActive = isActive
            
            if !isActive {
                print("Clamshell mode detected: Forcing Auto-Hide")
                MenuBarManager.shared.setMenuBarAutoHide(enabled: true)
            } else {
                // For now, if internal is active, we might want to disable auto-hide 
                // unless the user is in full screen. Keeping it simple for now.
                print("Internal display detected: Disabling Auto-Hide")
                MenuBarManager.shared.setMenuBarAutoHide(enabled: false)
            }
        }
    }
}
