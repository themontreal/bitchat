//
//  SettingsView.swift
//  FrogChat
//
//  Swamp settings and preferences
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        Text("🐸")
                            .font(.system(size: 80))
                        Text("FrogChat")
                            .font(FrogTheme.titleFont)
                        Text("A swampy skin for BitChat")
                            .font(FrogTheme.captionFont)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }

                Section("Audio Settings") {
                    Toggle("Proximity Croaks", isOn: $viewModel.proximityAudioEnabled)
                        .tint(FrogTheme.frogSkin)

                    Toggle("Swamp Ambience", isOn: $viewModel.ambienceEnabled)
                        .tint(FrogTheme.frogSkin)
                        .onChange(of: viewModel.ambienceEnabled) { _ in
                            viewModel.soundManager.toggleAmbience()
                        }
                }

                Section("Display") {
                    Toggle("Show Swamp Map", isOn: $viewModel.showingSwampMap)
                        .tint(FrogTheme.frogSkin)
                }

                Section("Network") {
                    HStack {
                        Text("Bluetooth Mesh")
                        Spacer()
                        Circle()
                            .fill(viewModel.chatViewModel.bleService.isRunning ? Color.green : Color.gray)
                            .frame(width: 12, height: 12)
                    }

                    HStack {
                        Text("Connected Frogs")
                        Spacer()
                        Text("\(viewModel.nearbyFrogs.count)")
                            .foregroundColor(.secondary)
                    }
                }

                Section("About") {
                    Link(destination: URL(string: "http://bitchat.free")!) {
                        HStack {
                            Text("BitChat Website")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text("FrogChat 1.0 (BitChat Compatible)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        // Reset all settings
                        viewModel.proximityAudioEnabled = true
                        viewModel.ambienceEnabled = false
                        viewModel.showingSwampMap = true
                    } label: {
                        Text("Reset to Defaults")
                    }
                }
            }
            .navigationTitle("🐸 Swamp Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(FrogTheme.frogSkin)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(FrogChatViewModel())
}
