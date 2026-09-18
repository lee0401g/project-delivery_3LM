# 單元 00 課前硬體與環境檢查

## 1 教學目標

- 學生能確認自己的電腦是否適合執行地端對話模型

> 腳本預設只會讀取系統資訊，只有使用者選擇修復並同意系統管理員權限後才會修改 WSL2 必要設定

## 2 必要觀念

本課程的建議硬體基準如下

| 項目 | 建議基準 |
| --- | --- |
| Windows | Windows 11 64 位元 |
| CPU | 4 核心 8 執行緒以上 |
| RAM | 16 GB 以上 |
| 磁碟 | SSD 且至少 50 GB 可用空間 |
| GPU | 不強制 |
| 虛擬化 | 必須支援並啟用 |
| WSL2 | 可安裝或已安裝 |

> 8 GB RAM 僅適合測試，不列為正式支援規格

## 3 要點

- 硬體條件與軟體準備狀態應分開判讀，尚未安裝不等於硬體不合格
- 完成後續環境設定後，再次執行檢查並比較狀態變化

## 4 實作

一般使用方式

1. 在 `00_check-environment.cmd` 上按兩下
2. 等待環境檢查完成
3. 檢視 `PASS`、`WARN`、`INFO` 與 `UNKNOWN`

   - `PASS`：目前條件已符合，可依流程繼續
   - `INFO`：尚未完成後續安裝或設定，不代表電腦不符合，可先完成單元 02
   - `WARN`：需要重新檢查或請教師協助確認，未確認前不要自行判定可繼續
   - `UNKNOWN`：腳本無法確認狀態，請保留畫面並請教師協助

4. 沒有顯示修復選項時按任意鍵關閉視窗

若按兩下無法執行

1. 確認檔案總管目前位於 `00-課前硬體與環境檢查` 資料夾
2. 在資料夾空白處按滑鼠右鍵
3. 選擇「在終端機中開啟」
4. 在開啟的 CMD 或 PowerShell 輸入下列指令並按 Enter

```console
.\00_check-environment.cmd
```

> 腳本檢查不會修改系統設定

若 Virtual Machine Platform、WSL Windows 功能或 Windows hypervisor 尚未就緒，畫面會提供兩個選項

- 按 `R`：要求一次系統管理員權限，啟用 WSL2 必要設定並安裝 WSL
- 按 `X`：關閉腳本且不修改設定

修復功能會啟用 Virtual Machine Platform、Windows Subsystem for Linux 與 Windows hypervisor 開機啟動設定，並以 `--no-distribution` 安裝 WSL，不會安裝 Ubuntu 或其他 Linux 發行版，過程可能需要網路，完成後由使用者自行儲存工作並重新啟動 Windows

腳本將檢查

- Windows 版本與系統架構
- CPU 核心與執行緒
- 實體記憶體
- 系統磁碟可用空間
- BIOS 或 UEFI 虛擬化狀態
- SLAT 支援狀態
- Virtual Machine Platform 狀態
- WSL Windows 功能與指令狀態
- Windows hypervisor 執行狀態
- Docker 狀態
- NVIDIA GPU 狀態

### 後續更新教材

若課程期間需要持續取得教材更新，詳細步驟請參閱 [補充教材：GitHub Desktop 同步教材](補充-GitHub-Desktop-同步教材.md)，不必每次重新下載及解壓縮 ZIP

## 5 成功檢查

理想符合下列條件即可繼續後續單元

- Windows 11 64 位元
- CPU 至少 4 核心 8 執行緒
- RAM 至少 16 GB
- 系統磁碟至少 50 GB 可用空間
- 虛擬化已啟用
- SLAT 顯示 `PASS`

完成單元 00 後，單元 02 的安裝前條件是：硬體條件符合，虛擬化已啟用；Virtual Machine Platform、WSL 與 Docker 尚未完成時顯示 `INFO` 可以接受，這些項目會在單元 02 處理

> Virtual Machine Platform、WSL、Windows hypervisor 與 Docker 尚未準備完成時會顯示 `INFO`

## 6 常見問題與排除

### 顯示 RAM 不足

8 GB RAM 電腦不建議同時執行 Docker 與本機模型

> 應改用較高記憶體的電腦或共用方案

### 顯示磁碟空間不足

先清理不需要的檔案

> 不要刪除不清楚用途的 Windows 系統檔案
> 若仍不足，應改用較高記憶體的電腦或共用方案

### 顯示虛擬化未啟用

需進入 BIOS 或 UEFI 開啟 Intel VT-x Intel Virtualization Technology 或 AMD-V

> 不同品牌操作方式不同

### Virtual Machine Platform 或 WSL Windows 功能顯示 `INFO`

按 `R` 可自動啟用必要設定，若暫不處理可以按 `X` 關閉腳本；完成單元 02 的安裝與設定後，應重新檢查並顯示 `PASS`

### Windows hypervisor 顯示 `WARN`

代表 Virtual Machine Platform 已啟用，但 Windows hypervisor 沒有正常執行，暫時不要進入後續安裝；先重新啟動 Windows，若仍顯示 `WARN`，請保留畫面並請教師協助

### WSL 尚未安裝

腳本會顯示修復選項，按 `R` 可要求系統管理員權限並自動執行 WSL 安裝，也可以按 `X` 暫不處理

### Docker 尚未安裝

Docker Desktop 尚未安裝時屬於正常情況

### 找不到 NVIDIA GPU

本課程不強制使用獨立 GPU 亦可繼續進行

## 7 單元成果

學生展示檢查畫面或自行記錄需要處理的項目

## 單元導引

- [返回課程首頁](../README.md)
- 下一單元：[單元 01 地端 AI 與本機模型基本觀念](../01-地端-AI-與本機模型基本觀念/README.md)
