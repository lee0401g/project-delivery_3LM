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

## 3 教師示範

1. 開啟檔案總管並進入教材資料夾
2. 進入 `00-課前硬體與環境檢查` 資料夾
3. 在 [00_check-environment.cmd](00_check-environment.cmd) 上按兩下
4. 說明畫面中的 `PASS`、`WARN`、`INFO` 與 `UNKNOWN`
5. 示範如何重新執行檢查

## 4 學生實作

一般使用方式

1. 在 [00_check-environment.cmd](00_check-environment.cmd) 上按兩下
2. 等待環境檢查完成
3. 檢視 `PASS`、`WARN`、`INFO` 與 `UNKNOWN`
4. 按任意鍵關閉視窗

若無法直接雙擊 可開啟 CMD / PowerShell 後執行

```console
.\00_check-environment.cmd
```

腳本只會顯示檢查結果，不會建立或修改檔案

腳本將檢查

- Windows 版本與系統架構
- CPU 核心與執行緒
- 實體記憶體
- 系統磁碟可用空間
- 虛擬化狀態
- WSL 狀態
- Docker 狀態
- NVIDIA GPU 狀態

## 5 成功檢查

理想符合下列條件即可繼續後續單元

- Windows 11 64 位元
- CPU 至少 4 核心 8 執行緒
- RAM 至少 16 GB
- 系統磁碟至少 50 GB 可用空間
- 虛擬化已啟用

> WSL2 與 Docker 尚未安裝、GPU 不存在無妨
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

### WSL 尚未安裝

此階段只記錄狀態，單元 02 再進行安裝

### Docker 尚未安裝

此階段只記錄狀態，單元 02 再進行安裝

### 找不到 NVIDIA GPU

本課程不強制使用獨立 GPU 亦可繼續進行

## 7 單元成果

學生展示檢查畫面或自行記錄需要處理的項目
