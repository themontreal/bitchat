# BitChat - Claude Code Documentation

## Project Overview

BitChat is a decentralized peer-to-peer messaging application with dual transport architecture:
- **Bluetooth mesh network** for offline, local communication
- **Nostr protocol** for internet-based global messaging

**Key Features:**
- No accounts, no phone numbers, no central servers
- End-to-end encryption using Noise Protocol Framework (XX pattern)
- Location-based channels using geohash coordinates
- Intelligent message routing (Bluetooth-first, Nostr fallback)
- Multi-hop mesh relay (up to 7 hops)
- Universal app (iOS 16+, macOS 13+)

**Security:** Uses Curve25519 for key exchange, ChaCha20-Poly1305 for encryption, and Ed25519 for signatures.

---

## Repository Structure

```
bitchat/
├── bitchat/                    # Main application source
│   ├── Services/               # Core business logic and transport layers
│   │   ├── BLE/                # Bluetooth mesh implementation
│   │   │   ├── BLEService.swift (175KB - main mesh network service)
│   │   │   └── MimeType.swift
│   │   ├── NostrTransport.swift
│   │   ├── MessageRouter.swift
│   │   ├── NoiseEncryptionService.swift
│   │   ├── UnifiedPeerService.swift
│   │   ├── LocationChannelManager.swift
│   │   └── [30+ other services]
│   ├── ViewModels/             # State management
│   │   └── ChatViewModel.swift (294KB - primary state manager)
│   ├── Views/                  # SwiftUI UI components
│   │   ├── ContentView.swift (101KB - main chat interface)
│   │   ├── Components/         # Reusable UI components
│   │   └── Media/              # Media-specific views
│   ├── Models/                 # Data structures
│   │   ├── BitchatMessage.swift
│   │   ├── BitchatPeer.swift
│   │   ├── PeerID.swift
│   │   └── [20+ other models]
│   ├── Protocols/              # Binary protocol definitions
│   ├── Noise/                  # Noise Protocol Framework implementation
│   ├── Nostr/                  # Nostr protocol integration
│   ├── Identity/               # Identity and key management
│   ├── Sync/                   # Message synchronization
│   ├── Features/               # Pluggable features (voice, images)
│   └── Utils/                  # Utility extensions
├── bitchatTests/               # Comprehensive test suite
│   ├── Unit Tests/             # Component-level tests
│   ├── Integration/            # Multi-component tests
│   ├── EndToEnd/               # Full workflow tests
│   ├── Mocks/                  # Mock services (BLE, Keychain)
│   └── TestUtilities/          # Test helpers
├── bitchatShareExtension/      # iOS Share extension
├── localPackages/              # Local Swift packages
│   ├── Tor/                    # Tor integration for privacy
│   └── BitLogger/              # Secure logging with PII protection
├── Configs/                    # Build configuration
├── relays/                     # Nostr relay directory data
├── docs/                       # Documentation
├── README.md                   # User-facing documentation
├── WHITEPAPER.md              # Technical protocol specification
├── BRING_THE_NOISE.md         # Noise Protocol details
└── Package.swift              # Swift Package Manager manifest
```

---

## Core Architecture

### 4-Layer Protocol Stack

```
┌─────────────────────────────────┐
│   Application Layer             │  BitchatMessage, Commands
├─────────────────────────────────┤
│   Session Layer                 │  BitchatPacket, Fragmentation, TTL
├─────────────────────────────────┤
│   Encryption Layer              │  Noise XX, Session Management
├─────────────────────────────────┤
│   Transport Layer               │  BLE, Nostr, WebSocket
└─────────────────────────────────┘
```

### Service Architecture

```
BitchatApp (Entry Point)
    ↓
ChatViewModel (Main State Manager) - bitchat/ViewModels/ChatViewModel.swift:1
    ├── BLEService (Bluetooth Mesh) - bitchat/Services/BLE/BLEService.swift:1
    ├── NostrTransport (Internet) - bitchat/Services/NostrTransport.swift:1
    ├── UnifiedPeerService (Peer State) - bitchat/Services/UnifiedPeerService.swift:1
    ├── MessageRouter (Intelligent Routing) - bitchat/Services/MessageRouter.swift:1
    ├── LocationChannelManager (Geolocation) - bitchat/Services/LocationChannelManager.swift:1
    └── NetworkActivationService (Permissions) - bitchat/Services/NetworkActivationService.swift:1
```

### Dual Transport System

