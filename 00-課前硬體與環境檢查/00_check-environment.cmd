@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Local RAG Environment Check
set "RAG_REPAIR_SCRIPT=%~f0"
set "RAG_REPAIR_DIR=%~dp0"
if /i "%~1"=="/repair" goto repair

echo Local RAG Environment Check
echo This script only reads system information unless you choose repair
echo.
powershell.exe -NoLogo -NoProfile -Command "$content=Get-Content -LiteralPath $env:RAG_REPAIR_SCRIPT; $marker=[Array]::IndexOf($content,'# POWERSHELL_CHECK'); if($marker -lt 0){exit 99}; $code=$content[($marker+1)..($content.Length-1)] -join [Environment]::NewLine; Invoke-Command ([ScriptBlock]::Create($code))"
set "CHECK_RESULT=!ERRORLEVEL!"
echo.
echo Recommended baseline
echo Windows 11 ^| 4 cores 8 threads ^| 16 GB RAM ^| 50 GB free SSD ^| Virtualization and SLAT supported
echo.
if "!CHECK_RESULT!"=="10" goto repair_prompt
if "!CHECK_RESULT!"=="99" echo [UNKNOWN] Internal check code could not be loaded
echo Press any key to close this window
pause >nul
exit /b

:repair_prompt
echo Optional repair is available
echo R = Enable WSL2 features, install WSL, and enable hypervisor startup
echo X = Close without making changes
choice /c RX /n /m "Press R to repair or X to close: "
if errorlevel 2 exit /b
powershell.exe -NoLogo -NoProfile -Command "$q=[char]34; $a='/d /c '+$q+$q+$env:RAG_REPAIR_SCRIPT+$q+' /repair'+$q; Start-Process -FilePath $env:ComSpec -ArgumentList $a -WorkingDirectory $env:RAG_REPAIR_DIR -Verb RunAs -Wait"
if not errorlevel 1 exit /b
echo.
echo Repair was not started
echo Run the check again and approve the Windows permission request
echo.
echo Press any key to close this window
pause >nul
exit /b

:repair
title Local RAG WSL2 Repair
fltmc >nul 2>&1
if not errorlevel 1 goto repair_admin_ready
echo Administrator permission was not granted
echo Start this script normally, choose R, and approve the Windows permission request
echo.
echo Press any key to close this window
pause >nul
exit /b

:repair_admin_ready
echo Local RAG WSL2 Repair
echo This action enables required Windows features, installs WSL, and enables hypervisor startup
echo Internet access may be required for the WSL installation
echo.
set "REPAIR_FAILED=0"

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
set "STEP_RESULT=!ERRORLEVEL!"
if not "!STEP_RESULT!"=="0" if not "!STEP_RESULT!"=="3010" set "REPAIR_FAILED=1"

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
set "STEP_RESULT=!ERRORLEVEL!"
if not "!STEP_RESULT!"=="0" if not "!STEP_RESULT!"=="3010" set "REPAIR_FAILED=1"

bcdedit.exe /set hypervisorlaunchtype Auto
if errorlevel 1 set "REPAIR_FAILED=1"

where.exe wsl.exe >nul 2>&1
if errorlevel 1 goto wsl_command_missing
wsl.exe --install --no-distribution
set "STEP_RESULT=!ERRORLEVEL!"
if not "!STEP_RESULT!"=="0" if not "!STEP_RESULT!"=="3010" set "REPAIR_FAILED=1"
goto repair_summary

:wsl_command_missing
echo.
echo The WSL command is unavailable
echo Complete Windows Update and ask the teacher for help
set "REPAIR_FAILED=1"

:repair_summary
echo.
if "!REPAIR_FAILED!"=="1" goto repair_failed
echo Repair settings were applied successfully
echo Save your work and restart Windows before running this check again
goto repair_end

:repair_failed
echo Repair did not complete successfully
echo Record the error shown above and ask the teacher for help

:repair_end
echo.
echo Press any key to close this window
pause >nul
exit /b

# POWERSHELL_CHECK
$ErrorActionPreference = 'SilentlyContinue'

function Show {
    param(
        [string]$Status,
        [string]$Name,
        [string]$Value
    )

    $color = switch ($Status) {
        'PASS' { 'Green' }
        'WARN' { 'Yellow' }
        'UNKNOWN' { 'Magenta' }
        default { 'Cyan' }
    }

    Write-Host ('[{0}] {1}: {2}' -f $Status, $Name, $Value) -ForegroundColor $color
}

$os = Get-CimInstance Win32_OperatingSystem
$computer = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$features = Get-CimInstance Win32_OptionalFeature
$hypervisor = $computer.HypervisorPresent

$build = [Environment]::OSVersion.Version.Build
$arch = if ($os.OSArchitecture) {
    $os.OSArchitecture
} elseif ([Environment]::Is64BitOperatingSystem) {
    '64-bit'
} else {
    '32-bit'
}
$win = if ($os.Caption) {
    $os.Caption
} elseif ($build -ge 22000) {
    'Windows 11'
} else {
    [Environment]::OSVersion.VersionString
}
$status = if (($win -match 'Windows 11' -or $build -ge 22000) -and $arch -match '64') { 'PASS' } else { 'WARN' }
Show $status 'Windows' ($win + ' ' + $arch + ' | Build ' + $build)

