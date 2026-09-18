# 補充教材：Docker Desktop 啟動錯誤排查

本文件供 Docker Desktop 無法正常啟動時查閱，不屬於一般安裝流程的必做步驟

若左下角已顯示 `Engine running`，請回到簡報「重新檢查」，繼續正常流程

## 出現虛擬化錯誤時

若畫面顯示 `Virtualization support not detected`，先暫停後續操作，保留錯誤畫面並請教師協助

這個訊息表示 Docker Desktop 未偵測到所需的虛擬化支援，不能只憑這個畫面判定是哪一項設定出了問題

![Docker Desktop 顯示虛擬化錯誤](<../images/螢幕擷取畫面 2026-09-14 134632.png>)

## 停止 Docker Desktop 後再檢查

需要進行環境修復時，先儲存其他工作，並依教師指示停止 Docker Desktop

下圖顯示 `Docker Desktop stopped`，代表當時 Docker Desktop 已停止，這是狀態示意，不是操作選單

![Docker Desktop 已停止的狀態](<../images/螢幕擷取畫面 2026-09-14 134934.png>)

1. 開啟「00-課前硬體與環境檢查」資料夾
2. 按兩下 `00_check-environment.cmd`
3. 等待檢查完成，將結果交由教師確認
4. 若畫面提供 `Press R to repair or X to close`，經教師確認後可按 `R` 進行修復
5. 若 Windows 詢問是否允許變更，確認正在執行教材的修復程式後選擇「是」
6. 等待修復完成，儲存工作後重新啟動 Windows

修復程式不會自動重新啟動電腦

若未出現修復選項，或沒有系統管理員權限，請保留檢查結果並由教師或設備管理人員協助，不要反覆執行或自行更改不熟悉的設定

韌體中的虛擬化設定若尚未啟用，需由熟悉該電腦的人員協助處理，不能假設執行修復程式就一定能排除

## 回到正常流程

1. 重新開啟 Docker Desktop
2. 等待左下角顯示 `Engine running`
3. 再次執行 `00_check-environment.cmd`
4. 確認虛擬化、WSL 與 Docker Engine 等相關檢查通過後，回到簡報「重新檢查」繼續操作

若仍顯示相同錯誤，請提供 Docker 錯誤畫面、環境檢查結果，以及已執行的步驟，交由教師判斷

不要為了排除啟動問題而重設 Docker、刪除資料或反覆重新安裝

回到 [單元 02 說明文件](README.md)