**Bluetooth Mesh (Offline):**
- Local peer-to-peer within range
- Multi-hop relay through nearby devices (max 7 hops)
- No internet required
- Noise Protocol encryption
- Binary protocol optimized for BLE MTU
- Implementation: `bitchat/Services/BLE/BLEService.swift:1`

**Nostr Protocol (Internet):**
- Global reach via 290+ distributed relays
- Location-based channels using geohash
- NIP-17 gift-wrapped private messages
- Ephemeral keys per geohash area
- Implementation: `bitchat/Services/NostrTransport.swift:1`

**Message Routing Logic:**
1. **Bluetooth First** (preferred) - Direct, fastest, most private
2. **Nostr Fallback** - When Bluetooth unavailable
3. **Smart Queuing** - Until transport available
- Implementation: `bitchat/Services/MessageRouter.swift:1`

---

## Key Components and Files

### Core Services (bitchat/Services/)

| Component | File | Responsibility |
|-----------|------|----------------|
| **BLEService** | `Services/BLE/BLEService.swift:1` | Bluetooth mesh networking, peer discovery, relay |
| **NostrTransport** | `Services/NostrTransport.swift:1` | Nostr protocol over internet relays |
| **MessageRouter** | `Services/MessageRouter.swift:1` | Intelligent transport selection |
| **NoiseEncryptionService** | `Services/NoiseEncryptionService.swift:1` | Noise handshakes, encryption/decryption |
| **UnifiedPeerService** | `Services/UnifiedPeerService.swift:1` | Single source of truth for peer state |
| **LocationChannelManager** | `Services/LocationChannelManager.swift:1` | Geohash computation, location channels |
| **CommandProcessor** | `Services/CommandProcessor.swift:1` | IRC-style command parsing (/msg, /slap, /who) |
| **VerificationService** | `Services/VerificationService.swift:1` | QR-based fingerprint verification |
| **KeychainManager** | `Services/KeychainManager.swift:1` | Secure key storage |
| **FavoritesPersistenceService** | `Services/FavoritesPersistenceService.swift:1` | Peer favorites and verification status |

### Data Models (bitchat/Models/)

| Model | File | Purpose |
|-------|------|---------|
| **BitchatMessage** | `Models/BitchatMessage.swift:1` | Chat message structure |
| **BitchatPeer** | `Models/BitchatPeer.swift:1` | Peer representation |
| **PeerID** | `Models/PeerID.swift:1` | Unique peer identifier (32-byte public key) |
| **ReadReceipt** | `Models/ReadReceipt.swift:1` | Message read confirmation |
| **DeliveryStatus** | `Models/DeliveryStatus.swift:1` | Message delivery state |

### Noise Protocol (bitchat/Noise/)

| Component | File | Purpose |
|-----------|------|---------|
| **NoiseSession** | `Noise/NoiseSession.swift:1` | Session state management |
| **SecureNoiseSession** | `Noise/SecureNoiseSession.swift:1` | Secure wrapper with rate limiting |
| **NoiseProtocol** | `Noise/NoiseProtocol.swift:1` | Core XX handshake implementation |
| **NoiseRateLimiter** | `Noise/NoiseRateLimiter.swift:1` | DoS prevention |
| **NoiseSecurityValidator** | `Noise/NoiseSecurityValidator.swift:1` | Security policy enforcement |

### Identity Management (bitchat/Identity/)

| Component | File | Purpose |
|-----------|------|---------|
| **SecureIdentityStateManager** | `Identity/SecureIdentityStateManager.swift:1` | Identity material and social metadata |
| **IdentityModels** | `Identity/IdentityModels.swift:1` | Identity data structures |

### UI Components (bitchat/Views/)

| Component | File | Purpose |
|-----------|------|---------|
| **ContentView** | `Views/ContentView.swift:1` | Main chat interface |
| **TextMessageView** | `Views/Components/TextMessageView.swift:1` | Message rendering |
| **DeliveryStatusView** | `Views/Components/DeliveryStatusView.swift:1` | Delivery state display |
| **VoiceNoteView** | `Views/Media/VoiceNoteView.swift:1` | Audio playback |
| **FingerprintView** | `Views/FingerprintView.swift:1` | QR code for verification |

### Binary Protocol (bitchat/Protocols/)

| Component | File | Purpose |
|-----------|------|---------|
| **BinaryProtocol** | `Protocols/BinaryProtocol.swift:1` | Compact binary serialization |
| **Geohash** | `Protocols/Geohash.swift:1` | Location encoding |
| **LocationChannel** | `Protocols/LocationChannel.swift:1` | Geographic channel types |

