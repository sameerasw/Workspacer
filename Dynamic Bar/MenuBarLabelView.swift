import SwiftUI

struct MenuBarLabelView: View {
    @EnvironmentObject var displayMonitor: DisplayMonitor
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: displayMonitor.isEnabled ? "menubar.dock.rectangle" : "menubar.dock.rectangle.badge.record")
                .font(.system(size: 14, weight: .medium))
            
            if !displayMonitor.isInternalDisplayActive {
                Circle()
                    .fill(.blue)
                    .frame(width: 4, height: 4)
            }
        }
    }
}
