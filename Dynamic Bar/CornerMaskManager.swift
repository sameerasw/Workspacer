import AppKit
internal import Combine

class CornerMaskManager: ObservableObject {
    static let shared = CornerMaskManager()
    
    @Published var cornerRadius: Double = 0 {
        didSet {
            updateWindows()
            saveToDefaults()
        }
    }
    
    private var windows: [CornerMaskWindow] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.cornerRadius = UserDefaults.standard.double(forKey: "CornerRadius")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupWindows),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        
        setupWindows()
    }
    
    @objc func setupWindows() {
        // Remove existing windows
        windows.forEach { $0.close() }
        windows.removeAll()
        
        guard cornerRadius > 0 else { return }
        
        // Create windows for each screen
        for screen in NSScreen.screens {
            let window = CornerMaskWindow(screen: screen, radius: CGFloat(cornerRadius))
            window.orderFrontRegardless()
            windows.append(window)
        }
    }
    
    private func updateWindows() {
        if cornerRadius == 0 {
            windows.forEach { $0.close() }
            windows.removeAll()
        } else if windows.isEmpty {
            setupWindows()
        } else {
            windows.forEach { $0.updateRadius(CGFloat(cornerRadius)) }
        }
    }
    
    private func saveToDefaults() {
        UserDefaults.standard.set(cornerRadius, forKey: "CornerRadius")
    }
}
