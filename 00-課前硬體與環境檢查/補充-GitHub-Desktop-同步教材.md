# 補充教材：GitHub Desktop 同步教材

## 適用情況

第一次取得教材時，可以從 GitHub 下載 ZIP 壓縮檔

若課程期間還會持續更新教材，可改用 GitHub Desktop 保留一份教材資料夾，之後直接取得更新，不必每次重新下載及解壓縮

| 方式 | 第一次取得教材 | 後續更新 | 適合情況 |
| --- | --- | --- | --- |
| Download ZIP | 下載並解壓縮 | 每次重新下載 | 只需要取得一次教材 |
| GitHub Desktop | Clone 一次 | 使用 Fetch 與 Pull 更新 | 課程期間會持續取得新版教材 |

> GitHub Desktop 同步的是教材檔案，不會自動啟動 Docker Desktop、Ollama 或 Open WebUI

## 第一次取得教材

### 步驟一 安裝 GitHub Desktop

1. 開啟 [GitHub Desktop 官方網站](https://desktop.github.com/)
2. 下載並安裝 Windows 版本
3. 開啟 GitHub Desktop

公開教材可以使用儲存庫網址取得

### 步驟二 Clone 教材

1. 在 GitHub Desktop 選擇 "File" > "Clone repository"
2. 選擇 "URL"
3. 輸入教材網址

```text
https://github.com/lee0401g/project-delivery_3LM
```

4. 在 "Local path" 選擇教材要存放的位置
5. 選擇 "Clone"
6. 等待教材下載完成

Clone 完成後，GitHub Desktop 會保留本機教材與 GitHub 儲存庫的連結

> 請選擇新的存放位置，不要將 Clone 位置設在先前解壓縮的教材資料夾裡

### 步驟三 找到教材資料夾

1. 在 GitHub Desktop 選擇 "Repository" > "Show in Explorer"
2. 確認檔案總管已開啟 `project-delivery_3LM` 資料夾
3. 從根目錄的 `README.md` 開始閱讀

## 後續取得教材更新

1. 關閉正在執行的教材控制視窗
2. 開啟 GitHub Desktop
3. 在左上角選擇 `project-delivery_3LM`
4. 選擇 "Fetch origin"
5. 若畫面出現 "Pull origin"，再選擇 "Pull origin"
6. 等待更新完成
7. 重新開啟教材資料夾並閱讀最新說明

"Fetch origin" 會先檢查 GitHub 是否有新版本，"Pull origin" 才會將新版本更新到目前的教材資料夾

> 如果只有 "Fetch origin" 而沒有出現 "Pull origin"，通常代表目前沒有可下載的新版本

## 哪些資料不會因教材更新而消失

- 本課程的帳號、對話、模型及知識庫主要儲存在 Docker 資料卷（volume），不在 GitHub 教材儲存庫中
- 一般教材更新不會刪除這些資料，但新版教材可能調整操作方式、設定檔或腳本，更新後應先閱讀各單元最新說明

## GitHub Desktop 顯示本機變更

GitHub Desktop 左側的 "Changes" 若出現檔案，代表本機教材與 GitHub 上的版本不同

- 若只是閱讀教材，通常不需要修改 README、腳本或設定檔
- 不確定變更來源時，不要直接丟棄、覆蓋或提交
- 先保留畫面並請教師協助確認，再決定是否更新
- 個人練習文件應另存至教材資料夾之外，避免與教材更新混在一起

## 常見問題

### Pull 前出現本機變更

先停止更新，不要自行選擇 Discard changes 或 Commit，請教師協助確認哪些內容需要保留

### 找不到下載後的資料夾

在 GitHub Desktop 選擇 "Repository" > "Show in Explorer"

### 更新後仍看到舊內容

確認目前選擇的儲存庫是 `project-delivery_3LM`，並確認已完成 "Fetch origin" 及 "Pull origin"

### 可以刪除以前下載的 ZIP 嗎

確認 GitHub Desktop 取得的教材可以正常開啟後，先前的 ZIP 與解壓縮副本可依需要保留或移除，避免之後開錯資料夾

## 官方參考資料

- [GitHub Desktop：Clone 儲存庫](https://docs.github.com/en/desktop/adding-and-cloning-repositories/cloning-and-forking-repositories-from-github-desktop)
- [GitHub：取得遠端儲存庫更新](https://docs.github.com/en/get-started/using-git/getting-changes-from-a-remote-repository)
- [GitHub Desktop：使用遠端儲存庫](https://docs.github.com/en/desktop/working-with-your-remote-repository-on-github-or-github-enterprise)