$cpuName = if ($cpu.Name) { $cpu.Name.Trim() } else { $env:PROCESSOR_IDENTIFIER }
$cores = if ($cpu.NumberOfCores) { [int]$cpu.NumberOfCores } else { 0 }
$threads = if ($cpu.NumberOfLogicalProcessors) { [int]$cpu.NumberOfLogicalProcessors } else { [Environment]::ProcessorCount }
$status = if (-not $cores) { 'UNKNOWN' } elseif ($cores -ge 4 -and $threads -ge 8) { 'PASS' } else { 'WARN' }
$coreText = if ($cores) { $cores } else { 'Unknown' }
Show $status 'CPU' ($cpuName + ' | ' + $coreText + ' cores | ' + $threads + ' threads')

$ram = if ($computer.TotalPhysicalMemory) { [math]::Round($computer.TotalPhysicalMemory / 1GB, 1) } else { $null }
$status = if ($null -eq $ram) { 'UNKNOWN' } elseif ($ram -ge 15) { 'PASS' } else { 'WARN' }
$value = if ($null -eq $ram) { 'Unable to read' } else { $ram.ToString() + ' GB' }
Show $status 'Memory' $value

$drive = New-Object System.IO.DriveInfo($env:SystemDrive)
$free = if ($drive.IsReady) { [math]::Round($drive.AvailableFreeSpace / 1GB, 1) } else { $null }
$status = if ($null -eq $free) { 'UNKNOWN' } elseif ($free -ge 50) { 'PASS' } else { 'WARN' }
$value = if ($null -eq $free) { 'Unable to read' } else { $free.ToString() + ' GB' }
Show $status 'Free disk on system drive' $value

$virtFirmware = $cpu.VirtualizationFirmwareEnabled
if ($hypervisor -eq $true) {
    Show 'PASS' 'Firmware virtualization' 'Enabled | Windows hypervisor detected'
} elseif ($null -eq $virtFirmware) {
    Show 'UNKNOWN' 'Firmware virtualization' 'Unable to read'
} elseif ($virtFirmware) {
    Show 'PASS' 'Firmware virtualization' 'Enabled'
} else {
    Show 'WARN' 'Firmware virtualization' 'Not detected | confirm in Task Manager and BIOS or UEFI'
}

$slat = $cpu.SecondLevelAddressTranslationExtensions
if ($null -eq $slat -and $hypervisor -eq $true) {
    Show 'PASS' 'SLAT support' 'Supported | Windows hypervisor detected'
} elseif ($null -eq $slat) {
    Show 'UNKNOWN' 'SLAT support' 'Unable to read'
} elseif ($slat) {
    Show 'PASS' 'SLAT support' 'Supported'
} else {
    Show 'WARN' 'SLAT support' 'Not supported'
}

$vmp = $features | Where-Object { $_.Name -eq 'VirtualMachinePlatform' } | Select-Object -First 1
$vmpEnabled = $null -ne $vmp -and [int]$vmp.InstallState -eq 1
$status = if ($null -eq $vmp) { 'UNKNOWN' } elseif ($vmpEnabled) { 'PASS' } else { 'INFO' }
$value = if ($null -eq $vmp) { 'Unable to read' } elseif ($vmpEnabled) { 'Enabled' } else { 'Disabled | repair is available' }
Show $status 'Virtual Machine Platform' $value

$wslFeature = $features | Where-Object { $_.Name -eq 'Microsoft-Windows-Subsystem-Linux' } | Select-Object -First 1
$wslEnabled = $null -ne $wslFeature -and [int]$wslFeature.InstallState -eq 1
$status = if ($null -eq $wslFeature) { 'UNKNOWN' } elseif ($wslEnabled) { 'PASS' } else { 'INFO' }
$value = if ($null -eq $wslFeature) { 'Unable to read' } elseif ($wslEnabled) { 'Enabled' } else { 'Disabled | repair is available' }
Show $status 'WSL Windows feature' $value

$status = if ($null -eq $hypervisor) { 'UNKNOWN' } elseif ($hypervisor) { 'PASS' } elseif ($vmpEnabled) { 'WARN' } else { 'INFO' }
$value = if ($null -eq $hypervisor) {
    'Unable to read'
} elseif ($hypervisor) {
    'Running'
} elseif ($vmpEnabled) {
    'Not running | restart or check boot configuration'
} else {
    'Not running | repair is available'
}
Show $status 'Windows hypervisor' $value

$wslCommand = Get-Command wsl.exe
$wslCommandReady = $false
if ($null -eq $wslCommand) {
    Show 'INFO' 'WSL command' 'Not installed | repair is available'
} else {
    $null = & wsl.exe --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        $wslCommandReady = $true
        Show 'PASS' 'WSL command' 'Available'
    } elseif ($wslEnabled) {
        Show 'WARN' 'WSL command' 'Version check failed | repair is available'
    } else {
        Show 'INFO' 'WSL command' 'Available | Windows feature not enabled'
    }
}

$docker = docker.exe version --format '{{.Server.Version}}' 2>$null
if ($LASTEXITCODE -eq 0 -and $docker) {
    Show 'PASS' 'Docker Engine' $docker
} else {
    Show 'INFO' 'Docker Engine' 'Not installed or not running'
}

$gpu = nvidia-smi.exe --query-gpu=name,memory.total --format=csv,noheader 2>$null
if ($LASTEXITCODE -eq 0 -and $gpu) {
    Show 'PASS' 'NVIDIA GPU' ($gpu -join ' | ')
} else {
    Show 'INFO' 'NVIDIA GPU' 'Not detected | GPU is optional'
}

$needRepair =
    ($null -ne $vmp -and -not $vmpEnabled) -or
    ($null -ne $wslFeature -and -not $wslEnabled) -or
    ($vmpEnabled -and $hypervisor -eq $false) -or
    ($null -eq $wslCommand) -or
    ($null -ne $wslCommand -and -not $wslCommandReady)

if ($needRepair) {
    exit 10
}

exit 0