---

## Development Setup

### Prerequisites
- Xcode 15+
- iOS 16+ / macOS 13+
- Swift 5.9+

### Setup Steps

1. **Clone local configuration:**
```bash
cp Configs/Local.xcconfig.example Configs/Local.xcconfig
```

2. **Add Developer Team ID to `Configs/Local.xcconfig`**

3. **Update bundle ID** (defaults to `chat.bitchat.<team_id>`)

4. **Update entitlements:**
   - Search and replace `group.chat.bitchat` with `group.<your_bundle_id>`
   - Files to update: All `.entitlements` files

5. **Open project:**
```bash
open bitchat.xcodeproj
```

### Quick Run (macOS)

Using `just` (requires `brew install just`):
```bash
just run     # Sets up and runs from source
just clean   # Restores to original state
```

### Build Targets

- **bitchat_iOS** - iPhone/iPad app
- **bitchat_macOS** - Mac desktop app
- **bitchatShareExtension** - iOS share sheet integration
- **bitchatTests_iOS** - iOS tests
- **bitchatTests_macOS** - macOS tests

---

## Testing Architecture

### Test Organization (bitchatTests/)

```
bitchatTests/
├── Unit Tests/          # Component-level testing
├── Integration/         # Multi-component testing
├── EndToEnd/            # Full workflow testing
├── Fragmentation/       # Large message handling
├── Noise/               # Cryptography tests
├── Protocol/            # Binary protocol tests
├── Mocks/               # Mock services
│   ├── MockBLEService.swift
│   ├── MockKeychainManager.swift
│   └── MockIdentityManager.swift
└── TestUtilities/       # Test helpers
```

### Key Test Utilities

**MockBLEService** - In-memory test bus (bitchatTests/Mocks/MockBLEService.swift:1):
- Deterministic messaging without real hardware
- Topology simulation (connected/disconnected peers)
- Packet interception and modification
- Auto-flooding mode for broadcast testing
- No race conditions or flakiness

**Usage Example:**
```swift
let bus = MockBLEService()
bus.simulateConnectedPeer(peerID)
bus.messageDeliveryHandler = { msg in
    // Assertions
}
```

### Running Tests

**Xcode:**
- `Cmd+U` to run all tests
- Select specific test in navigator and run

**Command line:**
```bash
xcodebuild test -scheme "bitchat (iOS)" -destination 'platform=iOS Simulator,name=iPhone 15'
xcodebuild test -scheme "bitchat (macOS)"
```

**CI:** GitHub Actions runs tests on every push (`.github/workflows/swift-tests.yml`)

---

## Common Development Tasks

### Adding a New Service

1. Create service file in `bitchat/Services/`
2. Define protocol if it's a transport-like service
3. Inject into `ChatViewModel` as dependency
4. Add mock version in `bitchatTests/Mocks/`
5. Write unit tests

### Adding a New Message Type

1. Add case to `MessageType` enum in `bitchat/Protocols/BinaryProtocol.swift`
2. Update `BitchatPacket` encoding/decoding
3. Handle in `BLEService` and `NostrTransport`
4. Add tests for serialization
5. Update `WHITEPAPER.md` with protocol details

### Adding a New View

1. Create SwiftUI view in `bitchat/Views/` or `bitchat/Views/Components/`
2. Add preview provider for design iteration
3. Wire into `ContentView` or parent view
4. Add localized strings to `bitchat/Localization/Base.lproj/Localizable.strings`

### Modifying Encryption

**IMPORTANT:** Changes to encryption must:
1. Update `bitchat/Noise/` components
2. Add comprehensive tests in `bitchatTests/Noise/`
3. Update `WHITEPAPER.md` and `BRING_THE_NOISE.md`
4. Consider backward compatibility
5. Get security review before merging

### Adding Localization

1. Add key to `bitchat/Localization/Base.lproj/Localizable.strings`
2. For plurals, update `Localizable.stringsdict`
3. Share extension has separate strings: `bitchatShareExtension/Localization/Base.lproj/Localizable.strings`
4. Verify build: `xcodebuild -project bitchat.xcodeproj -scheme "bitchat (macOS)" -configuration Debug CODE_SIGNING_ALLOWED=NO build`

---

## Important Patterns and Conventions

### Naming Conventions

