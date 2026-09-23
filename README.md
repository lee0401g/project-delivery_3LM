# 地端 RAG 學生實作教材

## 課程目標

- 在 Windows 11 建立本機 AI 對話環境
- 使用 Ollama 與 Open WebUI 操作本機模型
- 建立個人文件知識庫
- 根據文件進行問答並查核引用
- 能啟動、停止、備份、還原及移除環境

## 硬體基準

| 項目 | 建議基準 |
| --- | --- |
| 作業系統 | Windows 11 64 位元 |
| CPU | 4 核心 8 執行緒以上 |
| RAM | 16 GB |
| 儲存空間 | SSD 至少 50 GB 可用空間 |
| GPU | 不強制 |
| 系統功能 | 支援並啟用虛擬化與 WSL2 |
| 網路 | 安裝與下載時需要網路，完成後可離線 |

## 固定架構

```text
Windows 11
└─ Docker Desktop + WSL2
   └─ Docker Compose
      ├─ Ollama
      └─ Open WebUI
         └─ 內建 RAG
```

## 教材單元

| 編號 | 單元 | 編寫進度 | 建立／最近編修日期 |
| --- | --- | --- | --- |
| 00 | 課前硬體與環境檢查 | 編修中 | 2026-09-09／2026-09-21 |
| 01 | 地端 AI 與本機模型基本觀念 | 編修中 | 2026-09-09／2026-09-17 |
| 02 | Docker Desktop 與 WSL2 安裝 | 編修中 | 2026-09-09／2026-09-18 |
| 補充教材 | Docker 在不同作業系統的執行差異 | 編修中 | 2026-09-18／2026-09-18 |
| 補充教材 | Docker Desktop 啟動錯誤排查 | 編修中 | 2026-09-17／2026-09-18 |
| 03 | 啟動 Ollama 與 Open WebUI | 編修中 | 2026-09-09／2026-09-18 |
| 補充教材 | 啟動問題排查 | 編修中 | 2026-09-17／2026-09-18 |
| 04 | 本機模型對話實作 | 編修中 | 2026-09-10／2026-09-21 |
| 補充教材 | 模型選擇與比較 | 編修中 | 2026-09-10／2026-09-21 |
| 補充教材 | 模型基本能力與測試 | 編修中 | 2026-09-21／2026-09-21 |
| 補充教材 | 模型授權與使用條款 | 編修中 | 2026-09-10／2026-09-21 |
| 05 | 建立個人知識庫 | 編修中 | 2026-09-10／2026-09-21 |
| 補充教材 | 本次實作架構演進 | 編修中 | 2026-09-11／2026-09-21 |
| 補充教材 | Knowledge、RAG 與文件使用模式 | 編修中 | 2026-09-18／2026-09-21 |
| 06 | 文件問答與引用查核 | 待實作驗證 | 2026-09-11／2026-09-21 |
| 補充教材 | RAG 測試與評分 | 編修中 | 2026-09-21／2026-09-21 |
| 07 | 資料更新與知識庫維護 | 待實作驗證 | 2026-09-14／2026-09-21 |
| 08 | 備份、還原、停止與移除 | 待實作驗證 | 2026-09-14／2026-09-21 |
| 09 | 個人 RAG 成果驗收 | 待實作驗證 | 2026-09-14／2026-09-21 |

## 下載與更新教材

### 使用 Download ZIP 取得教材

