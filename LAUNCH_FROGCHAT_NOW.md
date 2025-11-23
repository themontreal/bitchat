# 🚀 Launch FrogChat RIGHT NOW - 5 Minute Guide

## Prerequisites Check

- ✅ Mac with Xcode installed
- ✅ iOS device connected (or use Simulator)
- ✅ Apple Developer account (free tier OK)

---

## 🎯 Super Quick Launch (Skip Icon)

### 1. Open Xcode Project (30 seconds)

```bash
cd /home/user/bitchat
open bitchat.xcodeproj
```

Wait for Xcode to finish indexing...

### 2. Create FrogChat Target (2 minutes)

**In Xcode:**

1. **Click** project name "bitchat" in left sidebar (blue icon at top)

2. **Look at the middle panel** - you'll see targets list:
   - bitchat_iOS
   - bitchat_macOS
   - bitchatShareExtension
   - etc.

3. **At the bottom** of targets list, click the **➕ plus button**

4. **Choose:**
   - iOS tab → Application → App
   - Click "Next"

5. **Fill in:**
   - Product Name: `FrogChat`
   - Team: (Select your Apple ID team)
   - Organization Identifier: `chat.frogchat`
   - Bundle Identifier: (auto-fills as `chat.frogchat.FrogChat`)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Include Tests: ❌ (uncheck)

6. **Click "Finish"**

7. **Dialog appears:** "Do you want to create a Git repository?"
   - Choose: **Don't Create**

### 3. Configure FrogChat Target (1 minute)

**Still in Xcode:**

1. **Select FrogChat target** (you just created it)

2. **Go to "General" tab**

3. **Scroll to "Frameworks, Libraries, and Embedded Content"**
   - Click **➕**
   - Add: `BitLogger`
   - Add: `Tor`

4. **Go to "Build Settings" tab**
   - Search: "Info.plist"
   - Find: "Info.plist File"
   - Change from `FrogChat/Info.plist` to: `frogchat/Info.plist`

5. **Still in Build Settings:**
   - Search: "Code Signing Entitlements"
   - Change to: `frogchat/frogchat.entitlements`

6. **Go to "Build Phases" tab**
   - Expand "Compile Sources"
   - **Delete all files** you see there (the template files)
     - Right-click each → Delete → Remove Reference

### 4. Add FrogChat Files (1 minute)

**In Xcode:**

1. **Right-click on "FrogChat" folder** in left navigator
2. Choose: **Add Files to "bitchat"...**
3. **Navigate to:** `bitchat/frogchat/` folder
4. **Select ALL files and folders** in frogchat/
5. **Options at bottom:**
   - Destination: ❌ **UNCHECK** "Copy items if needed"
   - Added folders: ⚪ "Create groups"
   - Add to targets: ✅ **CHECK** "FrogChat"
6. **Click "Add"**

### 5. Add Shared BitChat Services (2 minutes)

We need to share BitChat's networking code with FrogChat.

**In Xcode Navigator:**

1. **Expand `bitchat` folder** (the original app)

2. **Click on `Services` folder**
   - Look at right panel (File Inspector)
   - Under "Target Membership"
   - ✅ **Check "FrogChat"**

3. **Repeat for these folders:**
   - `Models/` → ✅ Check FrogChat
   - `Protocols/` → ✅ Check FrogChat
   - `Noise/` → ✅ Check FrogChat
   - `Nostr/` → ✅ Check FrogChat
   - `Utils/` → ✅ Check FrogChat
   - `Identity/` → ✅ Check FrogChat
   - `Sync/` → ✅ Check FrogChat
   - `Features/` → ✅ Check FrogChat

**Pro tip:** Select all these folders at once (Cmd+Click), then check FrogChat in Inspector!

### 6. Configure Entitlements (30 seconds)

**Open file:** `frogchat/frogchat.entitlements`

Find this line:
```xml
<string>group.chat.frogchat</string>
```

**Change it to include your team ID:**
```xml
<string>group.chat.frogchat.YOUR_TEAM_ID</string>
```

Replace `YOUR_TEAM_ID` with your actual team ID (found in FrogChat target → Signing & Capabilities)

### 7. Skip Icon Setup (for now)

We'll launch without a custom icon! Xcode will use a default.

**In FrogChat target:**
1. General tab
2. App Icons and Launch Screen
3. App Icon: Leave as "AppIcon" (it's okay if it's missing)