- **Services:** Suffix with `Service` or `Manager` (e.g., `BLEService`, `KeychainManager`)
- **Models:** Descriptive nouns (e.g., `BitchatMessage`, `PeerID`)
- **Views:** Suffix with `View` (e.g., `TextMessageView`, `ContentView`)
- **View Models:** Suffix with `ViewModel` (e.g., `ChatViewModel`)
- **Protocols:** Descriptive noun or adjective (e.g., `Transport`, `Identifiable`)

### Code Organization

- **One component per file** (except small related types)
- **Group related files in directories** (e.g., `Services/BLE/`)
- **Tests mirror source structure** (e.g., `bitchatTests/Noise/` mirrors `bitchat/Noise/`)
- **Extensions in separate files** (e.g., `String+Extensions.swift`)

### Error Handling

- Use Swift's `throw`/`try`/`catch` for recoverable errors
- Use `Result` type for async operations
- Log errors with `BitLogger` categorized by subsystem
- Never silently swallow errors in production code

### Logging

Use `BitLogger` for all logging:
```swift
import BitLogger

logger.info("Message sent", category: .transport)
logger.warning("Peer unreachable", category: .mesh)
logger.error("Handshake failed: \(error)", category: .crypto)
```

**Categories:**
- `.session` - Session lifecycle
- `.transport` - Network operations
- `.crypto` - Encryption/decryption
- `.mesh` - Bluetooth mesh
- `.nostr` - Nostr operations

### Security Considerations

1. **Never log sensitive data** (keys, message content, PII)
2. **Always use Keychain** for persistent secrets
3. **Rate limit** cryptographic operations (see `NoiseRateLimiter`)
4. **Validate all inputs** from network
5. **Constant-time comparisons** for secrets
6. **Wipe sensitive data** from memory when done

### Performance

- **Lazy initialization** for expensive resources
- **Background threads** for crypto and network I/O
- **Main thread** for UI updates only
- **Batch operations** where possible
- **Bloom filters** for deduplication (see `OptimizedBloomFilter`)

---

## Key Workflows

### App Startup Sequence

1. `BitchatApp.init()` - App entry point
2. Initialize `ChatViewModel` with dependencies
3. Load persisted state from Keychain
4. Start `BLEService` (scanning/advertising)
5. Start `NostrTransport` (if network allowed)
6. Prefetch relay directory
7. Restore UI state

### Sending a Public Message

1. User types message in `ContentView`
2. `ChatViewModel.sendMessage()` called
3. Message encoded to `BitchatMessage`
4. `BLEService` broadcasts via mesh (TTL-based relay)
5. `NostrTransport` broadcasts to location channels
6. Peers decrypt and display

### Sending a Private Message

1. User selects peer, types message
2. `MessageRouter.sendPrivate()` called
3. Transport decision:
   - Bluetooth if reachable → Direct send
   - Nostr if mapping exists → NIP-17 send
   - Else → Queue for later
4. Encrypt with Noise session
5. Track delivery status
6. Handle receipt

### Peer Discovery (Bluetooth)

1. `BLEService` advertises `bitchat-v2` UUID
2. Nearby devices scan and discover
3. Direct GATT connection established
4. Noise XX handshake initiated
5. Peer added to `UnifiedPeerService`
6. UI updates with new peer

### Fingerprint Verification

1. Open peer info sheet
2. Display QR code of SHA-256(static public key)
3. Second user scans QR code
4. Compare fingerprints
5. Mark as verified in `SecureIdentityStateManager`
6. Persist to Keychain

---

## Protocol Specifications

### Binary Packet Format

**BitchatPacket Header** (13-16 bytes):
```
| Version (1) | Type (1) | TTL (1) | Timestamp (8) | Flags (1) | Payload Length (2-4) |
```

**Variable Fields:**
```
| Sender ID (8) | Recipient ID (8, optional) | Payload (variable) | Signature (64, optional) |
```

**Padding:** PKCS#7-style to 256/512/1024/2048 bytes

Full spec: `WHITEPAPER.md:162`

### Noise Protocol

**Protocol Name:** `Noise_XX_25519_ChaChaPoly_SHA256`

**Handshake:**
1. Initiator → Responder: `e` (ephemeral key)
2. Responder → Initiator: `e, ee, s, es` (ephemeral + static)
3. Initiator → Responder: `s, se` (static)

Full spec: `WHITEPAPER.md:105` and `BRING_THE_NOISE.md`

### Message Types

