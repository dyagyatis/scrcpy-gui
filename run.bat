@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter SDK не найден в PATH.
    echo Пожалуйста, добавьте путь к папке bin вашего Flutter SDK в переменную окружения PATH.
    echo Либо запустите проект через VS Code / Android Studio.
    pause
    exit /b 1
)

echo [INFO] Запуск Scrcpy GUI Flutter...
flutter run -d windows
