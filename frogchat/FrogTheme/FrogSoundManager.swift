//
//  FrogSoundManager.swift
//  FrogChat
//
//  Manages proximity audio and swamp ambience
//

import SwiftUI
import AVFoundation
import Combine

class FrogSoundManager: ObservableObject {
    @Published var proximityAudioEnabled = true
    @Published var ambienceEnabled = false

    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var ambiencePlayer: AVAudioPlayer?

    enum SoundType: String {
        case croak1 = "croak_1"
        case croak2 = "croak_2"
        case croak3 = "croak_3"
        case splash = "water_splash"
        case plop = "plop"
        case ambience = "swamp_ambience_loop"
    }

    init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    // MARK: - Proximity Croaks

    func playCroakFor(peer: PeerID, hopsAway: Int) {
        guard proximityAudioEnabled else { return }

        let volume = volumeForHops(hopsAway)
        let soundType = selectCroakSound(for: peer)

        playSound(soundType, volume: volume)
    }

    private func volumeForHops(_ hops: Int) -> Float {
        switch hops {
        case 0...1: return 1.0   // Very close - loud
        case 2: return 0.6       // Medium distance
        case 3: return 0.3       // Far
        default: return 0.1      // Very far - barely audible
        }
    }

    private func selectCroakSound(for peerID: PeerID) -> SoundType {
        // Consistent croak sound per peer (based on ID hash)
        let hash = peerID.publicKey.hashValue
        let sounds: [SoundType] = [.croak1, .croak2, .croak3]
        return sounds[abs(hash) % sounds.count]
    }

    // MARK: - General Sounds

    func playSound(_ type: SoundType, volume: Float = 1.0) {
        // For now, use system sounds as placeholder
        // TODO: Add actual sound files to Resources/Sounds/

        switch type {
        case .splash, .plop:
            // Play system sound as placeholder
            AudioServicesPlaySystemSound(1104) // Pop sound
        case .croak1, .croak2, .croak3:
            // Play system sound as placeholder
            AudioServicesPlaySystemSound(1103) // Tink sound
        case .ambience:
            // Will implement when we have actual audio files
            break
        }

        // Real implementation (when sound files exist):
        /*
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") else {
            print("Sound file not found: \(type.rawValue)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.play()
            audioPlayers[type.rawValue] = player
        } catch {
            print("Failed to play sound: \(error)")
        }
        */
    }

    // MARK: - Ambience

    func startAmbience() {
        guard ambienceEnabled else { return }

        // TODO: Load and loop swamp_ambience_loop.mp3
        // For now, this is a placeholder

        /*
        guard let url = Bundle.main.url(forResource: "swamp_ambience_loop", withExtension: "mp3") else {
            return
        }

        do {
            ambiencePlayer = try AVAudioPlayer(contentsOf: url)
            ambiencePlayer?.numberOfLoops = -1 // Loop indefinitely
            ambiencePlayer?.volume = 0.3
            ambiencePlayer?.play()
        } catch {
            print("Failed to start ambience: \(error)")
        }
        */
    }

    func stopAmbience() {
        ambiencePlayer?.stop()
        ambiencePlayer = nil
    }

    func toggleAmbience() {
        ambienceEnabled.toggle()

        if ambienceEnabled {
            startAmbience()
        } else {
            stopAmbience()
        }
    }
}
