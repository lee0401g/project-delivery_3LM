@echo off
setlocal DisableDelayedExpansion
set "LOCAL_AI_SCRIPT=%~f0"
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "$text=[IO.File]::ReadAllText($env:LOCAL_AI_SCRIPT); & ([scriptblock]::Create(($text -split '\r?\n# POWERSHELL_PAYLOAD\r?\n',2)[1]))"
if errorlevel 1 pause
exit /b
# POWERSHELL_PAYLOAD
$ErrorActionPreference = 'Stop'
$script:Version = '2026-09-16-r3'
$script:Compose = Join-Path (Split-Path $env:LOCAL_AI_SCRIPT) '03_compose.yaml'
$script:Url = 'http://localhost:3000/'

function Reset-Screen {
    # Preserve redirected logs; redraw interactive consoles only.
    if (-not [Console]::IsOutputRedirected) { Clear-Host }
}

function Invoke-Docker {
    param([string[]]$Arguments, [int]$Timeout = 10)
    # Arguments come from this script, never from menu input.
    $info = New-Object Diagnostics.ProcessStartInfo
    $info.FileName = $script:Docker
    $info.Arguments = (($Arguments | ForEach-Object { '"' + $_ + '"' }) -join ' ')
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $process = New-Object Diagnostics.Process
    $process.StartInfo = $info
    try {
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($Timeout * 1000)) {
            $process.Kill()
            throw 'Docker command timed out. Check Docker Desktop.'
        }
        return [pscustomobject]@{ Code=$process.ExitCode; Out=$stdout.Result; Err=$stderr.Result }
    } finally { $process.Dispose() }
}

function Test-Environment {
    if (-not (Test-Path -LiteralPath $script:Compose)) { throw '03_compose.yaml is missing. Keep the complete unit 03 folder together.' }
    $command = Get-Command docker.exe -ErrorAction SilentlyContinue
    if ($command) { $script:Docker = $command.Source }
    else {
        $script:Docker = @(
            "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe",
            "$env:LOCALAPPDATA\Programs\DockerDesktop\resources\bin\docker.exe"
        ) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
    }
    if (-not $script:Docker) { throw 'Docker CLI was not found. Install Docker Desktop or reopen this window after installation.' }
    $result = Invoke-Docker @('info','--format','{{.OSType}}')
    if ($result.Code -ne 0) {
        throw ('Docker Engine is unavailable. Open Docker Desktop, wait for Engine running, then retry. If Docker is already open, check its error message.' + "`n" + $result.Err)
    }
    if ($result.Out.Trim() -ne 'linux') { throw 'Switch Docker Desktop to Linux containers, then retry.' }
    $result = Invoke-Docker @('compose','version')
    if ($result.Code -ne 0) { throw 'Docker Compose is unavailable. Repair or update Docker Desktop.' }
    $result = Invoke-Docker @('compose','-f',$script:Compose,'config','--quiet')
    if ($result.Code -ne 0) { throw ('Compose configuration is invalid: ' + $result.Err) }
}

function Get-WebState {
    param([int]$Timeout = 5)
    $result = Invoke-Docker @('compose','-f',$script:Compose,'ps','--all','-q','open-webui') $Timeout
    if ($result.Code -ne 0) { throw ('Cannot query containers. Check Docker Engine. ' + $result.Err) }
    $id = $result.Out.Trim()
    if (-not $id) { return [pscustomobject]@{ State='missing'; Health='none' } }
    $result = Invoke-Docker @('inspect','--format','{{json .State}}',$id) $Timeout
    if ($result.Code -ne 0) { throw ('Cannot inspect Open WebUI. ' + $result.Err) }
    $state = $result.Out | ConvertFrom-Json
    $health = 'none'
    if ($state.Health) { $health = $state.Health.Status }
    return [pscustomobject]@{ State=$state.Status; Health=$health }
}

function Get-HttpStatus {
    param([int]$TimeoutMs = 2000)
    $response = $null
    try {
        $request = [Net.HttpWebRequest]::Create($script:Url)
        $request.Proxy = $null
        $request.Timeout = $TimeoutMs
        $request.ReadWriteTimeout = $TimeoutMs
        $request.AllowAutoRedirect = $false
        $response = $request.GetResponse()
        return [int]$response.StatusCode
    } catch [Net.WebException] {
        $response = $_.Exception.Response
        if ($response) { return [int]$response.StatusCode }
        return 0
    } finally { if ($response) { $response.Close() } }
}

function Get-ReadinessDecision {
    param($State, $Health, [int]$Http)
    if ($State -in @('missing','exited','dead','removing','paused')) {
        return 'fatal:Container is missing, stopped or paused. Resolve its state before retrying.'
    }
    if ($State -eq 'running' -and $Health -eq 'none') { return 'fatal:Container has no health check. Check the image and Compose configuration.' }
    if ($State -eq 'running' -and $Health -eq 'healthy' -and $Http -eq 200) { return 'ready' }
    if ($State -eq 'restarting' -or $Health -eq 'unhealthy') { return 'suspect:Container is restarting or unhealthy.' }
    if ($Http -ge 300 -and $Http -lt 500) { return 'suspect:Unexpected redirect, authentication or URL response.' }
    if ($Http -ge 500 -and $Http -notin @(502,503,504)) { return 'suspect:Web service returned an internal error.' }
    if ($Health -eq 'healthy') { return 'suspect:Container is healthy but the web page is not ready.' }
    return 'wait'
}

