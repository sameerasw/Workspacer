import SwiftUI

struct MenubarView: View {
    @EnvironmentObject var displayMonitor: DisplayMonitor
    
    var body: some View {
        VStack(spacing: 16) {
            headerSection

            Button("Quit", systemImage: "power", action: {
                NSApplication.shared.terminate(nil)
            })
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            .foregroundStyle(.secondary)
            .font(.caption)


        }
        .padding(20)
        .frame(width: 280)
    }
    
    private var headerSection: some View {
        HStack {
            Image(systemName: displayMonitor.isEnabled ? "menubar.dock.rectangle" : "menubar.dock.rectangle.badge.record")
                .font(.system(size: 24))
                .foregroundStyle(.primary)

            Text("app_name")
                .font(.headline)
            
            Spacer()

            Toggle("",isOn: $displayMonitor.isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
    }
}
