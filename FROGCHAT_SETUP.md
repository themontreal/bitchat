# 🐸 FrogChat Mobile Build Instructions

Quick guide to building FrogChat on your mobile device.

## Prerequisites

- Xcode installed on Mac
- iOS device with cable
- Apple Developer account (free tier OK)
- BitChat repository cloned

## Step-by-Step Setup

### Step 1: Open Project

```bash
cd bitchat
open bitchat.xcodeproj
```

Wait for Xcode to load and index the project.

### Step 2: Create FrogChat Target

**In Xcode:**

1. Click on `bitchat` project in the left sidebar (top item)
2. At the bottom of the targets list, click the **+** button
3. Select **iOS** → **App**
4. Fill in:
   - **Product Name:** `FrogChat`
   - **Team:** Select your team
   - **Organization Identifier:** `chat.frogchat` (or your preference)
   - **Bundle Identifier:** Will auto-fill as `chat.frogchat.FrogChat`
   - **Interface:** SwiftUI
   - **Language:** Swift
5. Click **Finish**
6. Choose **Don't Add Config** when asked about Git

### Step 3: Replace Default Files

Xcode created a template app. We need to replace it with our FrogChat files:

1. **Delete the auto-generated files:**
   - Right-click on `FrogChat` folder in navigator
   - Select all files inside (FrogChatApp.swift, ContentView.swift, etc.)
   - Press Delete → **Move to Trash**

2. **Add FrogChat files:**
   - Right-click on `FrogChat` target folder
   - Choose **Add Files to "bitchat"...**
   - Navigate to `bitchat/frogchat/` folder
   - Select ALL files and folders
   - **Important:** Check "Copy items if needed" - UNCHECK this (we want references)
   - Make sure FrogChat target is checked
   - Click **Add**

### Step 4: Add Shared BitChat Services

FrogChat needs access to BitChat's core services:

1. **In Xcode Project Navigator:**
   - Expand `bitchat` → `Services` folder
   - Select all files in Services/
   - In the File Inspector (right panel), under **Target Membership**
   - Check the box next to **FrogChat** ✅

2. **Repeat for these folders:**
   - `bitchat/Models/` → Check FrogChat target ✅
   - `bitchat/Protocols/` → Check FrogChat target ✅
   - `bitchat/Noise/` → Check FrogChat target ✅
   - `bitchat/Nostr/` → Check FrogChat target ✅
   - `bitchat/Utils/` → Check FrogChat target ✅
   - `bitchat/Identity/` → Check FrogChat target ✅
   - `bitchat/Sync/` → Check FrogChat target ✅

### Step 5: Configure Info.plist

1. Select **FrogChat** target
2. Go to **Build Settings** tab
3. Search for "Info.plist"
4. Under **Packaging**, set **Info.plist File** to: `frogchat/Info.plist`

### Step 6: Configure Entitlements

1. Still in **Build Settings**
2. Search for "Code Signing Entitlements"
3. Set to: `frogchat/frogchat.entitlements`

### Step 7: Update App Group

1. Open `frogchat/frogchat.entitlements`
2. Find `group.chat.frogchat`
3. Change to match your bundle ID:
   ```xml
   <string>group.chat.frogchat.YOUR_TEAM_ID</string>
   ```

### Step 8: Configure Signing

1. Select **FrogChat** target
2. Go to **Signing & Capabilities** tab
3. Check **Automatically manage signing**
4. Select your **Team**
5. Xcode will automatically create a provisioning profile

### Step 9: Add Required Capabilities

Still in **Signing & Capabilities**:

1. Click **+ Capability**
2. Add: **App Groups**
   - Click the + button
   - Add: `group.chat.frogchat.YOUR_TEAM_ID`

3. Click **+ Capability** again
4. Add: **Background Modes**
   - Check: Uses Bluetooth LE accessories
   - Check: Acts as a Bluetooth LE accessory

### Step 10: Build & Run

