# 單元 00 課前硬體與環境檢查

## 1 教學目標

- 學生能確認自己的電腦是否適合執行地端對話模型

> 本單元尚不會安裝軟體或修改系統設定

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

- 說明 `PASS`、`WARN`、`INFO` 與 `UNKNOWN` 各自代表的意義
- 引導學生分辨硬體條件與軟體準備狀態，避免將尚未安裝誤認為硬體不合格
- 說明如何依檢查結果判斷可直接繼續、需要處理或需要進一步確認
- 示範後續完成環境設定時，如何重新執行檢查並比較狀態變化

## 4 實作

一般使用方式

1. 在 `00_check-environment.cmd` 上按兩下
2. 等待環境檢查完成
3. 檢視 `PASS`、`WARN`、`INFO` 與 `UNKNOWN`
4. 按任意鍵關閉視窗

若按兩下無法執行

1. 確認檔案總管目前位於 `00-課前硬體與環境檢查` 資料夾
2. 在資料夾空白處按滑鼠右鍵
3. 選擇「在終端機中開啟」
4. 在開啟的 CMD 或 PowerShell 輸入下列指令並按 Enter

```console
.\00_check-environment.cmd
```

腳本只會顯示檢查結果，不會建立或修改檔案

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

## 5 成功檢查

理想符合下列條件即可繼續後續單元

- Windows 11 64 位元
- CPU 至少 4 核心 8 執行緒
- RAM 至少 16 GB
- 系統磁碟至少 50 GB 可用空間
- 虛擬化已啟用
- SLAT 顯示 `PASS`

> Virtual Machine Platform、WSL、Windows hypervisor 與 Docker 在單元 02 前顯示 `INFO` 無妨
> 後續單元會教學

## 6 常見問題與排除

### 顯示 RAM 不足

8 GB RAM 電腦不建議使用 Docker 地端 RAG

> 應改用較高記憶體的電腦或共用方案

### 顯示磁碟空間不足

先清理不需要的檔案

> 不要刪除不清楚用途的 Windows 系統檔案
> 若仍不足，應改用較高記憶體的電腦或共用方案

### 顯示虛擬化未啟用

需進入 BIOS 或 UEFI 開啟 Intel VT-x Intel Virtualization Technology 或 AMD-V

> 不同品牌操作方式不同

### Virtual Machine Platform 或 WSL Windows 功能顯示 `INFO`

尚未進行單元 02 時屬於正常情況，完成安裝後應顯示 `PASS`

### Windows hypervisor 顯示 `WARN`

代表 Virtual Machine Platform 已啟用，但 Windows hypervisor 沒有正常執行，先重新啟動 Windows，若仍顯示 `WARN`，依單元 02 的虛擬化錯誤說明進行檢查

### WSL 尚未安裝

此階段只記錄狀態，單元 02 再進行安裝

### Docker 尚未安裝

此階段只記錄狀態，單元 02 再進行安裝

### 找不到 NVIDIA GPU

本課程不強制使用獨立 GPU 亦可繼續進行

## 7 單元成果

學生展示檢查畫面或自行記錄需要處理的項目
