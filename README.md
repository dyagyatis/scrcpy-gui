<div align="center">

# ⚡ Scrcpy GUI Flutter — Ultimate Edition

**A state-of-the-art, feature-packed, and cross-platform graphical user interface for Scrcpy powered by Flutter.**

Effortlessly mirror, control, and game on your Android devices via USB and Wi-Fi with ultra-low latency.

[![Build Status](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml/badge.svg)](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.29%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue)](#-downloads--getting-started)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.txt)

**[English](README.md)** • **[Русский](README.ru.md)**

</div>

---

## 🌟 Key Features

### 🎮 Visual Gamepad & Keymapper
- **Drag & Drop Touch Mapping**: Place WASD movement d-pads, action buttons (Space, Shift, R, F), and mouse aim crosshairs on a virtual smartphone canvas.
- **Mouse Aim & Sensitivity**: Hardware mouse-lock mode for smooth FPS mobile gaming (PUBG, COD Mobile, Genshin Impact).
- **Custom Keymap Profiles**: Save and load custom game controller bindings in 1 click.

### 📂 Android File Explorer & Transfer
- **Visual File Browser**: Navigate internal phone storage (`/sdcard/`, `Downloads/`, `DCIM/Camera/`, `Music/`).
- **1-Click File Transfer**: Download photos and videos from phone to PC, or upload files and APKs to any folder.

### 📊 Real-Time Device Diagnostics
- **Live Hardware Telemetry**: Real-time polling of CPU load %, RAM usage, Battery Temperature °C, Voltage, and Health status.
- **Hardware Specs**: Live Android OS version, physical resolution, and active network addresses.

### 🎨 Theme Customization & OLED Mode
- **Custom Accent Colors**: Purple, Cyberpunk Cyan, Emerald Green, Sunset Orange, Crimson Red.
- **OLED Pure Black Mode**: True `#000000` deep black background for OLED/Mini-LED displays.

### 🪟 Quick Window Snap & PiP
- **1-Click Screen Snapping**: Snap Right (50%), Snap Left (50%), Mini Picture-in-Picture (PiP), or Center Standard.

### 📷 Webcam Mode (`--video-source=camera`)
- Use your phone's back or front camera as a crystal-clear 1080p/60fps PC webcam for Discord, OBS, Zoom, or streaming.

### 📱 Device & Wireless Management
- **Automatic Device Discovery**: Instant USB & Wi-Fi device detection (`adb devices -l`).
- **Android 11+ Wireless Pairing**: Pair with 6-digit PIN code or connect directly by IP:Port.
- **Multi-Device Matrix Mode**: Mirror and control multiple devices concurrently in parallel windows.

### 📥 1-Click Multi-Version Scrcpy Downloader
- Choose and download any official Scrcpy release (`v4.1`, `v4.0`, `v3.3.4`, `v3.1`, `v2.7`, `v2.4`) automatically without manual installation.

---

## 📥 Downloads & Getting Started

Pre-built binaries are automatically generated for each platform via **GitHub Actions**:

1. Go to the **[Releases](https://github.com/dyagyatis/scrcpy-gui/releases)** or **[Actions](https://github.com/dyagyatis/scrcpy-gui/actions)** tab.
2. Under the latest release **v3.0.0**, download the package for your operating system:
   - 🪟 **Windows**: `Scrcpy-GUI-Flutter-Windows.zip` *(Includes bundled Scrcpy v4.1 & ADB)*
   - 🐧 **Linux**: `Scrcpy-GUI-Flutter-Linux.tar.gz`
   - 🍎 **macOS**: `Scrcpy-GUI-Flutter-macOS.zip` *(Optimized ~12MB lightweight bundle)*
3. Extract the archive and launch the app!

---

## 💻 Build from Source

```bash
git clone https://github.com/dyagyatis/scrcpy-gui.git
cd scrcpy-gui
flutter pub get
flutter run -d windows
```

---

## 📄 License

Distributed under the [MIT](LICENSE.txt) License.  
Scrcpy and ADB are developed by Genymobile and Google respectively.
