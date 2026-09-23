# 補充教材-Docker 在不同作業系統的執行差異

本文件前半供學生理解 Windows、macOS 與 Linux 執行 Linux containers（Linux 容器）時的差異，後半的補強建議供教師規劃跨平台教材時參考

## 為什麼相同的 Docker 教材仍可能出現差異

本課程執行的是 Linux containers

容器會包含應用程式及其相依套件，但不會帶入完整的作業系統核心，因此執行 Linux containers 時仍需要 Linux 核心

Windows、macOS 與 Linux 提供 Linux 核心的方式不同，Docker Desktop、檔案共享、網路轉送及硬體支援也會跟著不同

## 三種作業系統的主要差異

| 主機作業系統 | Linux containers 如何執行 | 常見管理方式 | 主要差異 |
| --- | --- | --- | --- |
| Windows 11 | 透過 WSL2、Hyper-V 或其他 Docker Desktop backend 提供 Linux 環境 | Docker Desktop | 需要虛擬化，檔案與網路會經過 Windows 和 Linux 環境 |
| macOS | Docker Desktop 在輕量 Linux VM 中執行 Docker Engine | Docker Desktop | 需要虛擬化及檔案共享，Apple Silicon 常使用 ARM64 架構 |
| Linux | Docker Engine 可直接使用主機的 Linux 核心 | Docker Engine 或 Docker Desktop | 使用 Docker Engine 時少一層虛擬化，但權限與發行版設定可能不同 |

> Docker Desktop for Linux 本身也會使用 VM，因此不能只看到 Linux 就假設一定沒有虛擬化層

## 本課程採用的方式

本課程固定使用下列環境

```text
Windows 11
└─ WSL2
   └─ Docker Desktop
      └─ Linux containers
         ├─ Ollama
         └─ Open WebUI
```

這樣可以讓全班使用相同的操作畫面、腳本及 `03_compose.yaml`

> 本課程不使用 Windows containers，也不要求學生另外安裝或管理 Ubuntu 發行版

## 常見差異來源

### CPU 架構

Windows Intel 或 AMD 電腦通常使用 `amd64` 或 `x86_64`，Apple Silicon Mac 通常使用 `arm64`

容器映像若沒有提供目前 CPU 架構需要的版本，可能無法啟動，或需要透過模擬執行而降低速度

### 檔案路徑與檔案共享

- Windows 路徑常以 `C:\` 開頭
- macOS 與 Linux 路徑常以 `/` 開頭
- Docker Desktop 需要在主機與 Linux VM 之間共享檔案
- 絕對路徑、空白、中文資料夾名稱及權限設定可能造成不同結果

本課程使用相對路徑與 Docker named volumes，減少主機路徑不同造成的問題

### 檔案權限與換行格式

Linux 會區分檔案是否具有執行權限，Windows 常用 CRLF 換行，Linux 常用 LF 換行

Shell script、設定檔或掛載進容器的檔案若使用不合適的權限或換行格式，可能在另一個作業系統失敗

### 網路與連接埠

Docker Desktop 會將主機的連接埠轉送到 Linux VM 與容器

防火牆、VPN、防毒軟體或其他程式若已占用相同連接埠，可能使同一份 Compose 設定在不同電腦上得到不同結果

### GPU

GPU 的品牌、驅動程式、主機作業系統及 Docker backend 都會影響容器是否能使用 GPU

本課程不強制使用獨立 GPU，沒有可用 GPU 時仍可使用 CPU 執行，但回答速度通常較慢

## 學生遇到差異時先檢查

1. 確認目前使用 Windows 11
2. 確認 Docker Desktop 使用 WSL2 backend
3. 確認目前執行 Linux containers
4. 確認 Docker Desktop 顯示 Engine running
5. 再次執行單元 00 環境檢查
6. 確認教材資料夾與設定檔沒有被移動或改名
7. 保留錯誤畫面及錯誤紀錄，請教師協助確認

## 教師的教材與環境補強建議

### 維持一致的課程基準

- 課程實作固定使用 Windows 11、WSL2 backend 與 Linux containers
- 使用指定的 Docker Desktop、WSL 及顯示卡驅動程式版本範圍
- 教師先在與教室相同的 CPU 架構與權限環境完成驗證

### 降低作業系統相依性

- Compose 檔使用相對路徑，不寫入個人電腦的絕對路徑
- 持久資料使用 Docker named volumes
- 優先選擇同時提供 `amd64` 與 `arm64` 的容器映像
- 腳本分開提供 Windows 與其他作業系統適用的入口
- 設定檔使用跨平台可讀取的 UTF-8 及適當換行格式

### 分開驗證不同平台

若未來要支援 macOS 或 Linux，應為每個平台分別驗證

- 安裝方式
- CPU 架構與容器映像
- 檔案共享與權限
- 網路與連接埠
- GPU 支援
- 啟動、停止、備份及還原流程

不同平台驗證完成前，不應直接宣稱 Windows 教材可以原樣套用

## 官方參考資料

- [Docker Desktop WSL2 backend](https://docs.docker.com/desktop/features/wsl/)
- [Docker Desktop 虛擬機管理方式](https://docs.docker.com/desktop/features/vmm/)
- [Docker Desktop 網路運作方式](https://docs.docker.com/desktop/features/networking/)
- [Docker Desktop for Linux](https://docs.docker.com/desktop/setup/install/linux/)
- [Docker Desktop for Mac 常見問題](https://docs.docker.com/desktop/troubleshoot-and-support/faqs/macfaqs/)
- [Docker Desktop GPU 支援](https://docs.docker.com/desktop/features/gpu/)

回到 [單元 02 說明文件](README.md)
