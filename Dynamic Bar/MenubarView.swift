import SwiftUI

struct MenubarView: View {
    @EnvironmentObject var displayMonitor: DisplayMonitor
    @StateObject var maskManager = CornerMaskManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            headerSection

            menubarSection

            cornerMaskSection

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

        }
    }


    private var menubarSection: some View {
        HStack {
            Text("dynamic_menubar")
                .font(.subheadline)
                .bold()

            Spacer()

            Toggle("",isOn: $displayMonitor.isEnabled)
                .toggleStyle(.switch)
        }
    }

    private var cornerMaskSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("corner_radius")
                    .font(.subheadline)
                    .bold()
                Spacer()

                Slider(value: $maskManager.cornerRadius, in: 0...50)
                    .controlSize(.small)
            }
        }
    }
}
