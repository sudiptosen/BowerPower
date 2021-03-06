﻿param($installPath, $toolsPath, $package, $project)
$targetHome = "$HOME\Documents\WindowsPowerShell\Modules"
$bowerPowerDir = "$targetHome\BowerPower"

Write-Host "========================================"
Write-Host "Installing BowerPower..."

$CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")

if($CurrentValue.IndexOf('bowerpower', [System.StringComparison]::OrdinalIgnoreCase) -gt 0){
	Write-Host "Environment variable all set..."
}
else{
	Write-Host "Setting up environment variable..."
	$newEnvPath = ($CurrentValue + ";$bowerPowerDir")
	[Environment]::SetEnvironmentVariable("PSModulePath", $newEnvPath, [EnvironmentVariableTarget]::Machine)
}

Write-Host "Copying required files..."
#Remove-Module "BowerPower"
if(Test-Path($bowerPowerDir)){Remove-Item $bowerPowerDir -Force -Recurse}
New-Item $bowerPowerDir -type Directory
Copy-Item "$toolsPath\BowerPower.psm1" $bowerPowerDir
Write-Host "All files copied..."

Write-Host "Stating to import copied modules..."
Import-Module "BowerPower"
Write-Host "All required modules imported..."
Write-Host "Installation done..."
Write-Host "========================================"
