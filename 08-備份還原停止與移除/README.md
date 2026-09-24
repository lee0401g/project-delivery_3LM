# 單元 08 備份、還原、停止與移除

## 1 教學目標

- 學生能分辨停止服務、備份資料與移除環境的差異
- 學生能建立 Open WebUI 資料備份
- 學生能從備份還原帳號、對話、文件與知識庫
- 學生能確認備份檔案位於 Docker 環境之外
- 學生能在成果驗收後安全移除課程環境

## 2 必要觀念

### 停止、移除與刪除資料是不同操作

| 操作 | 容器 | 帳號、對話與知識庫 | 已下載模型 | 下次使用 |
| --- | --- | --- | --- | --- |
| 停止服務 | 保留 | 保留 | 保留 | 再次啟動即可 |
| 移除容器但保留資料卷 | 移除 | 保留 | 保留 | 重新建立容器即可 |
| 移除容器與資料卷 | 移除 | 刪除 | 刪除 | 需要重新建立與下載 |
| 移除容器映像 | 不適用 | 不影響既有資料卷 | 不影響 Ollama 資料卷中的模型 | 下次建立容器時需要重新下載映像 |

`docker compose stop` 只停止服務，不會刪除容器、資料卷或模型

`docker compose down --volumes` 會移除本課程的容器與資料卷，帳號、對話、知識庫及模型都會被刪除

### 本課程的備份範圍

`08_data-management.cmd` 會備份 `open-webui-data` 中的重要應用資料

- 本機帳號與設定
- 對話紀錄
- 上傳文件
- 知識庫
- 文件索引

大型模型檔案不包含在備份中，避免同一模型重複占用數 GB 空間，需要重建完整環境時再重新下載 `phi4-mini:3.8b-q4_K_M` 與 `embeddinggemma:300m-qat-q4_0`

> 若還原時完全無法連接網路，必須先保留原有 Ollama 資料卷，否則無法重新下載模型

### 備份必須放在資料卷之外

備份預設儲存在 Windows 的下列資料夾

```text
Documents\Local-AI-Backups
```

- 若備份仍放在準備刪除的 Docker 資料卷內，移除環境時會連同備份一起消失
- 重要備份應再複製到另一個磁碟或隨身儲存裝置，避免電腦磁碟故障時原始資料與備份同時遺失

### 還原會回到備份當下的狀態

還原前的現有 Open WebUI 資料會被備份內容取代，備份建立後新增的對話、帳號、文件與知識庫不會保留

> `08_data-management.cmd` 只會選擇時間最新且檢查完整的備份，降低誤選其他資料夾的風險

### 不使用全域清理指令

本課程只移除 `local-ai` 專案的容器、網路與資料卷，不使用會清理整台電腦其他 Docker 專案的全域清理指令

## 3 要點

- 停止服務不等於刪除資料
- 可從資料卷名稱辨認 Open WebUI 資料與 Ollama 模型資料
- 備份前先停止服務，避免資料仍在寫入
- 備份完成後確認 `webui.db` 與備份說明檔存在
- 還原前再次確認目前資料將被備份內容取代
- 移除功能保留教材與備份，不移除 Docker Desktop
- 單元 09 仍需要使用本機 RAG，正式移除應在成果驗收後執行

## 4 實作

### 步驟一 確認管理程式

本單元資料夾應包含

```text
08-備份還原停止與移除/
├─ README.md
└─ 08_data-management.cmd
```

管理程式會讀取相鄰的單元 03 資料夾，因此不要單獨移動 `08_data-management.cmd`

### 步驟二 準備還原測試資料

