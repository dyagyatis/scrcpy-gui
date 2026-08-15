<div align="center">

# ⚡ Scrcpy GUI Flutter

**Современный, быстрый и кроссплатформенный графический интерфейс для Scrcpy на базе Flutter.**

Управление и трансляция экрана Android-устройств по USB и Wi-Fi без задержек.

[![Build Status](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml/badge.svg)](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.29%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue)](#-скачать-и-запустить)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.txt)

[🇷🇺 Описание на русском](#-основные-возможности) • [🇬🇧 English Description](#-english-summary) • [📥 Скачать](#-скачать-и-запустить)

</div>

---

## 🌟 Основные возможности

### 📱 Управление устройствами
- **Автопоиск подключенных устройств**: Мгновенный поиск телефонов и планшетов по USB и сети.
- **Подключение по Wi-Fi ADB**:
  - Быстрое подключение по `IP:Port` с историей последних адресов.
  - Поддержка **Android 11+ Wireless Pairing** (сопряжение по 6-значному коду).
  - Перевод USB-устройства в беспроводной режим в один клик (`adb tcpip 5555`).
- **Параллельные сессии**: Управление несколькими устройствами одновременно в отдельных окнах.

### ⚡ Профили в 1 клик (Пресеты)
- ⚡ **Стандарт** — оптимальный баланс качества и скорости (H.264, 8 Мбит/с).
- 🎮 **Игровой** — ультра-низкая задержка, 120 FPS, 1080p, минимальный буфер.
- 🌟 **Макс. качество** — исходное разрешение экрана, 24 Мбит/с, кодек H.265 / HEVC.
- 🔋 **Эко** — 720p, 4 Мбит/с, 30 FPS для медленного или нестабильного Wi-Fi соединения.
- 🕶 **Скрытый экран** — трансляция с выключенным экраном смартфона (экономия батареи).
- 🎵 **Только звук** — передача аудиопотока без видео.

### 📐 Гибкая настройка видео, аудио и окна
- **Видео**:
  - Выбор разрешения (исходное, 1440p, 1080p, 720p, 480p).
  - Настройка битрейта (1–50 Мбит/с) и лимита кадров (30, 60, 90, 120 FPS, без ограничений).
  - Видеокодеки: **H.264**, **H.265 (HEVC)**, **AV1**.
  - Фиксация ориентации экрана (90°, 180°, 270°) и регулировка видеобуфера.
- **Аудио**:
  - Включение/отключение трансляции звука на ПК (Android 11+).
  - Аудиокодеки: **OPUS**, **AAC**, **FLAC**, **RAW**.
  - Настройка битрейта (64, 128, 192, 320 Кбит/с) и возможность заглушить динамик телефона.
- **Геометрия и поведение окна**:
  - Произвольные размеры окна (`--window-width` / `--window-height`) в пикселях.
  - Быстрые шаблоны: *Компактный (400×850)*, *Стандартный (500×1050)*, *Большой (650×1400)*, *Full HD (1920×1080)*.
  - Точное позиционирование на мониторе (`--window-x`, `--window-y`).
  - Режимы: **Поверх всех окон (Always on Top)**, **Полноэкранный**, **Без рамок (Borderless)**.
  - Режим **«Только просмотр»** и **OTG-режим** (использование ПК как USB-клавиатуры/мыши).

### 🛠 Встроенные утилиты ADB
- **Установка приложений**: Быстрая установка `.apk` файлов.
- **Скриншоты в 1 клик**: Мгновенный снимок экрана через ADB без водяных знаков.
- **Запись видео**: Запись экрана в форматы **MP4** или **MKV**.
- **Клавиши навигации**: Питание/Экран, Домой, Назад, Громкость +/-, Меню приложений.
- **Перезагрузка**: В систему, Recovery или Bootloader/Fastboot.
- **Консоль логов**: Живой просмотр сгенерированной команды CLI и вывода stdout/stderr.

---

## 📥 Скачать и запустить

Готовые сборки формируются автоматически через **GitHub Actions** для каждой платформы:

1. Перейдите в раздел **[Actions](https://github.com/dyagyatis/scrcpy-gui/actions)**.
2. Выберите последнюю успешную сборку `Build Multi-Platform`.
3. Внизу в блоке **Artifacts** скачайте архив для вашей ОС:
   - 🪟 **Windows**: `Scrcpy-GUI-Flutter-Windows` *(включает встроенный Scrcpy v4.1 и ADB)*
   - 🐧 **Linux**: `Scrcpy-GUI-Flutter-Linux`
   - 🍎 **macOS**: `Scrcpy-GUI-Flutter-macOS`
4. Распакуйте архив и запустите приложение!

---

## 💻 Локальная сборка из исходников

### Требования:
- [Flutter SDK](https://flutter.dev) (версия 3.24 или новее)
- Установленный `scrcpy` и `adb` в системе (или в папке `bin/`)

### Инструкция:
```bash
# Клонировать репозиторий
git clone https://github.com/dyagyatis/scrcpy-gui.git
cd scrcpy-gui

# Установить зависимости Flutter
flutter pub get

# Запуск в режиме разработки (Windows)
flutter run -d windows

# Сборка Release версии
flutter build windows --release
```

---

## 🇬🇧 English Summary

**Scrcpy GUI Flutter** is a modern, responsive, and cross-platform graphical user interface for [Genymobile/scrcpy](https://github.com/Genymobile/scrcpy).

- **Multi-Device**: Launch and manage multiple device mirroring sessions side-by-side.
- **Wireless ADB**: Direct IP connect and Android 11+ wireless pairing code support.
- **Fine-grained Controls**: H.264/H.265/AV1 codecs, OPUS/AAC audio forwarding, custom resolution, and bitrate controls.
- **Window Customization**: Set custom width, height, and screen coordinates, or choose from smartphone/tablet presets.
- **Built-in Tools**: Install APKs, capture lossless screenshots, record to MP4/MKV, and reboot to Recovery/Fastboot.
- **Cross-Platform**: Automated CI/CD builds for Windows, macOS, and Linux via GitHub Actions.

---

## 📄 Лицензия

Распространяется под лицензией [MIT](LICENSE.txt).  
Scrcpy и ADB являются разработками Genymobile и Google соответственно.
