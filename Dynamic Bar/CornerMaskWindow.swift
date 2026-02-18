import AppKit
import SwiftUI

class CornerMaskWindow: NSWindow {
    init(screen: NSScreen, radius: CGFloat) {
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        self.isReleasedWhenClosed = false
        self.level = .mainMenu + 1 // Stay above almost everything
        self.backgroundColor = .clear
        self.hasShadow = false
        self.ignoresMouseEvents = true
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        
        updateContentView(radius: radius)
    }
    
    func updateRadius(_ radius: CGFloat) {
        updateContentView(radius: radius)
    }
    
    private func updateContentView(radius: CGFloat) {
        let maskView = CornerMaskOverlayView(radius: radius)
        let hostingView = NSHostingView(rootView: maskView)
        hostingView.frame = self.contentView?.bounds ?? .zero
        self.contentView = hostingView
    }
}

struct CornerMaskOverlayView: View {
    let radius: CGFloat
    
    var body: some View {
        ZStack {
            if radius > 0 {
                Color.clear
                    .overlay(
                        ZStack {
                            // Top Left
                            cornerShape(position: .topLeft)
                            // Top Right
                            cornerShape(position: .topRight)
                            // Bottom Left
                            cornerShape(position: .bottomLeft)
                            // Bottom Right
                            cornerShape(position: .bottomRight)
                        }
                    )
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func cornerShape(position: CornerPosition) -> some View {
        GeometryReader { geo in
            Path { path in
                // Start at the very corner of the 2D coordinate system
                path.move(to: .zero)
                
                // Draw to the edge of the radius on one axis
                path.addLine(to: CGPoint(x: radius, y: 0))
                
                // Draw a circular arc back to the other axis
                // The center of the arc is at (radius, radius)
                path.addArc(
                    center: CGPoint(x: radius, y: radius),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(180),
                    clockwise: true
                )
                
                // Close the path back to (0,0)
                path.addLine(to: .zero)
                path.closeSubpath()
            }
            .fill(Color.black)
            .frame(width: radius, height: radius)
            .rotationEffect(position.rotation)
            .position(position.offset(in: geo.size, radius: radius))
        }
    }
    
    enum CornerPosition {
        case topLeft, topRight, bottomLeft, bottomRight
        
        var rotation: Angle {
            switch self {
            case .topLeft: return .degrees(0)
            case .topRight: return .degrees(90)
            case .bottomRight: return .degrees(180)
            case .bottomLeft: return .degrees(270)
            }
        }
        
        func offset(in size: CGSize, radius: CGFloat) -> CGPoint {
            let r = radius / 2
            switch self {
            case .topLeft: return CGPoint(x: r, y: r)
            case .topRight: return CGPoint(x: size.width - r, y: r)
            case .bottomLeft: return CGPoint(x: r, y: size.height - r)
            case .bottomRight: return CGPoint(x: size.width - r, y: size.height - r)
            }
        }
    }
}
