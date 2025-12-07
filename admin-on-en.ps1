# --- KONFIGURACJA ---
$Username = "admin"
$Password = "TwojeSilneHaslo123!"  # Zmień na bezpieczne hasło
$GroupName = "Administratorzy"     # W polskim Windows to "Administratorzy", w angielskim "Administrators"

# --- ZABEZPIECZENIE HASŁA ---
# Konwersja hasła tekstowego na SecureString (wymagane przez polecenie New-LocalUser)
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

# --- TWORZENIE UŻYTKOWNIKA ---
Try {
    # Sprawdź, czy użytkownik już istnieje
    if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
        Write-Warning "Użytkownik '$Username' już istnieje."
    }
    else {
        # Utworzenie nowego użytkownika
        New-LocalUser -Name $Username `
                      -Password $SecurePassword `
                      -FullName "Lokalny Administrator" `
                      -Description "Konto utworzone przez skrypt PowerShell" `
                      -PasswordNeverExpires

        Write-Host "Pomyślnie utworzono użytkownika '$Username'." -ForegroundColor Green
    }

    # --- DODAWANIE DO GRUPY ---
    # Dodanie użytkownika do grupy Administratorzy
    Add-LocalGroupMember -Group $GroupName -Member $Username
    
    Write-Host "Pomyślnie dodano użytkownika '$Username' do grupy '$GroupName'." -ForegroundColor Green
}
Catch {
    Write-Error "Wystąpił błąd: $_"
}