- `message` - Chat message
- `deliveryAck` - Delivery confirmation
- `readReceipt` - Read confirmation
- `noiseHandshakeInit` - Noise handshake start
- `noiseHandshakeResp` - Noise handshake response
- `fragmentStart` - Large message start
- `fragmentContinue` - Message fragment
- `fragmentEnd` - Large message end
- `announcement` - Peer announcement

See: `bitchat/Protocols/BinaryProtocol.swift:1`

---

## Dependencies

### External Dependencies

- **P256K** (21-DOT-DEV/swift-secp256k1) - SECP256K1 elliptic curve operations
- **CryptoKit** (Apple) - Curve25519, ChaCha20-Poly1305, SHA-256
- **CoreLocation** (Apple) - GPS/geolocation services
- **Network** (Apple) - Low-level networking

### Local Packages

- **Tor** (`localPackages/Tor/`) - Tor integration for Nostr privacy
- **BitLogger** (`localPackages/BitLogger/`) - Secure, categorized logging

---

## CI/CD

### GitHub Actions Workflows

**swift-tests.yml** - Runs on every push/PR:
- Builds project
- Runs all tests
- Platform: macOS-latest

**fetch_georelays.yml** - Weekly relay updates:
- Schedule: Sundays 6 AM UTC
- Fetches latest Nostr relay list
- Auto-creates PR if changed

---

## Security & Privacy

### Threat Model

**Protected Against:**
- Eavesdropping (Noise encryption)
- Man-in-the-middle (mutual authentication)
- Message tampering (AEAD)
- Replay attacks (sequence numbers)
- Peer impersonation (fingerprint verification)

**Not Protected Against:**
- Metadata leakage (timing, packet sizes)
- Device compromise (keys accessible)
- Quantum computers (future threat)

### Privacy Features

- No central servers
- No phone numbers or accounts
- Ephemeral location identities
- Tor integration option
- Message padding
- LZ4 compression

### Security Best Practices

1. Always verify fingerprints out-of-band for sensitive conversations
2. Use Tor mode for maximum privacy
3. Regular app updates for security patches
4. Triple-tap emergency wipe if needed
5. Don't use for highly sensitive communications until external audit complete

---

## Troubleshooting

### Bluetooth Not Working

- Check permissions in Settings > Privacy > Bluetooth
- Ensure not in airplane mode
- Restart app to reset BLE stack
- Check `BLEService` logs with BitLogger

### Messages Not Sending

- Verify peer is connected (check peer list)
- Check TTL is > 0 (default: 7)
- Verify Noise handshake completed
- Check message queue in `MessageRouter`

### Nostr Connection Issues

- Verify internet connection
- Check if Tor is stuck (disable/re-enable)
- Verify relay list is not empty
- Check `NostrTransport` logs

### Build Issues

- Clean build folder: Product > Clean Build Folder
- Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- Verify `Local.xcconfig` is properly configured
- Ensure correct bundle ID in entitlements

---

## Additional Resources

- **README.md** - User-facing documentation and features
- **WHITEPAPER.md** - Detailed protocol specification
- **BRING_THE_NOISE.md** - Noise Protocol implementation details
- **PRIVACY_POLICY.md** - Privacy policy for App Store
- **Technical Architecture** - https://deepwiki.com/permissionlesstech/bitchat
- **App Store** - https://apps.apple.com/us/app/bitchat-mesh/id6748219622
- **Website** - http://bitchat.free

---

## Contributing Guidelines

### Before Making Changes

1. Read `WHITEPAPER.md` to understand protocol
2. Review existing tests to understand patterns
3. Check if feature requires protocol changes
4. Consider backward compatibility

### Making Changes

1. Create feature branch from `main`
2. Write tests first (TDD approach)
3. Implement feature with tests passing
4. Update documentation (`CLAUDE.md`, `README.md`, etc.)
5. Run full test suite
6. Verify build succeeds on both iOS and macOS

### Protocol Changes

Protocol changes require:
1. Update `WHITEPAPER.md` with new specification
2. Add version negotiation if breaking change
3. Update binary protocol tests
4. Consider migration path for existing users
5. Get community/security review

### Security Changes

Security-sensitive changes require:
1. Detailed threat model analysis
2. Comprehensive test coverage
3. Update security documentation
4. External security review (for crypto changes)
5. Coordinated disclosure process

---

## License

This project is released into the public domain. See `LICENSE` file for details.

---

*Last Updated: 2025-11-20*
*Version: 1.1*
