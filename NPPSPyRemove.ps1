$path = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\NetworkProvider\Order" -Name PROVIDERORDER
if($Path.PROVIDERORDER -match ",NPPSpy"){
    $UpdatedValue = $Path.PROVIDERORDER -replace ",NPPSpy" -replace ""
    Set-ItemProperty -Path $Path.PSPath -Name "PROVIDERORDER" -Value $UpdatedValue
}
if(Get-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\NPPSpy -ErrorAction SilentlyContinue){
    Remove-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\NPPSpy -Recurse -Force -ErrorAction SilentlyContinue
}
$pathNPPSPy = 'C:\Windows\System32\NPPSPy'
If (Test-Path $pathNPPSPy -PathType leaf -ErrorAction SilentlyContinue){
    Remove-Item -Path $pathNPPSPy -Force -ErrorAction SilentlyContinue
}