1. Connect your iOS device via cable
2. Select your device from the device menu (top of Xcode)
3. Select **FrogChat** scheme
4. Press **Cmd + R** or click the Play button
5. If prompted "Trust this computer?" on device → **Trust**
6. If prompted about Developer Mode on iOS 16+:
   - Go to Settings → Privacy & Security → Developer Mode
   - Enable Developer Mode
   - Restart device
7. Build again

### Step 11: First Launch

When FrogChat launches:

1. Grant Bluetooth permission
2. Grant Location permission (optional, for location channels)
3. You should see the swamp interface! 🐸

## Testing BitChat Compatibility

To verify FrogChat works with BitChat:

### Option A: Two Devices

1. **Device 1:** Install FrogChat (follow above steps)
2. **Device 2:** Install BitChat (change scheme to bitchat, build)
3. Open both apps
4. They should discover each other
5. Send messages from both
6. Verify they appear correctly

### Option B: Simulator + Device

1. **Simulator:** Run BitChat (Cmd+R with "iPhone 15" simulator)
2. **Physical Device:** Run FrogChat
3. Note: Bluetooth won't work in simulator, but you can test Nostr/internet features

## Troubleshooting

### Build Error: "No such module 'BitLogger'"

**Fix:** Add local packages to FrogChat target:

1. Select FrogChat target
2. Go to **Build Phases**
3. Expand **Link Binary With Libraries**
4. Click **+**
5. Add `BitLogger` and `Tor` from local packages

### Build Error: "Missing required module"

**Fix:** Some file not added to target:

1. Find the file mentioned in error
2. Select it in Project Navigator
3. Check **FrogChat** in Target Membership (File Inspector)

### Runtime Error: "App crashes on launch"

**Fix:** Check Info.plist and entitlements paths:

1. FrogChat target → Build Settings
2. Verify paths are correct:
   - Info.plist File: `frogchat/Info.plist`
   - Code Signing Entitlements: `frogchat/frogchat.entitlements`

### "FrogChat won't install on device"

**Fix:** Bundle ID conflict or signing issue:

1. FrogChat target → Signing & Capabilities
2. Change Bundle Identifier to something unique
3. Make sure Team is selected
4. Clean build folder: Shift+Cmd+K
5. Build again

### "Can't see other frogs"

**Fix:** Bluetooth permissions:

1. Check device Settings → FrogChat → Bluetooth
2. Should be "Always" or "While Using"
3. Restart app

### "FrogChat and BitChat don't see each other"

**They're on the same network!** Both use `bitchat-v2` Bluetooth service UUID. Should discover automatically.

Check:
- Both apps have Bluetooth enabled
- Both granted Bluetooth permissions
- Devices are close (within ~30 feet)
- Try force-quitting and reopening both apps

## Next Steps

Once FrogChat is running:

1. **Customize theme** - Edit `FrogTheme.swift`
2. **Add sounds** - Drop MP3 files in `Resources/Sounds/`
3. **Test features:**
   - Send public croaks (broadcasts)
   - Send private croaks (tap a frog)
   - Toggle swamp map view
   - Try settings screen
4. **Test compatibility** - Message between FrogChat and BitChat

## Optional: Add App Icon

1. Create 1024x1024 frog icon image
2. In Xcode: `frogchat/Resources/Assets.xcassets`
3. Right-click → New Image Set → Name it "AppIcon"
4. Drag your icon to the 1024x1024 slot
5. FrogChat target → Build Settings → App Icon: "AppIcon"

## Deploy to TestFlight (Optional)

To distribute to testers:

1. Archive the app: Product → Archive
2. Distribute → App Store Connect
3. Upload to TestFlight
4. Add testers in App Store Connect
5. They can install via TestFlight app

---

## Questions?

- Check `frogchat/README.md` for more details
- Review BitChat's `CLAUDE.md` for architecture info
- Inspect `bitchat/Services/` to understand how networking works

**Happy hopping! 🐸**
