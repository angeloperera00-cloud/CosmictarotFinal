# 🔮 Cosmic Tarot — iOS App

A beautiful mystical tarot reading app built with SwiftUI, featuring AI-powered readings via the Anthropic API.

---

## 📁 Project Structure

```
CosmicTarot/
├── CosmicTarot.xcodeproj/       ← Open this in Xcode
│   └── project.pbxproj
└── CosmicTarot/
    ├── CosmicTarotApp.swift      ← App entry point
    ├── ContentView.swift         ← Root + Tab navigation
    ├── Info.plist                ← App permissions
    ├── Assets.xcassets/          ← Add your images here
    ├── Models/
    │   ├── TarotModel.swift      ← Data models + 30-card deck
    │   └── AnthropicService.swift ← AI reading API
    ├── ViewModels/
    │   └── TarotViewModel.swift  ← App state & logic
    └── Views/
        ├── HomeView.swift        ← Screen 1: Home oracle
        ├── PickCardsView.swift   ← Screen 2: Pick 3 cards fan
        ├── ShakeRevealView.swift ← Screen 3: Shake to reveal
        ├── ReadingView.swift     ← Screen 4: Your reading
        ├── HistoryView.swift     ← Screen 5: Past revealings
        ├── DownloadsView.swift   ← Screen 6: Saved files
        ├── SettingsView.swift    ← Screen 7: Preferences
        ├── CardFanView.swift     ← Card fan component
        └── StarfieldView.swift   ← Animated starfield
```

---

## 🚀 Getting Started

### Step 1: Open in Xcode
1. Unzip the folder
2. Open `CosmicTarot.xcodeproj` in Xcode 15+
3. Select your Development Team under: Target → Signing & Capabilities

### Step 2: Add Your Anthropic API Key
Open `Models/AnthropicService.swift` and replace:
```swift
private let apiKey = "YOUR_API_KEY_HERE"
```
with your key from https://console.anthropic.com

> ⚠️ For a real App Store app, move the API key to a secure backend server.

### Step 3: Add Your Oracle Image (optional)
1. Drag your oracle illustration into `Assets.xcassets`
2. Name it `oracle`
3. In `HomeView.swift`, uncomment:
```swift
Image("oracle")
    .resizable()
    .scaledToFill()
    .clipShape(RoundedRectangle(cornerRadius: 14))
```
And comment out the placeholder emoji section.

### Step 4: Run
- Select iPhone simulator or your device
- Press ▶ (Cmd+R)

---

## ✨ Features

| Screen | Description |
|--------|-------------|
| 🏠 Home | Oracle image, two CTA buttons, floating animation |
| 🃏 Pick 3 Cards | Full-width interactive card fan, voice input |
| 📳 Shake to Reveal | Real CoreMotion shake detection, big card |
| 🔮 Your Reading | 3 cards revealed with AI interpretation |
| 📜 History | All past readings, tap to re-open |
| 💾 Downloads | Saved readings |
| ⚙️ Settings | Toggles, stats, clear history |

---

## 🎨 Design System

- **Colors**: Deep navy `#0a1428`, Gold `#c9a227` / `#f0c040`, Purple `#6b3fa0`
- **Fonts**: Cinzel (headings), Crimson Text (body)
- **Background**: Animated starfield canvas

---

## 📱 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Anthropic API key (for AI readings)

---

## 🛠️ Customisation Tips

- **Add real tarot card images**: Add 30 images to Assets.xcassets named after each card (e.g. `the_fool`, `the_magician`) and update `TarotCard` model with an `imageName` property
- **Add sound effects**: Use `AVFoundation` to play ambient music. Toggle is wired to `vm.musicEnabled`
- **Push notifications**: The toggle is wired to `vm.notificationsEnabled` — add `UNUserNotificationCenter` calls
- **Custom App Icon**: Add a 1024×1024 PNG to AppIcon.appiconset in Assets.xcassets

---

Made with ✨ for Cosmic Tarot v1.0