1. 使用 `03_service-control.cmd` 啟動服務
2. 開啟 [http://localhost:3000](http://localhost:3000)
3. 登入自己的本機帳號
4. 建立一個標題容易辨認的新對話
5. 輸入 `這是單元 08 備份前測試`
6. 確認對話已出現在側邊欄

### 步驟三 建立備份

1. 關閉正在產生回答的對話
2. 在 `08_data-management.cmd` 上按兩下
3. 輸入 `1` 並按 Enter
4. 等待程式停止服務並複製資料
5. 看到 `Backup completed successfully` 後記錄備份資料夾位置
6. 按任意鍵返回選單
7. 輸入 `0` 結束程式

> 備份完成後服務會維持停止，這可同時確認停止服務不會刪除資料

### 步驟四 檢查備份

1. 開啟程式顯示的備份資料夾
2. 確認其中包含 `BACKUP_INFO.txt`
3. 開啟 `open-webui-data` 資料夾
4. 確認其中包含 `webui.db`
5. 確認備份資料夾中沒有 `INCOMPLETE.txt`

> 備份資料夾若包含 `INCOMPLETE.txt`，代表複製未完成，不可用於還原

### 步驟五 建立備份後資料

1. 使用 `03_service-control.cmd` 再次啟動服務
2. 登入 Open WebUI
3. 確認步驟二建立的對話仍然存在
4. 再建立一個新對話
5. 輸入 `這是單元 08 備份後測試`
6. 確認兩個測試對話都出現在側邊欄

### 步驟六 還原最新備份

> 還原會刪除備份建立後新增的 Open WebUI 資料，本次應只使用步驟五建立的測試對話進行驗證

1. 關閉正在產生回答的對話
2. 開啟 `08_data-management.cmd`
3. 輸入 `2` 並按 Enter
4. 確認畫面顯示的最新備份資料夾
5. 按 `R` 執行還原
6. 等待程式重新建立 Open WebUI 資料卷並啟動服務
7. 瀏覽器開啟後登入原有帳號

### 步驟七 查核還原結果

1. 確認「單元 08 備份前測試」對話仍然存在
2. 確認「單元 08 備份後測試」對話已不存在
3. 開啟單元 05 建立的知識庫
4. 確認知識庫與文件仍然存在
5. 建立新對話並連結知識庫
6. 提出一個已在單元 06 查核過的問題
7. 確認回答仍能顯示正確來源

> 若模型清單中缺少模型，先確認 Ollama 資料卷是否仍然存在，需要時重新下載模型

### 步驟八 認識移除操作

`08_data-management.cmd` 的選項 `3 Remove the local AI environment` 會要求輸入 `DELETE` 才能繼續

執行後會移除

- `local-ai` 專案的兩個容器
- `local-ai` 專案網路
- `local-ai_open-webui-data` 資料卷
- `local-ai_ollama-data` 資料卷
- 使用者選擇移除的兩個容器映像

執行後會保留

- Docker Desktop 與 WSL2
- 教材資料夾
- `Documents\Local-AI-Backups` 中的備份

> 本步驟先閱讀與辨認，不要在單元 09 成果驗收前執行

## 5 成功檢查

- 已建立不含 `INCOMPLETE.txt` 的備份資料夾
- 備份中包含 `BACKUP_INFO.txt` 與 `open-webui-data\webui.db`
- 備份前建立的測試對話可在還原後開啟
- 備份後建立的測試對話已在還原後消失
- 知識庫、文件與來源引用仍可使用
- 能說明停止服務、刪除資料卷與刪除容器映像的差異
- 尚未在單元 09 前移除課程環境

## 6 常見問題與排除

### 找不到單元 03 的設定檔

保持教材原有資料夾結構，不要只複製 `08_data-management.cmd`，單元 03 與單元 08 資料夾應位於同一層

### 備份資料夾包含 INCOMPLETE.txt

該次備份不可使用，確認磁碟空間足夠且 Docker Engine 正常執行後重新建立備份

### 備份時間很久

上傳文件、對話與索引越多，複製所需時間越長，備份過程不要關閉視窗或結束 Docker Desktop

### 還原後無法登入

確認還原完成時沒有出現錯誤，並確認選用的是包含原有帳號資料的最新備份

### 還原後找不到模型

備份不包含 Ollama 模型，若模型資料卷曾被移除，需要連接網路並重新下載 `phi4-mini:3.8b-q4_K_M` 與 `embeddinggemma:300m-qat-q4_0`

### 想保留模型但重設 Open WebUI

不要使用完整移除功能，應只重建 `local-ai_open-webui-data`，並保留 `local-ai_ollama-data`

### 移除映像時顯示仍在使用

該映像可能同時供其他容器使用，程式不會強制刪除，避免影響其他 Docker 專案

### 移除後想重新使用

使用單元 03 的 `03_service-control.cmd` 啟動服務，重新下載模型後，再以本單元的最新備份還原 Open WebUI 資料

## 7 單元成果

學生完成 Open WebUI 資料備份與還原驗證，能安全停止服務並理解何時才應移除課程環境

## 官方參考資料

- [Docker Desktop Volumes](https://docs.docker.com/desktop/use-desktop/volumes/)
- [Docker Compose Down](https://docs.docker.com/reference/cli/docker/compose/down/)
- [Docker Desktop Backup and Restore](https://docs.docker.com/desktop/settings-and-maintenance/backup-and-restore/)
- [Open WebUI Backups](https://docs.openwebui.com/tutorials/maintenance/backups/)
- [Open WebUI Updating and Backup](https://docs.openwebui.com/getting-started/updating/)

## 單元導引

- 上一單元：[單元 07 資料更新與知識庫維護](../07-資料更新與知識庫維護/README.md)
- 下一單元：[單元 09 個人 RAG 成果驗收](../09-個人-RAG-成果驗收/README.md)
