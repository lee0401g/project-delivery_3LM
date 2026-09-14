@echo off
chcp 65001 >nul
setlocal
title Local AI Service Control
set "SCRIPT_DIR=%~dp0"
set "COMPOSE_FILE=%SCRIPT_DIR%03_compose.yaml"
for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"

:menu
cls
echo %ESC%[96m========================================%ESC%[0m
echo %ESC%[96mLocal AI Service Control%ESC%[0m
echo %ESC%[96m========================================%ESC%[0m
echo %ESC%[92m1  Start Ollama and Open WebUI%ESC%[0m
echo %ESC%[96m2  View service status%ESC%[0m
echo %ESC%[93m3  Stop Ollama and Open WebUI%ESC%[0m
echo %ESC%[90m0  Exit%ESC%[0m
echo %ESC%[96m========================================%ESC%[0m
set "ACTION="
set /p "ACTION=Select an option: "
if "%ACTION%"=="1" goto start_services
if "%ACTION%"=="2" goto show_status
if "%ACTION%"=="3" goto stop_services
if "%ACTION%"=="0" goto end
echo.
echo %ESC%[91mInvalid option%ESC%[0m
call :wait
goto menu

:start_services
cls
call :require_docker
if errorlevel 1 goto action_failed
pushd "%SCRIPT_DIR%"
echo %ESC%[96mStarting Ollama and Open WebUI%ESC%[0m
echo %ESC%[93mThe first start downloads container images and may take several minutes%ESC%[0m
echo.
docker compose -f "%COMPOSE_FILE%" up -d
if errorlevel 1 (
    popd
    echo.
    echo %ESC%[91mStartup failed%ESC%[0m
    goto action_failed
)
echo.
docker compose -f "%COMPOSE_FILE%" ps
popd
echo.
echo %ESC%[92mServices started successfully%ESC%[0m
echo %ESC%[96mOpen WebUI address http://localhost:3000%ESC%[0m
start "" http://localhost:3000
call :wait
goto menu

:show_status
cls
call :require_docker
if errorlevel 1 goto action_failed
pushd "%SCRIPT_DIR%"
echo %ESC%[96mLocal AI service status%ESC%[0m
echo.
docker compose -f "%COMPOSE_FILE%" ps
set "WEBUI_CONTAINER="
set "WEBUI_STATE="
for /f "delims=" %%I in ('docker compose -f "%COMPOSE_FILE%" ps -q open-webui') do set "WEBUI_CONTAINER=%%I"
if defined WEBUI_CONTAINER for /f "delims=" %%S in ('docker inspect --format "{{.State.Status}}" "%WEBUI_CONTAINER%" 2^>nul') do set "WEBUI_STATE=%%S"
if /i "%WEBUI_STATE%"=="restarting" (
    echo.
    echo %ESC%[91mOpen WebUI is restarting repeatedly%ESC%[0m
    echo %ESC%[93mRecent Open WebUI logs%ESC%[0m
    echo.
    docker compose -f "%COMPOSE_FILE%" logs --tail 30 open-webui
)
popd
call :wait
goto menu

:stop_services
cls
call :require_docker
if errorlevel 1 goto action_failed
pushd "%SCRIPT_DIR%"
echo %ESC%[93mStopping Ollama and Open WebUI%ESC%[0m
echo.
docker compose -f "%COMPOSE_FILE%" stop
if errorlevel 1 (
    popd
    echo.
    echo %ESC%[91mStop failed%ESC%[0m
    goto action_failed
)
popd
echo.
echo %ESC%[92mServices stopped and data retained%ESC%[0m
call :wait
goto menu

:action_failed
call :wait
goto menu

:require_docker
docker compose version >nul 2>&1
if errorlevel 1 (
    echo %ESC%[91mDocker Compose is unavailable%ESC%[0m
    echo %ESC%[93mConfirm Docker Desktop is installed%ESC%[0m
    exit /b 1
)
docker info >nul 2>&1
if errorlevel 1 (
    echo %ESC%[91mDocker Engine is not running%ESC%[0m
    echo %ESC%[93mStart Docker Desktop and wait for Engine running%ESC%[0m
    exit /b 1
)
exit /b 0

:wait
echo.
echo Press any key to return to the menu
pause >nul
exit /b 0

:end
endlocal
exit /b 0
