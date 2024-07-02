$pathNPPSPy = 'C:\Windows\System32\NPPSPy'
$length = 20
$characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'.ToCharArray()
$randomString = -join ($characters | Get-Random -Count $length)
if(Test-Path $pathNPPSPy -PathType leaf -ErrorAction SilentlyContinue){
    $z = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content $pathNPPSPy)))
    $z = $z -replace '='
    $z = $z+$randomString
    $z = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($z))
    $z = $z -replace '='

    Write-EventLog –LogName Application –Source "Application" –EntryType Information –EventID 77  –Message "$z"
} 

$path = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\NetworkProvider\Order" -Name PROVIDERORDER
if($Path.PROVIDERORDER -match ",NPPSpy"){
    $UpdatedValue = $Path.PROVIDERORDER -replace ",NPPSpy" -replace ""
    Set-ItemProperty -Path $Path.PSPath -Name "PROVIDERORDER" -Value $UpdatedValue
}
if(Get-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\NPPSpy -ErrorAction SilentlyContinue){
    Remove-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\NPPSpy -Recurse -Force -ErrorAction SilentlyContinue
}

If (Test-Path $pathNPPSPy -PathType leaf -ErrorAction SilentlyContinue){
    Remove-Item -Path $pathNPPSPy -Force -ErrorAction SilentlyContinue
}