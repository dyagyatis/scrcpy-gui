<div align="center">

# ⚡ Scrcpy GUI Flutter

**A modern, lightweight, and cross-platform graphical user interface for Scrcpy powered by Flutter.**

Effortlessly mirror and control your Android devices via USB and Wi-Fi with ultra-low latency.

[![Build Status](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml/badge.svg)](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.29%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue)](#-downloads--getting-started)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.txt)

**[English](README.md)** • **[Русский](README.ru.md)**

</div>

---

## 🌟 Key Features

### 📱 Device Management
- **Automatic Device Discovery**: Instantly detects Android devices connected via USB or network (`adb devices -l`).
- **Wireless ADB Support**:
  - Direct connect via `IP:Port` with history of recent IP addresses.
  - Full **Android 11+ Wireless Pairing** support (pair with 6-digit PIN code & port).
  - One-click USB to Wi-Fi mode switch (`adb tcpip 5555`).
- **Multi-Device / Parallel Sessions**: Run and manage multiple device mirrors simultaneously in separate windows.

### ⚡ 1-Click Quick Presets
- ⚡ **Default** — Balanced quality and performance (H.264, 8 Mbps).
- 🎮 **Gaming** — Ultra-low latency, 120 FPS, 1080p, minimum buffer.
- 🌟 **Max Quality** — Native resolution, 24 Mbps, H.265 / HEVC codec.
- 🔋 **Eco** — 720p, 4 Mbps, 30 FPS for slow or unstable Wi-Fi networks.
- 🕶 **Stealth Screen** — Device screen remains OFF while fully controllable on PC (saves battery).
- 🎵 **Audio Only** — Forward audio stream without capturing video.

### 📐 Video, Audio & Window Customization
- **Video Stream**:
  - Resolution selector (Native, 1440p, 1080p, 720p, 480p).
  - Bitrate control (1–50 Mbps) and framerate limiter (30, 60, 90, 120 FPS, unlimited).
  - Video codecs: **H.264**, **H.265 (HEVC)**, **AV1**.
  - Screen orientation lock (90°, 180°, 270°) and customizable video buffer.
- **Audio Forwarding**:
  - Enable/disable audio streaming to PC (Android 11+).
  - Audio codecs: **OPUS**, **AAC**, **FLAC**, **RAW**.
  - Audio bitrate (64, 128, 192, 320 kbps) and mute device speaker toggle.
- **Window Geometry & Behavior**:
  - Custom window dimensions (`--window-width` / `--window-height`) in pixels.
  - Quick dimension presets: *Compact Phone (400×850)*, *Standard (500×1050)*, *Large (650×1400)*, *Full HD (1920×1080)*.
  - Exact screen positioning (`--window-x`, `--window-y`).
  - Window modes: **Always on Top**, **Fullscreen**, **Borderless**.
  - **Read-Only Mode** (view only, disable mouse/keyboard inputs) and **OTG Mode** (use PC as USB keyboard/mouse).

### 🛠 Built-in ADB Tools
- **APK Installer**: Fast Drag & Drop or file chooser `.apk` installation.
- **Instant Screenshots**: 1-click lossless screenshot capture via ADB.
- **Video Recording**: Record sessions directly into **MP4** or **MKV** format.
- **Navigation Controls**: Power/Screen, Home, Back, Volume +/-, App Switcher.
- **Reboot Utilities**: Reboot to System, Recovery, or Bootloader/Fastboot.
- **Real-Time Log Console**: Live command preview and stdout/stderr logger.

---

## 📥 Downloads & Getting Started

Pre-built binaries are automatically generated for each platform via **GitHub Actions**:

1. Go to the **[Actions](https://github.com/dyagyatis/scrcpy-gui/actions)** tab.
2. Select the latest successful `Build Multi-Platform` workflow run.
3. Under the **Artifacts** section at the bottom, download the package for your OS:
   - 🪟 **Windows**: `Scrcpy-GUI-Flutter-Windows` *(Includes bundled Scrcpy v4.1 & ADB)*
   - 🐧 **Linux**: `Scrcpy-GUI-Flutter-Linux`
   - 🍎 **macOS**: `Scrcpy-GUI-Flutter-macOS`
4. Extract the `.zip` archive and run the executable!

---

## 💻 Build from Source

### Prerequisites:
- [Flutter SDK](https://flutter.dev) (v3.24 or newer)
- `scrcpy` and `adb` installed on your system (or placed in the `bin/` folder)

### Instructions:
```bash
# Clone the repository
git clone https://github.com/dyagyatis/scrcpy-gui.git
cd scrcpy-gui

# Get Flutter dependencies
flutter pub get

# Run in development mode (Windows)
flutter run -d windows

# Build Release executable
flutter build windows --release
```

---

## 📄 License

Distributed under the [MIT](LICENSE.txt) License.  
Scrcpy and ADB are developed by Genymobile and Google respectively.
