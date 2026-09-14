# 單元 02 Docker Desktop 與 WSL2 安裝

## 1 教學目標

- 學生能在 Windows 11 啟用 WSL2 並安裝 Docker Desktop
- 學生能確認 Docker Desktop 使用 WSL2 backend
- 學生能使用簡單指令確認 Docker Engine 正常運作

## 2 必要觀念

### WSL2 的角色

WSL2 讓 Windows 11 能執行本課程需要的 Linux 容器，Docker Desktop 會透過 WSL2 管理容器所需的 Linux 環境

> 學生不需要學習 Linux 指令，也不需要另外管理 Ubuntu Server

### Docker Desktop 的角色

Docker Desktop 負責執行及管理容器，後續使用的 Ollama 與 Open WebUI 會放在容器中執行，課程會使用 Docker Compose 統一啟動與停止這些服務
```text
Windows 11
└─ WSL2
   └─ Docker Desktop
      └─ 後續課程使用的容器
```

### 安裝前條件

- 已完成 [單元 00 環境檢查](../00-課前硬體與環境檢查/README.md)
- Windows 11 64 位元
- 虛擬化已啟用
- RAM 建議 16 GB 以上
- SSD 至少 50 GB 可用空間
- 安裝過程可連接網路
- 可在需要時取得系統管理員權限

## 3 要點

- 說明 WSL2 如何讓 Windows 執行本課程需要的 Linux 容器
- 說明 Docker Desktop、Docker Engine 與 Linux containers 在本課程中的關係
- 引導學生理解安裝完成、程式已開啟與 Docker Engine 正常執行是不同狀態
- 示範如何利用 `docker version` 與 `docker compose version` 判讀安裝結果
- 說明登入 Windows 後自動啟動的影響，讓學生依使用需求決定是否啟用

## 4 實作

### 步驟一 安裝 WSL2

在開始功能表搜尋 CMD 或 PowerShell，按滑鼠右鍵並選擇以系統管理員身分執行
本課程不需要額外安裝 Ubuntu 發行版，優先執行
```console
wsl --install --no-distribution
```

若系統顯示不支援 `--no-distribution` 可改為
```console
wsl --install
```
> --no-distribution：安裝 WSL2 必要功能，但不額外安裝 Ubuntu 等 Linux 發行版

指令完成後重新啟動 Windows

> Microsoft 官方說明可參考 [安裝 WSL](https://learn.microsoft.com/windows/wsl/install)

### 步驟二 更新並確認 WSL

重新啟動後開啟 CMD 或 PowerShell
```console
wsl --update
wsl --set-default-version 2
wsl --version
```
成功時應能看到 WSL 版本資訊

### 步驟三 安裝 Docker Desktop

1. 開啟 [Docker Desktop for Windows 官方安裝頁](https://docs.docker.com/desktop/setup/install/windows-install/)
2. 下載 Windows x86_64 安裝程式
3. 執行 `Docker Desktop Installer.exe`
4. 保留使用 WSL2 的預設選項
5. 完成安裝後依畫面要求登出或重新啟動
6. 從開始功能表啟動 Docker Desktop

> 本課程使用 Linux containers，學生不需要為本課程切換到 Windows containers

### 步驟四 確認 WSL2 backend 與啟動設定

開啟 Docker Desktop

1. 進入 Settings
2. 選擇 General
3. 確認 Use the WSL 2 based engine 已啟用
4. 確認 Start Docker Desktop when you sign in to your computer 未勾選
5. 選擇 Apply 或 Apply and restart

> 若畫面沒有此選項且 Docker 已正常啟動，通常代表系統已自動使用可用的 WSL2 backend

> Docker Desktop 目前預設不會在安裝後或登入 Windows 時自動啟動，若此選項已被勾選，取消勾選即可避免平時占用電腦資源，後續需要使用時再從開始功能表啟動

> Docker 官方說明可參考 [Docker Desktop WSL2 backend](https://docs.docker.com/desktop/features/wsl/)

> 啟動設定可參考 [Docker Desktop Settings](https://docs.docker.com/desktop/settings-and-maintenance/settings/)

### 步驟五 驗證 Docker Engine

1. 等待 Docker Desktop 顯示 Engine running
2. 開啟 CMD 或 PowerShell 後執行
```console
docker version
```
接著執行
```console
docker compose version
```

兩個指令都能顯示版本資訊即代表基本環境正常

### 步驟六 再次執行環境檢查

1. 開啟 [00-課前硬體與環境檢查](../00-課前硬體與環境檢查/) 單元資料夾
2. 在 `00_check-environment.cmd` 上按兩下
3. 檢查完成後畫面會保留
4. 確認 Firmware virtualization、SLAT support、Virtual Machine Platform、WSL Windows feature、Windows hypervisor、WSL command 與 Docker Engine 顯示 `PASS`

## 5 成功檢查

完成本單元時應符合

- `wsl --version` 能顯示版本資訊
- WSL 預設版本為 2
- Docker Desktop 能正常啟動
- Docker Desktop 使用 Linux containers
- `docker version` 能顯示 Client 與 Server 資訊
- `docker compose version` 能顯示版本資訊
- 環境檢查中的虛擬化、SLAT、Virtual Machine Platform、WSL、Windows hypervisor 與 Docker Engine 顯示 `PASS`

## 6 常見問題與排除

### `wsl --install` 要求重新啟動

這是正常情況，儲存目前工作後重新啟動 Windows 再繼續安裝

### WSL 安裝停在下載階段

先確認網路與 Microsoft Store 存取狀態
再以系統管理員身分開啟 CMD 或 PowerShell 並執行

```console
wsl --update --web-download
```

### 顯示虛擬化相關錯誤

開啟工作管理員並進入效能 CPU，確認虛擬化顯示為已啟用，若未啟用，需由 BIOS 或 UEFI 開啟 Intel Virtualization Technology 或 AMD-V

> **BIOS 或 UEFI**  
> BIOS 或 UEFI 是主機板中的系統韌體，會在 Windows 啟動前先檢查硬體並提供基本設定，新式電腦大多使用 UEFI，但操作畫面仍常被統稱為 BIOS

> **Intel Virtualization Technology 或 AMD-V**  
> 兩者分別是 Intel 與 AMD 處理器提供的硬體虛擬化功能，啟用後可讓 WSL2 與 Docker Desktop 在 Windows 中建立執行 Linux 容器所需的虛擬環境

### Docker Desktop 一直停在 Starting

先重新啟動 Windows，再確認 WSL 是否正常
```console
wsl --status
wsl --version
```
若仍無法啟動，可關閉 WSL 後重新開啟 Docker Desktop
```console
wsl --shutdown
```

### `docker version` 只有 Client 沒有 Server

通常表示 Docker Desktop 尚未完成啟動，等待 Docker Desktop 顯示 Engine running 後再次執行

### 電腦沒有系統管理員權限

WSL 首次啟用可能需要系統管理員權限，應由教師或設備管理人員協助

### 安裝後磁碟空間快速減少

Docker 映像、容器與模型都會使用磁碟空間，此階段不要任意刪除 Docker Desktop 的 WSL 資料檔，後續單元會提供安全的檢查、備份與移除方式

## 7 單元成果

學生完成 WSL2 與 Docker Desktop 安裝，學生儲存下列兩個指令的版本結果
```console
wsl --version
docker compose version
```
學生再次執行環境檢查並確認虛擬化、SLAT、Virtual Machine Platform、WSL、Windows hypervisor 與 Docker Engine 顯示 `PASS`