### 8. Build & Run! 🚀

1. **Top of Xcode:** Select FrogChat scheme (next to the Run button)

2. **Select your device:**
   - For physical device: Choose your iPhone/iPad from dropdown
   - For simulator: Choose "iPhone 15" or any simulator

3. **Press the ▶️ Play button** (or Cmd+R)

4. **Wait for build...**
   - First time takes ~30 seconds

5. **If prompted on device:**
   - "Trust this computer?" → **Trust**
   - "Untrusted Developer" → Go to Settings → General → VPN & Device Management → Trust

6. **FrogChat launches!** 🐸🎉

---

## ✅ First Launch Checklist

When FrogChat opens:

1. **Grant Bluetooth permission** → Allow
2. **Grant Location permission** → Allow While Using App
3. **See the swamp!** You should see:
   - Green swamp background
   - "🐸 FrogChat" title
   - "No frogs nearby..." (if alone)
   - Croak input at bottom

### Test Basic Features:

- ✅ Type a message and send (should see it appear)
- ✅ Tap map/list toggle button (top left)
- ✅ Tap settings button (top right)
- ✅ Toggle "Proximity Croaks" on/off
- ✅ Change "Show Swamp Map" toggle

---

## 🧪 Test with BitChat (Compatibility Check)

### If you have 2 devices:

**Device 1:**
1. Build & run FrogChat (steps above)

**Device 2:**
1. In Xcode, change scheme to "bitchat_iOS"
2. Build & run on second device

**Test:**
- Both devices should discover each other
- Send message from FrogChat → should appear in BitChat
- Send message from BitChat → should appear in FrogChat
- FrogChat shows BitChat user as a frog 🐸

---

## 🐛 Troubleshooting

### "Build failed: No such file"

**Fix:** A file wasn't added to FrogChat target
- Find the file mentioned in error
- Select it in Navigator
- Check "FrogChat" in Target Membership (File Inspector, right panel)

### "Missing BitLogger/Tor module"

**Fix:**
1. FrogChat target → General tab
2. Frameworks section → ➕
3. Add BitLogger and Tor

### "App crashes on launch"

**Fix:** Info.plist path wrong
1. FrogChat target → Build Settings
2. Search: "Info.plist File"
3. Should be: `frogchat/Info.plist` (not `FrogChat/Info.plist`)

### "Bluetooth not working"

**Fix:**
1. Check Settings → FrogChat → Bluetooth → "Always"
2. Restart app
3. Make sure another device is nearby with BitChat/FrogChat running

### "Can't install on device"

**Fix:** Signing issue
1. FrogChat target → Signing & Capabilities
2. Automatically manage signing: ✅
3. Team: Select your Apple ID
4. If bundle ID conflict, change to: `chat.frogchat.YOURNAME.FrogChat`

---

## 🎨 Add Icon Later (Optional)

Skip this for now, add later when you want:

1. Create 1024x1024 image with 🐸 emoji
2. Save as: `frogchat/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`
3. Rebuild

See `QUICK_ICON_SETUP.md` for detailed icon instructions.

---

## 🎉 Success!

If you see the swamp interface, **you did it!**

**Now try:**
- Send some croaks 🐸
- Find another device with BitChat
- Watch them appear as frogs on your swamp map
- Toggle settings
- Enjoy your swampy messenger!

---

## 📸 What You Should See

```
┌─────────────────────────────┐
│  🐸 FrogChat                 │  ← Title
│  ⚙️                      📋  │  ← Settings & View toggle
├─────────────────────────────┤
│  Moonlight Pond 🌊           │  ← Current swamp
│  0 frogs nearby              │  ← Peer count
├─────────────────────────────┤
│                             │
│         🦗                  │  ← Empty swamp (cricket)
│  No frogs nearby...          │
│  Wait for others to join     │
│                             │
├─────────────────────────────┤
│ [Croak something...]    [>] │  ← Input
└─────────────────────────────┘
```

**Green background, swampy vibes, frog emojis everywhere!** 🐸💚

---

## Next Steps

1. **Test compatibility** with BitChat
2. **Add a proper icon** (later)
3. **Customize colors** in `FrogTheme.swift`
4. **Add real frog sounds** (optional)
5. **Share with friends!**

**Ribbit away! 🐸**
