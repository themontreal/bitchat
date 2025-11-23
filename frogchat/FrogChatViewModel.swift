//
//  FrogChatViewModel.swift
//  FrogChat
//
//  Main view model that wraps ChatViewModel with frog-themed extensions
//

import SwiftUI
import Combine
import CoreLocation

@MainActor
class FrogChatViewModel: ObservableObject {
    // Core BitChat services (shared with main app)
    @Published var chatViewModel: ChatViewModel

    // FrogChat-specific state
    @Published var selectedFrog: FrogPeer?
    @Published var activeRipples: [MessageRipple] = []
    @Published var showingSwampMap = true
    @Published var proximityAudioEnabled = true
    @Published var ambienceEnabled = false

    // Sound manager
    let soundManager: FrogSoundManager

    // Computed properties
    var nearbyFrogs: [FrogPeer] {
        chatViewModel.unifiedPeerService.connectedPeers.map { peer in
            FrogPeer(from: peer, hopsAway: calculateHops(to: peer.peerID))
        }
    }

    var swampName: String {
        guard let channel = chatViewModel.locationChannelManager.currentLocationChannel else {
            return "Wandering Swamp"
        }

        switch channel.precision {
        case 7: return "Small Puddle 💧"
        case 6: return "Moonlight Pond 🌊"
        case 5: return "Downtown Swamp 🐊"
        case 4: return "Texas Wetland 🦆"
        case 2: return "Great Marshland 🌿"
        default: return "Mysterious Swamp"
        }
    }

    init() {
        // Initialize core ChatViewModel with shared services
        self.chatViewModel = ChatViewModel()
        self.soundManager = FrogSoundManager()

        // Set up observers
        setupObservers()
    }

    private func setupObservers() {
        // Play croaks when new peers discovered
        chatViewModel.unifiedPeerService.$connectedPeers
            .sink { [weak self] peers in
                guard let self = self, self.proximityAudioEnabled else { return }

                peers.forEach { peer in
                    let hops = self.calculateHops(to: peer.peerID)
                    self.soundManager.playCroakFor(peer: peer.peerID, hopsAway: hops)
                }
            }
            .store(in: &cancellables)

        // Create ripples when messages sent
        chatViewModel.$messages
            .sink { [weak self] messages in
                guard let self = self, let lastMessage = messages.last else { return }
                self.createRipple(for: lastMessage)
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Actions

    func sendCroak(_ content: String, to frog: FrogPeer? = nil) {
        if let frog = frog {
            // Private croak
            chatViewModel.sendPrivateMessage(content, to: frog.peerID)
        } else {
            // Public croak to swamp
            chatViewModel.sendMessage(content)
        }

        // Play splash sound
        soundManager.playSound(.splash)
    }

    func splashFrog(_ frog: FrogPeer) {
        // FrogChat version of /slap
        let message = "💦 *splashes \(frog.nickname)*"
        chatViewModel.sendMessage(message)
        soundManager.playSound(.splash)
    }

    func listFrogsInSwamp() {
        // FrogChat version of /who
        let count = nearbyFrogs.count
        let message = "🐸 \(count) frog\(count == 1 ? "" : "s") in this swamp"
        // Show as system message
        print(message)
    }

    // MARK: - Helpers

    private func calculateHops(to peerID: PeerID) -> Int {
        // For now, simple calculation based on connection
        // TODO: Implement actual hop count from BLEService
        return chatViewModel.unifiedPeerService.connectedPeers.contains(where: { $0.peerID == peerID }) ? 1 : 3
    }

    private func createRipple(for message: BitchatMessage) {
        let ripple = MessageRipple(
            id: message.id,
            timestamp: message.timestamp
        )
        activeRipples.append(ripple)

        // Remove ripple after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.activeRipples.removeAll { $0.id == ripple.id }
        }
    }
}

// MARK: - Supporting Models

struct FrogPeer: Identifiable {
    let id: String
    let peerID: PeerID
    let nickname: String
    let isConnected: Bool
    let hopsAway: Int
    let species: FrogSpecies

    init(from peer: BitchatPeer, hopsAway: Int) {
        self.id = peer.peerID.shortID
        self.peerID = peer.peerID
        self.nickname = peer.nickname
        self.isConnected = peer.isConnected
        self.hopsAway = hopsAway
        self.species = FrogSpecies.from(peerID: peer.peerID)
    }

    var emoji: String {
        species.emoji
    }
}

enum FrogSpecies {
    case tree      // 🐸 Green tree frog
    case bull      // 🫛 Bullfrog
    case poison    // 🟢 Poison dart frog
    case toad      // 🟤 Toad
    case tadpole   // 🪼 Tadpole (new users)

    var emoji: String {
        switch self {
        case .tree: return "🐸"
        case .bull: return "🐸"
        case .poison: return "🐸"
        case .toad: return "🐸"
        case .tadpole: return "🐸"
        }
    }

    var color: Color {
        switch self {
        case .tree: return .green
        case .bull: return Color(red: 0.2, green: 0.4, blue: 0.2)
        case .poison: return Color(red: 0.0, green: 0.8, blue: 0.8)
        case .toad: return .brown
        case .tadpole: return Color(red: 0.5, green: 0.7, blue: 0.5)
        }
    }

    static func from(peerID: PeerID) -> FrogSpecies {
        let hash = peerID.publicKey.hashValue
        let species: [FrogSpecies] = [.tree, .bull, .poison, .toad]
        return species[abs(hash) % species.count]
    }
}

struct MessageRipple: Identifiable {
    let id: String
    let timestamp: Date
}