1. 開啟 [教材 GitHub 儲存庫](https://github.com/lee0401g/project-delivery_3LM)
2. 在檔案清單上方選擇 Code
3. 選擇 Download ZIP，下載整份教材
4. 在下載完成的 ZIP 檔案上按滑鼠右鍵，選擇「全部解壓縮」
5. 選擇儲存位置並完成解壓縮
6. 開啟解壓縮後的資料夾，找到 `00-課前硬體與環境檢查` 等教材單元資料夾

> 請先完成解壓縮，再執行單元中的 CMD，不要直接在 ZIP 壓縮檔內執行

Download ZIP 適合只需要取得一次教材的學生。若課程期間還會持續取得新版教材，可改用 GitHub Desktop，保留同一份教材資料夾並直接更新，不必每次重新下載及解壓縮。

| 方式 | 第一次取得教材 | 後續更新 | 適合情況 |
| --- | --- | --- | --- |
| Download ZIP | 下載並解壓縮 | 每次重新下載 | 只需要取得一次教材 |
| GitHub Desktop | Clone 一次 | 使用 Fetch 與 Pull 更新 | 課程期間會持續取得新版教材 |

> GitHub Desktop 同步的是教材檔案，不會自動啟動 Docker Desktop、Ollama 或 Open WebUI

### 使用 GitHub Desktop 取得教材

#### 步驟一 安裝 GitHub Desktop

1. 開啟 [GitHub Desktop 官方網站](https://desktop.github.com/)
2. 下載並安裝 Windows 版本
3. 開啟 GitHub Desktop

公開教材可以使用儲存庫網址取得。

#### 步驟二 Clone 教材

1. 在 GitHub Desktop 選擇 "File" > "Clone repository"
2. 選擇 "URL"
3. 輸入教材網址

```text
https://github.com/lee0401g/project-delivery_3LM
```

4. 在 "Local path" 選擇教材要存放的位置
5. 選擇 "Clone"
6. 等待教材下載完成

Clone 完成後，GitHub Desktop 會保留本機教材與 GitHub 儲存庫的連結。

> 請選擇新的存放位置，不要將 Clone 位置設在先前解壓縮的教材資料夾裡

#### 步驟三 找到教材資料夾

1. 在 GitHub Desktop 選擇 "Repository" > "Show in Explorer"
2. 確認檔案總管已開啟 `project-delivery_3LM` 資料夾
3. 從根目錄的 `README.md` 開始閱讀

### 使用 GitHub Desktop 取得更新

1. 關閉正在執行的教材控制視窗
2. 開啟 GitHub Desktop
3. 在左上角選擇 `project-delivery_3LM`
4. 選擇 "Fetch origin"
5. 若畫面出現 "Pull origin"，再選擇 "Pull origin"
6. 等待更新完成
7. 重新開啟教材資料夾並閱讀最新說明

"Fetch origin" 會先檢查 GitHub 是否有新版本，"Pull origin" 才會將新版本更新到目前的教材資料夾。

> 如果只有 "Fetch origin" 而沒有出現 "Pull origin"，通常代表目前沒有可下載的新版本

### 教材更新與本機資料

- 本課程的帳號、對話、模型及知識庫主要儲存在 Docker volume，不在 GitHub 教材儲存庫中
- 一般教材更新不會刪除這些資料，但新版教材可能調整操作方式、設定檔或腳本，更新後應先閱讀各單元最新說明
- 個人練習文件應另存至教材資料夾之外，避免與教材更新混在一起

### GitHub Desktop 顯示本機變更

GitHub Desktop 左側的 "Changes" 若出現檔案，代表本機教材與 GitHub 上的版本不同。

- 若只是閱讀教材，通常不需要修改 README、腳本或設定檔
- 不確定變更來源時，不要直接丟棄、覆蓋或提交
- 先保留畫面並請教師協助確認，再決定是否更新

若 Pull 前出現本機變更，先停止更新，不要自行選擇 "Discard changes" 或 "Commit"，請教師協助確認哪些內容需要保留。

### GitHub Desktop 常見問題

#### 找不到下載後的資料夾

在 GitHub Desktop 選擇 "Repository" > "Show in Explorer"。

#### 更新後仍看到舊內容

確認目前選擇的儲存庫是 `project-delivery_3LM`，並確認已完成 "Fetch origin" 及 "Pull origin"。

#### 可以刪除以前下載的 ZIP 嗎

確認 GitHub Desktop 取得的教材可以正常開啟後，先前的 ZIP 與解壓縮副本可依需要保留或移除，避免之後開錯資料夾。

GitHub Desktop 操作可參考：

- [GitHub Desktop：Clone 儲存庫](https://docs.github.com/en/desktop/adding-and-cloning-repositories/cloning-and-forking-repositories-from-github-desktop)
- [GitHub：取得遠端儲存庫更新](https://docs.github.com/en/get-started/using-git/getting-changes-from-a-remote-repository)
- [GitHub Desktop：使用遠端儲存庫](https://docs.github.com/en/desktop/working-with-your-remote-repository-on-github-or-github-enterprise)

## 第一個操作

1. 進入 [00-課前硬體與環境檢查](00-課前硬體與環境檢查/) 資料夾
2. 在 `00_check-environment.cmd` 上按兩下
3. 檢視結果
4. 按任意鍵關閉

## 實作單元的基本格式

1. 教學目標
2. 必要觀念
3. 要點
4. 實作
5. 成功檢查
6. 常見問題與排除
7. 單元成果
