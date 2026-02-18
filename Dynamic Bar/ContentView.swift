import SwiftUI

struct ContentView: View {
    @EnvironmentObject var displayMonitor: DisplayMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            headerSection
            
            Divider()
            
            statusSection
            
            Toggle("monitoring_active", isOn: $displayMonitor.isEnabled)
                .padding(.top)
        }
        .padding(24)
        .frame(width: 300)
    }
    
    private var headerSection: some View {
        HStack {
            Image(systemName: "menubar.rectangle")
                .font(.system(size: 32))
                .foregroundStyle(.blue)
            
            Text("app_name")
                .font(.title2)
                .bold()
        }
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(displayMonitor.isEnabled ? .green : .gray)
                    .frame(width: 8, height: 8)
                Text(displayMonitor.isEnabled ? "monitoring_active" : "monitoring_inactive")
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: displayMonitor.isInternalDisplayActive ? "laptopcomputer" : "display.2")
                Text(displayMonitor.isInternalDisplayActive ? "internal_display_active" : "clamshell_detected")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DisplayMonitor())
}