function Wait-WebUI {
    $timer = [Diagnostics.Stopwatch]::StartNew()
    $suspectSince = $null
    while ($timer.Elapsed.TotalSeconds -lt 180) {
        $pollStart = $timer.Elapsed.TotalSeconds
        $remaining = 180 - $pollStart
        $state = Get-WebState ([int][Math]::Max(1,[Math]::Min(5,[Math]::Floor($remaining / 2))))
        $remaining = 180 - $timer.Elapsed.TotalSeconds
        if ($remaining -le 0) { break }
        $http = 0
        if ($state.State -eq 'running') { $http = Get-HttpStatus ([int][Math]::Max(1,[Math]::Min(2000,$remaining * 1000))) }
        Reset-Screen
        Write-Host "Local AI Service Control - $script:Version" -ForegroundColor Cyan
        Write-Host 'Checking about every 5 seconds. Healthy + HTTP 200 opens the browser immediately.' -ForegroundColor Yellow
        Write-Host '180 seconds is the readiness timeout, not a fixed delay. Download time is separate.'
        Write-Host ''
        Write-Host ('state={0}  health={1}  HTTP={2:000}  elapsed={3}s  remaining={4}s' -f $state.State,$state.Health,$http,[int]$timer.Elapsed.TotalSeconds,[Math]::Max(0,[int](180-$timer.Elapsed.TotalSeconds)))
        $decision = Get-ReadinessDecision $state.State $state.Health $http
        if ($decision -eq 'ready') { return }
        if ($decision.StartsWith('fatal:')) { throw $decision.Substring(6) }
        if ($decision.StartsWith('suspect:')) {
            if ($null -eq $suspectSince) { $suspectSince = $timer.Elapsed.TotalSeconds }
            Write-Host ($decision.Substring(8) + ' Observing for up to 15 seconds.') -ForegroundColor Yellow
            if ($timer.Elapsed.TotalSeconds - $suspectSince -ge 15) { throw ('Stopped early: ' + $decision.Substring(8)) }
        } else { $suspectSince = $null }
        $delay = [Math]::Min(5-($timer.Elapsed.TotalSeconds-$pollStart),180-$timer.Elapsed.TotalSeconds)
        if ($delay -gt 0) { Start-Sleep -Milliseconds ([int]($delay*1000)) }
    }
    throw 'Open WebUI was not ready within 180 seconds. Review its logs and retry.'
}

function Open-WebUI {
    Write-Host 'Open WebUI is ready. Opening your default browser.' -ForegroundColor Green
    Write-Host $script:Url
    # Windows selects the default HTTP handler; no browser executable is specified.
    try { Start-Process -FilePath $script:Url -ErrorAction Stop }
    catch { Write-Host 'Browser launch failed.' -ForegroundColor Yellow }
    Write-Host 'If no browser appears, copy the URL above into your browser. Some terminals also support Ctrl+click.'
}

function Show-Diagnostics {
    try {
        $result = Invoke-Docker @('compose','-f',$script:Compose,'ps','--all')
        Write-Host $result.Out
        $result = Invoke-Docker @('compose','-f',$script:Compose,'logs','--tail','30','open-webui')
        Write-Host ($result.Out + $result.Err)
    } catch { Write-Host $_.Exception.Message -ForegroundColor Yellow }
}

while ($true) {
    Reset-Screen
    Write-Host "`nLocal AI Service Control - $script:Version" -ForegroundColor Cyan
    Write-Host "File: $env:LOCAL_AI_SCRIPT"
    Write-Host '1  Start Ollama and Open WebUI' -ForegroundColor Green
    Write-Host '2  View service status' -ForegroundColor Cyan
    Write-Host '3  Stop services and retain data' -ForegroundColor Yellow
    Write-Host '0  Exit'
    $action = Read-Host 'Select an option'
    if ($null -eq $action -or $action -eq '0') { break }
    if ($action -notin @('1','2','3')) {
        Write-Host 'Invalid option. Enter 0, 1, 2 or 3.' -ForegroundColor Yellow
        [void](Read-Host 'Press Enter to return to the menu')
        continue
    }
    Reset-Screen
    $diagnostics = $false
    try {
        Test-Environment
        switch ($action) {
            '1' {
                Write-Host 'Starting services. The first image download may take several minutes.' -ForegroundColor Cyan
                & $script:Docker compose -f $script:Compose up -d
                if ($LASTEXITCODE -ne 0) { throw 'Compose startup failed. See the error above: check downloads, disk space and port 3000. No browser was opened.' }
                $diagnostics = $true
                Wait-WebUI
                Open-WebUI
            }
            '2' {
                $result = Invoke-Docker @('compose','-f',$script:Compose,'ps','--all')
                if ($result.Code -ne 0) { throw $result.Err }
                Write-Host $result.Out
                $state = Get-WebState
                $http = 0
                if ($state.State -eq 'running') { $http = Get-HttpStatus }
                Write-Host ('state={0} health={1} HTTP={2:000}' -f $state.State,$state.Health,$http)
                Write-Host $script:Url
            }
            '3' {
                & $script:Docker compose -f $script:Compose stop
                if ($LASTEXITCODE -ne 0) { throw 'Stop failed. Review the Docker error above.' }
                Write-Host 'Services are stopped. Models, accounts and chat data are retained.' -ForegroundColor Green
            }
        }
    } catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        if ($diagnostics) { Show-Diagnostics }
    }
    [void](Read-Host 'Press Enter to return to the menu')
}
