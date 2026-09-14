@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Local AI Data Management
set "SCRIPT_DIR=%~dp0"
set "COMPOSE_FILE=%SCRIPT_DIR%..\03-啟動-Ollama-與-Open-WebUI\03_compose.yaml"
set "BACKUP_ROOT=%USERPROFILE%\Documents\Local-AI-Backups"
for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"

:menu
cls
echo %ESC%[96m========================================%ESC%[0m
echo %ESC%[96mLocal AI Data Management%ESC%[0m
echo %ESC%[96m========================================%ESC%[0m
echo %ESC%[92m1  Back up Open WebUI data%ESC%[0m
echo %ESC%[96m2  Restore the newest backup%ESC%[0m
echo %ESC%[91m3  Remove the local AI environment%ESC%[0m
echo %ESC%[90m0  Exit%ESC%[0m
echo %ESC%[96m========================================%ESC%[0m
set "ACTION="
set /p "ACTION=Select an option: "
if "!ACTION!"=="1" goto backup_data
if "!ACTION!"=="2" goto restore_data
if "!ACTION!"=="3" goto remove_environment
if "!ACTION!"=="0" goto end
echo.
echo %ESC%[91mInvalid option%ESC%[0m
call :wait
goto menu

:backup_data
cls
call :require_environment
if errorlevel 1 goto action_failed
set "WEBUI_CONTAINER="
for /f "delims=" %%I in ('docker compose -f "!COMPOSE_FILE!" ps -aq open-webui') do if not defined WEBUI_CONTAINER set "WEBUI_CONTAINER=%%I"
if not defined WEBUI_CONTAINER (
    echo %ESC%[91mOpen WebUI container was not found%ESC%[0m
    echo %ESC%[93mStart the services from Unit 03 before creating a backup%ESC%[0m
    goto action_failed
)
for /f "delims=" %%T in ('powershell.exe -NoLogo -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set "STAMP=%%T"
set "BACKUP_DIR=!BACKUP_ROOT!\OpenWebUI-!STAMP!"
echo %ESC%[96mStopping services before backup%ESC%[0m
docker compose -f "!COMPOSE_FILE!" stop
if errorlevel 1 goto action_failed
mkdir "!BACKUP_DIR!\open-webui-data" >nul 2>&1
if not exist "!BACKUP_DIR!\open-webui-data" (
    echo %ESC%[91mThe backup folder could not be created%ESC%[0m
    goto action_failed
)
echo.
echo %ESC%[96mCopying Open WebUI data%ESC%[0m
docker cp "!WEBUI_CONTAINER!:/app/backend/data/." "!BACKUP_DIR!\open-webui-data"
if errorlevel 1 goto backup_incomplete
if not exist "!BACKUP_DIR!\open-webui-data\webui.db" goto backup_incomplete
copy /y "!COMPOSE_FILE!" "!BACKUP_DIR!\03_compose.yaml" >nul
> "!BACKUP_DIR!\BACKUP_INFO.txt" (
    echo Backup type: Open WebUI application data
    echo Created: !STAMP!
    echo Models: Not included
    echo Services after backup: Stopped
)
echo.
echo %ESC%[92mBackup completed successfully%ESC%[0m
echo %ESC%[96mBackup folder: !BACKUP_DIR!%ESC%[0m
echo %ESC%[93mServices are stopped and can be started from Unit 03%ESC%[0m
call :wait
goto menu

:backup_incomplete
> "!BACKUP_DIR!\INCOMPLETE.txt" echo This backup did not complete successfully
echo.
echo %ESC%[91mBackup did not complete successfully%ESC%[0m
echo %ESC%[93mDo not use this folder for restoration: !BACKUP_DIR!%ESC%[0m
goto action_failed

:restore_data
cls
call :require_environment
if errorlevel 1 goto action_failed
if not exist "!BACKUP_ROOT!" (
    echo %ESC%[91mNo backup folder was found%ESC%[0m
    goto action_failed
)
set "LATEST_BACKUP="
for /f "delims=" %%D in ('dir /b /ad /o-d "!BACKUP_ROOT!\OpenWebUI-*" 2^>nul') do (
    if not defined LATEST_BACKUP (
        if not exist "!BACKUP_ROOT!\%%D\INCOMPLETE.txt" if exist "!BACKUP_ROOT!\%%D\open-webui-data\webui.db" set "LATEST_BACKUP=!BACKUP_ROOT!\%%D"
    )
)
if not defined LATEST_BACKUP (
    echo %ESC%[91mNo complete Open WebUI backup was found%ESC%[0m
    goto action_failed
)
echo %ESC%[93mRestoration replaces the current Open WebUI data%ESC%[0m
echo %ESC%[96mNewest backup: !LATEST_BACKUP!%ESC%[0m
echo R = Restore this backup
echo X = Cancel
choice /c RX /n /m "Press R to restore or X to cancel: "
if errorlevel 2 goto menu
echo.
echo %ESC%[93mStopping and removing the current Open WebUI container%ESC%[0m
docker compose -f "!COMPOSE_FILE!" down
if errorlevel 1 goto action_failed
docker volume inspect local-ai_open-webui-data >nul 2>&1
if not errorlevel 1 (
    docker volume rm local-ai_open-webui-data >nul
    if errorlevel 1 (
        echo %ESC%[91mThe current Open WebUI data volume could not be removed%ESC%[0m
        goto action_failed
    )
)
echo %ESC%[96mCreating a clean Open WebUI data volume%ESC%[0m
docker compose -f "!COMPOSE_FILE!" create open-webui
if errorlevel 1 goto action_failed
set "WEBUI_CONTAINER="
for /f "delims=" %%I in ('docker compose -f "!COMPOSE_FILE!" ps -aq open-webui') do if not defined WEBUI_CONTAINER set "WEBUI_CONTAINER=%%I"
if not defined WEBUI_CONTAINER (
    echo %ESC%[91mOpen WebUI container could not be created%ESC%[0m
    goto action_failed
)
echo %ESC%[96mCopying backup data into Open WebUI%ESC%[0m
docker cp "!LATEST_BACKUP!\open-webui-data\." "!WEBUI_CONTAINER!:/app/backend/data"
if errorlevel 1 goto action_failed
docker compose -f "!COMPOSE_FILE!" up -d
if errorlevel 1 goto action_failed
echo.
echo %ESC%[92mRestoration completed successfully%ESC%[0m
echo %ESC%[96mOpen WebUI address http://localhost:3000%ESC%[0m
echo %ESC%[93mModels are not included in the backup and may need to be downloaded again%ESC%[0m
start "" http://localhost:3000
call :wait
goto menu

:remove_environment
cls
call :require_environment
if errorlevel 1 goto action_failed
echo %ESC%[91mThis action permanently removes accounts, chats, files, indexes, and downloaded models%ESC%[0m
echo %ESC%[93mBackups and course files will be retained%ESC%[0m
echo Type DELETE to continue or press Enter to cancel
set "CONFIRM="
set /p "CONFIRM=Confirmation: "
if /i not "!CONFIRM!"=="DELETE" goto menu
echo.
docker compose -f "!COMPOSE_FILE!" down --volumes --remove-orphans
if errorlevel 1 goto action_failed
echo.
echo Remove the two downloaded container images as well
choice /c YN /n /m "Press Y to remove images or N to keep them: "
if errorlevel 2 goto removal_complete
docker image rm ollama/ollama:0.33.3 ghcr.io/open-webui/open-webui:v0.11.3
echo.
echo %ESC%[93mAn image used by another container may be retained%ESC%[0m

:removal_complete
echo.
echo %ESC%[92mThe local AI environment was removed%ESC%[0m
echo %ESC%[96mDocker Desktop, course files, and backups were retained%ESC%[0m
call :wait
goto menu

:require_environment
if not exist "!COMPOSE_FILE!" (
    echo %ESC%[91m03_compose.yaml was not found%ESC%[0m
    echo %ESC%[93mKeep Units 03 and 08 in the same course folder%ESC%[0m
    exit /b 1
)
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

:action_failed
call :wait
goto menu

:wait
echo.
echo Press any key to return to the menu
pause >nul
exit /b 0

:end
endlocal
exit /b 0
