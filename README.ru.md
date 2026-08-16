<div align="center">

# ⚡ Scrcpy GUI Flutter — Ultimate Edition

**Современный, многофункциональный и ультрабыстрый графический интерфейс для Scrcpy на базе Flutter.**

Управление, мобильный гейминг и трансляция экрана Android-устройств по USB и Wi-Fi без задержек.

[![Build Status](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml/badge.svg)](https://github.com/dyagyatis/scrcpy-gui/actions/workflows/build.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.29%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue)](#-скачать-и-запустить)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE.txt)

**[English](README.md)** • **[Русский](README.ru.md)**

</div>

---

## 🌟 Главные возможности

### 🎮 Визуальный Кеймаппер для игр
- **Drag & Drop расстановка кнопок**: Настройка клавиш WASD, прыжка (Space), перезарядки (R, Shift, F) и прицеливания мышью прямо на виртуальном экране смартфона.
- **Прицеливание мышью и чувствительность**: Режим аппаратного захвата мыши для комфортной игры в PUBG, COD Mobile, Genshin Impact на ПК.
- **Профили раскладок**: Сохранение и быстрая загрузка кеймапов в 1 клик.

### 📂 Встроенный файловый менеджер Android
- **Просмотр внутренней памяти**: Навигация по `/sdcard/`, `Downloads/`, `DCIM/Camera/`, `Music/`, `Pictures/`.
- **Передача файлов в 1 клик**: Скачивание фото и видео с телефона на ПК и быстрая загрузка файлов на устройство.

### 📊 Мониторинг устройства в реальном времени
- **Аппаратная телеметрия**: Опрос нагрузки CPU %, занятой оперативной памяти (RAM MB / %), температуры батареи °C и напряжения в режиме реального времени.
- **Характеристики**: Точная модель, версия Android, физическое разрешение экрана и IP-адреса.

### 🎨 Кастомизация темы и OLED режим
- **Выбор акцентного цвета**: Фиолетовый (Purple), Неоновый Циан (Cyberpunk Cyan), Изумрудный (Emerald), Закатный Оранжевый (Sunset Orange), Багровый (Crimson).
- **Режим OLED Black**: Абсолютно черный фон `#000000` для максимальной контрастности и экономии энергии на OLED-мониторах.

### 🪟 Быстрое позиционирование окна (Window Snap)
- **Прилипание в 1 клик**: Окно справа (50%), слева (50%), режим мини «Картинка в картинке» (PiP) или по центру.

### 📷 Камера телефона как веб-камера ПК (`--video-source=camera`)
- Использование основной или фронтальной камеры смартфона в качестве веб-камеры ПК (1080p / 60 FPS) для Discord, OBS, Zoom и стримов.

### 📱 Управление устройствами и Wi-Fi ADB
- **Автопоиск**: Мгновенное обнаружение устройств по USB и Wi-Fi (`adb devices -l`).
- **Android 11+ Pairing**: Сопряжение по 6-значному PIN-коду и прямое подключение по IP:Port.
- **Multi-Device Matrix Mode**: Одновременный запуск зеркалирования сразу нескольких смартфонов в параллельных окнах.

### 📥 Скачивание любых версий Scrcpy
- Выбор и автоматическая загрузка любой официальной версии Scrcpy (`v4.1`, `v4.0`, `v3.3.4`, `v3.1`, `v2.7`, `v2.4`) в 1 клик прямо из GUI.

---

## 📥 Скачать и запустить

Готовые сборки формируются автоматически через **GitHub Actions**:

1. Перейдите на страницу **[Releases](https://github.com/dyagyatis/scrcpy-gui/releases)**.
2. В релизе **v3.0.0** скачайте архив для вашей ОС:
   - 🪟 **Windows**: `Scrcpy-GUI-Flutter-Windows.zip` *(содержит встроенный Scrcpy v4.1 и ADB)*
   - 🐧 **Linux**: `Scrcpy-GUI-Flutter-Linux.tar.gz`
   - 🍎 **macOS**: `Scrcpy-GUI-Flutter-macOS.zip` *(оптимизированный легковесный бандл ~12 МБ)*
3. Распакуйте архив и запускайте!

---

## 💻 Сборка из исходного кода

```bash
git clone https://github.com/dyagyatis/scrcpy-gui.git
cd scrcpy-gui
flutter pub get
flutter run -d windows
```

---

## 📄 Лицензия

Распространяется под лицензией [MIT](LICENSE.txt).  
Scrcpy и ADB являются разработками Genymobile и Google соответственно.
