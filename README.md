# 🔮 Cosmic Tarot iOS App

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

Made with ✨ for Cosmic Tarot v1.0
