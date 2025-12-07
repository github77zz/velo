# --- KONFIGURACJA ---
$DomainName = "MOJADOMENA"      # Nazwa Twojej domeny (NetBIOS, np. FIRMA)
$UserName   = "jan.kowalski"    # Login użytkownika w domenie
$GroupName  = "Administratorzy" # "Administratorzy" (PL) lub "Administrators" (EN)

# Budowanie pełnej nazwy (format DOMENA\Użytkownik)
$DomainUser = "$DomainName\$UserName"

# --- WYKONANIE ---
Try {
    # Sprawdzenie, czy grupa istnieje (dla pewności nazwy)
    if (-not (Get-LocalGroup -Name $GroupName -ErrorAction SilentlyContinue)) {
        Write-Warning "Grupa '$GroupName' nie została znaleziona. Sprawdź, czy masz polski system (Administratorzy) czy angielski (Administrators)."
    }
    else {
        # Dodanie użytkownika domenowego do grupy lokalnej
        Add-LocalGroupMember -Group $GroupName -Member $DomainUser -ErrorAction Stop
        
        Write-Host "SUKCES: Użytkownik '$DomainUser' został dodany do grupy '$GroupName'." -ForegroundColor Green
    }
}
Catch {
    # Obsługa błędów (np. literówka w nazwie użytkownika lub brak dostępu do DC)
    Write-Error "BŁĄD: Nie udało się dodać użytkownika. Szczegóły: $_"
    Write-Host "Wskazówka: Upewnij się, że komputer widzi domenę i nazwa użytkownika jest poprawna." -ForegroundColor Yellow
}
