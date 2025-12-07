@echo off
setlocal EnableDelayedExpansion

:: 1. Sprawdzenie uprawnien Administratora
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo =====================================================
    echo BLAD: Skrypt musi byc uruchomiony jako ADMINISTRATOR.
    echo Kliknij prawym przyciskiem myszy i wybierz
    echo "Uruchom jako administrator".
    echo =====================================================
    pause
    exit
)

:: 2. Konfiguracja zmiennych
set "TARGET_DIR=C:\Windows\Setup\Scripts"
set "BASE_URL=https://raw.githubusercontent.com/github77zz/velo/refs/heads/main/"

echo Tworzenie katalogu: %TARGET_DIR%
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

:: Lista plikow do pobrania
set FILES="RemovePackages.ps1" "RemoveCapabilities.ps1" "RemoveFeatures.ps1" "ShowAllTrayIcons.ps1" "ShowAllTrayIcons.xml" "ShowAllTrayIcons.vbs" "SetStartPins.ps1" "Specialize.ps1" "UserOnce.ps1" "DefaultUser.ps1" "FirstLogon.ps1"

:: 3. Pobieranie plikow
echo.
echo -----------------------------------------------------
echo Rozpoczynam pobieranie plikow z GitHub...
echo -----------------------------------------------------

for %%F in (%FILES%) do (
    echo Pobieranie: %%~F
    curl -L -f -o "%TARGET_DIR%\%%~F" "%BASE_URL%%%~F"
    
    if errorlevel 1 (
        echo [BLAD] Nie udalo sie pobrac pliku: %%~F
    ) else (
        echo [OK] %%~F
    )
)

echo.
echo -----------------------------------------------------
echo Pobieranie zakonczone. Rozpoczynam wykonywanie skryptow...
echo -----------------------------------------------------
echo.

:: 4. Uruchamianie w odpowiedniej kolejnosci

:: KROK A: Specialize.ps1
:: Ten skrypt zarzadza systemem i wywoluje wewnetrznie:
:: RemovePackages, RemoveCapabilities, RemoveFeatures, SetStartPins
echo [1/4] Uruchamianie Specialize.ps1 (Konfiguracja systemu i czyszczenie bloatware)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TARGET_DIR%\Specialize.ps1"

:: KROK B: DefaultUser.ps1
:: Konfiguruje rejestr domyslnego uzytkownika i wywoluje ShowAllTrayIcons
echo.
echo [2/4] Uruchamianie DefaultUser.ps1 (Ustawienia domyslne uzytkownika)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TARGET_DIR%\DefaultUser.ps1"

:: KROK C: UserOnce.ps1
:: Konfiguruje biezacego uzytkownika (usuniecie skrotow Edge, restart explorera)
echo.
echo [3/4] Uruchamianie UserOnce.ps1 (Konfiguracja obecnej sesji)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TARGET_DIR%\UserOnce.ps1"

:: KROK D: FirstLogon.ps1
:: UWAGA: Ten skrypt usuwa folder C:\Windows\Setup\Scripts!
echo.
echo -----------------------------------------------------
echo [WAZNE] Krok 4: FirstLogon.ps1
echo Ten skrypt sluzy do SPRZATANIA po instalacji.
echo Jesli go uruchomisz, usunie on folder %TARGET_DIR%
echo i wszystkie pobrane przed chwila pliki.
echo.
echo Nacisnij dowolny klawisz, aby wykonac sprzatanie i zakonczyc.
echo Zamknij to okno (X), jesli chcesz zachowac pliki.
echo -----------------------------------------------------
pause

echo [4/4] Uruchamianie FirstLogon.ps1 (Sprzatanie)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%TARGET_DIR%\FirstLogon.ps1"

echo.
echo Zakonczono.
pause
