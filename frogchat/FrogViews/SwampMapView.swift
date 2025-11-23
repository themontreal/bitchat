//
//  SwampMapView.swift
//  FrogChat
//
//  Visual map showing frogs positioned by proximity
//

import SwiftUI

struct SwampMapView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Swamp background with gradient
                FrogTheme.swampGradient
                    .ignoresSafeArea()

                // You (center frog)
                VStack {
                    Text("🐸")
                        .font(.system(size: 60))
                    Text("You")
                        .font(FrogTheme.captionFont)
                        .foregroundColor(FrogTheme.moonlight)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                // Nearby frogs
                ForEach(viewModel.nearbyFrogs) { frog in
                    FrogAvatarView(frog: frog)
                        .position(calculatePosition(for: frog, in: geometry))
                }

                // Ripple animations
                ForEach(viewModel.activeRipples) { ripple in
                    RippleView(ripple: ripple)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }

                // Empty swamp message
                if viewModel.nearbyFrogs.isEmpty {
                    VStack(spacing: 12) {
                        Text("🦗")
                            .font(.system(size: 80))
                        Text("No frogs nearby...")
                            .font(FrogTheme.titleFont)
                            .foregroundColor(FrogTheme.moonlight)
                        Text("Wait for others to join the swamp")
                            .font(FrogTheme.captionFont)
                            .foregroundColor(FrogTheme.frogSkin)
                    }
                }
            }
        }
    }

    private func calculatePosition(for frog: FrogPeer, in geometry: GeometryProxy) -> CGPoint {
        // Position based on hop distance and deterministic angle from peer ID
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

        // Calculate radius based on hops (closer = smaller radius)
        let baseRadius: CGFloat = 80
        let radius = baseRadius + (CGFloat(frog.hopsAway) * FrogTheme.lilyPadSpacing)

        // Calculate angle based on peer ID (deterministic but pseudo-random)
        let angle = angleFromPeerID(frog.peerID)

        // Calculate position on circle
        let x = center.x + cos(angle) * radius
        let y = center.y + sin(angle) * radius

        return CGPoint(x: x, y: y)
    }

    private func angleFromPeerID(_ peerID: PeerID) -> Double {
        // Convert peer ID hash to angle (0 to 2π)
        let hash = abs(peerID.publicKey.hashValue)
        return Double(hash % 360) * .pi / 180.0
    }
}

// MARK: - Frog Avatar

struct FrogAvatarView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel
    let frog: FrogPeer
    @State private var isHopping = false

    var body: some View {
        VStack(spacing: 4) {
            // Frog emoji
            Text(frog.emoji)
                .font(.system(size: FrogTheme.frogSize))
                .offset(y: isHopping ? -10 : 0)
                .animation(.easeInOut(duration: 0.3), value: isHopping)

            // Nickname
            Text(frog.nickname)
                .font(.caption2)
                .foregroundColor(FrogTheme.moonlight)
                .lineLimit(1)
                .shadow(color: .black, radius: 2)

            // Hop distance indicator
            Text("\(frog.hopsAway) hop\(frog.hopsAway == 1 ? "" : "s")")
                .font(.system(size: 8))
                .foregroundColor(FrogTheme.frogSkin)
        }
        .onTapGesture {
            viewModel.selectedFrog = frog
            // Trigger hop animation
            withAnimation {
                isHopping = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isHopping = false
            }
        }
    }
}

// MARK: - Ripple Animation

struct RippleView: View {
    let ripple: MessageRipple
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0

    var body: some View {
        Circle()
            .stroke(FrogTheme.frogSkin.opacity(opacity), lineWidth: 3)
            .frame(width: 50, height: 50)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    scale = FrogTheme.rippleMaxRadius / 50
                    opacity = 0.0
                }
            }
    }
}

// MARK: - Preview

#Preview {
    SwampMapView()
        .environmentObject(FrogChatViewModel())
}
