# 🐸 FrogChat - Swamp Skin for BitChat

A whimsical, swamp-themed interface for BitChat. Fully compatible with the BitChat network!

## What is FrogChat?

FrogChat is a playful reskin of BitChat where:
- **Peers** → **Frogs** 🐸
- **Messages** → **Croaks** 💬
- **Location Channels** → **Swamps** 🌿
- **Connection Range** → **Lily pad proximity** 🪷

All the serious decentralized mesh networking of BitChat, with a fun swampy aesthetic!

## Features

✅ **Full BitChat Compatibility** - Works on the same network
✅ **Swamp-Themed UI** - Green gradients, frog emojis, organic design
✅ **Spatial Map View** - See frogs positioned by proximity
✅ **Proximity Audio** - Hear croaks when frogs are nearby
✅ **Swamp Ambience** - Optional background sounds
✅ **Time-of-Day Effects** - Background changes with time
✅ **Message Ripples** - Water ripple animations

## Setup for Mobile Build

### Option 1: Using Xcode (Recommended)

1. **Open the Xcode project:**
   ```bash
   cd /home/user/bitchat
   open bitchat.xcodeproj
   ```

2. **Add FrogChat target:**
   - In Xcode, select the project in the navigator
   - Go to File → New → Target
   - Choose "iOS App"
   - Product Name: `FrogChat`
   - Bundle Identifier: `chat.frogchat.<YOUR_TEAM_ID>`
   - Click Finish

3. **Configure the target:**
   - Select FrogChat target → Build Phases
   - Add all files from `frogchat/` folder
   - Add all files from `bitchat/Services/`, `bitchat/Models/`, `bitchat/Protocols/`, `bitchat/Noise/`, `bitchat/Nostr/` (shared with BitChat)

4. **Set Info.plist and Entitlements:**
   - FrogChat target → Build Settings
   - Info.plist File: `frogchat/Info.plist`
   - Code Signing Entitlements: `frogchat/frogchat.entitlements`

5. **Update App Group:**
   - In `frogchat.entitlements`, change `group.chat.frogchat` to `group.chat.frogchat.<YOUR_TEAM_ID>`

6. **Build & Run:**
   - Select FrogChat scheme
   - Select your device
   - Cmd+R to build and run

### Option 2: Command Line (For Advanced Users)

```bash
# Generate Xcode project with FrogChat target
# (Requires manual project.pbxproj editing)

# Build for iOS
xcodebuild -project bitchat.xcodeproj \
  -scheme FrogChat \
  -destination 'platform=iOS,name=YOUR_DEVICE' \
  build
```

## File Structure

```
frogchat/
├── FrogChatApp.swift          # App entry point
├── FrogChatViewModel.swift    # Main state management
├── Info.plist                 # App configuration
├── frogchat.entitlements      # Permissions
├── FrogViews/
│   ├── SwampContentView.swift # Main interface
│   ├── SwampMapView.swift     # Spatial frog map
│   └── SettingsView.swift     # Swamp settings
├── FrogTheme/
│   ├── FrogTheme.swift        # Colors & styling
│   └── FrogSoundManager.swift # Audio system
└── Resources/
    ├── Assets.xcassets/       # Images
    └── Sounds/                # Audio files (TODO)
```

## Shared Files (From BitChat)

FrogChat uses these core services from BitChat:

- `bitchat/Services/` - All networking and crypto services
- `bitchat/Models/` - Data models (BitchatMessage, PeerID, etc.)
- `bitchat/Protocols/` - Binary protocol
- `bitchat/Noise/` - Encryption (Noise Protocol)
- `bitchat/Nostr/` - Internet transport

**These files are shared**, so changes affect both apps!

## Testing Compatibility

To test FrogChat ↔ BitChat compatibility:

1. Install FrogChat on Device A
2. Install BitChat on Device B
3. Both should discover each other via Bluetooth
4. Send messages from both apps
5. Verify messages appear correctly

## Adding Audio Files

FrogChat expects these audio files in `frogchat/Resources/Sounds/`:

- `croak_1.mp3` - Frog croak variant 1
- `croak_2.mp3` - Frog croak variant 2
- `croak_3.mp3` - Frog croak variant 3
- `water_splash.mp3` - Splash sound
- `plop.mp3` - Message received sound
- `swamp_ambience_loop.mp3` - Background ambience

**Currently using system sounds as placeholders.**

To add real sounds:
1. Find royalty-free frog sounds (e.g., freesound.org)
2. Add MP3 files to `frogchat/Resources/Sounds/`
3. Add files to FrogChat target in Xcode
4. Uncomment audio code in `FrogSoundManager.swift`

## Customization

### Change Frog Species

Edit `FrogSpecies` enum in `FrogChatViewModel.swift`:

```swift
enum FrogSpecies {
    case tree      // 🐸
    case bull      // 🐸
    case poison    // 🐸
    case toad      // 🐸
    case tadpole   // 🐸
}
```

### Adjust Colors

Edit `FrogTheme.swift`:

```swift
static let swampGreen = Color(red: 0.176, green: 0.314, blue: 0.086)
static let lilyPadGreen = Color(red: 0.290, green: 0.486, blue: 0.173)
```

### Add New Swamp Types

Edit `swampName` computed property in `FrogChatViewModel.swift`:

```swift
switch channel.precision {
case 7: return "Tiny Puddle 💧"
case 6: return "Small Pond 🌊"
// Add more...
}
```

## Known Issues

- [ ] Audio files not included (using system sounds)
- [ ] Hop count calculation simplified (needs BLEService integration)
- [ ] Frog positioning could be smoother
- [ ] No AR mode yet
- [ ] Need app icon

## Roadmap

### Phase 1: MVP ✅
- [x] Basic swamp theme
- [x] Frog positioning
- [x] Message list
- [x] Settings screen
- [x] Proximity audio (placeholders)

### Phase 2: Polish
- [ ] Real audio files
- [ ] Smooth animations
- [ ] App icon
- [ ] Improved positioning algorithm
- [ ] Ribbit pattern verification

### Phase 3: Advanced
- [ ] AR mode (see frogs in camera)
- [ ] Achievements
- [ ] Multiple frog species selection
- [ ] Weather effects
- [ ] Mini-games

## Contributing

FrogChat is built on top of BitChat, which is public domain. Feel free to:

- Add new themes
- Improve animations
- Create better audio
- Design frog sprites
- Build AR features

## License

Same as BitChat - public domain. Ribbit away! 🐸

---

**Built with 💚 for the swamp**
