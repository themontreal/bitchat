//
//  SwampContentView.swift
//  FrogChat
//
//  Main swamp interface - the heart of FrogChat
//

import SwiftUI

struct SwampContentView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel
    @State private var messageText = ""
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background swamp
                FrogTheme.backgroundForTime()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top bar - current swamp info
                    SwampHeaderView()

                    // Main content - swamp map or message list
                    if viewModel.showingSwampMap {
                        SwampMapView()
                    } else {
                        MessageListView()
                    }

                    // Bottom bar - croak input
                    CroakInputView(messageText: $messageText)
                }
            }
            .navigationTitle("🐸 FrogChat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(FrogTheme.frogSkin)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            viewModel.showingSwampMap.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.showingSwampMap ? "list.bullet" : "map")
                            .foregroundColor(FrogTheme.frogSkin)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(viewModel)
            }
        }
    }
}

// MARK: - Swamp Header

struct SwampHeaderView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.swampName)
                    .font(FrogTheme.titleFont)
                    .foregroundColor(FrogTheme.moonlight)

                Text("\(viewModel.nearbyFrogs.count) frog\(viewModel.nearbyFrogs.count == 1 ? "" : "s") nearby")
                    .font(FrogTheme.captionFont)
                    .foregroundColor(FrogTheme.frogSkin)
            }

            Spacer()

            // Mesh status indicator
            Circle()
                .fill(viewModel.chatViewModel.bleService.isRunning ? Color.green : Color.gray)
                .frame(width: 12, height: 12)
        }
        .padding()
        .background(FrogTheme.swampGreen.opacity(0.9))
    }
}

// MARK: - Croak Input

struct CroakInputView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel
    @Binding var messageText: String

    var body: some View {
        HStack(spacing: 12) {
            // Text input
            TextField("Croak something...", text: $messageText)
                .textFieldStyle(.roundedBorder)
                .background(FrogTheme.lilyPadGreen.opacity(0.3))
                .cornerRadius(20)

            // Send button
            Button {
                sendCroak()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(FrogTheme.frogSkin)
                    .clipShape(Circle())
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(FrogTheme.swampGreen.opacity(0.95))
    }

    private func sendCroak() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let selectedFrog = viewModel.selectedFrog {
            viewModel.sendCroak(trimmed, to: selectedFrog)
        } else {
            viewModel.sendCroak(trimmed)
        }

        messageText = ""
    }
}

// MARK: - Message List View (Fallback)

struct MessageListView: View {
    @EnvironmentObject var viewModel: FrogChatViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.chatViewModel.messages) { message in
                    MessageBubbleView(message: message)
                }
            }
            .padding()
        }
        .background(FrogTheme.waterBlue.opacity(0.3))
    }
}

struct MessageBubbleView: View {
    let message: BitchatMessage

    var body: some View {
        HStack {
            if message.isPrivate && !message.isRelay {
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                // Sender name
                Text(message.sender)
                    .font(FrogTheme.captionFont)
                    .foregroundColor(FrogTheme.frogSkin)

                // Message content
                Text(message.content)
                    .font(FrogTheme.croakFont)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        message.isPrivate && !message.isRelay
                            ? FrogTheme.outgoingBubble
                            : FrogTheme.incomingBubble
                    )
                    .cornerRadius(16)

                // Timestamp
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if message.isPrivate && message.isRelay {
                Spacer()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SwampContentView()
        .environmentObject(FrogChatViewModel())
}
