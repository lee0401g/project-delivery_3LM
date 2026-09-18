# 補充教材-Docker Desktop 啟動錯誤排查

本文件供 Docker Desktop 無法正常啟動時查閱，不屬於一般安裝流程的必做步驟

需要進入 BIOS 或 UEFI、執行修復或使用系統管理員權限時，應由教師或設備管理人員協助

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

## 確認是否需要進入 BIOS 或 UEFI

先查看重新執行 `00_check-environment.cmd` 的結果：

- 韌體虛擬化顯示 `PASS`：不需要進入 BIOS 或 UEFI，請由教師繼續檢查 Windows、WSL 與 Docker Desktop
- 韌體虛擬化顯示 `WARN` 或 `UNKNOWN`：保留檢查畫面，經教師確認後再進行後續操作
- 教師確認韌體虛擬化尚未啟用：再依下列方式進入 BIOS 或 UEFI

> 如果 BIOS 或 UEFI 中的虛擬化已是 `Enabled`，不要改動，也不要改動其他設定

## 進入 BIOS 或 UEFI 前

1. 儲存所有工作
2. 筆記型電腦接上電源
3. 使用手機拍下目前的設定畫面，保留原始狀態
4. 確認只調整本文件列出的 CPU 虛擬化設定

學校、公司或受管理的電腦，應由教師或設備管理人員操作

> 若畫面要求輸入 BIOS 密碼或 BitLocker 復原金鑰，停止操作並請教師或設備管理人員協助，不要自行猜測密碼

## 從 Windows 11 進入 UEFI

優先使用 Windows 11 的設定進入 UEFI，不需要猜測開機按鍵：

1. 開啟 Windows「設定」
2. 選擇「系統」
3. 選擇「復原」
4. 在「進階啟動」旁選擇「立即重新啟動」
5. 等候電腦重新啟動並顯示「選擇選項」
6. 選擇「疑難排解」
7. 選擇「進階選項」
8. 選擇「UEFI 韌體設定」
9. 選擇「重新啟動」

若沒有看到「UEFI 韌體設定」，請先回到 Windows，再依電腦品牌或型號的官方說明操作

## 開機時常見的進入方式

不同品牌、型號與韌體版本可能使用不同按鍵，下表只列出常見方式

請先將電腦關機，再開機並在品牌標誌出現時連續按下對應按鍵

| 品牌或系列 | 常見按鍵或方式 | 補充說明 |
| --- | --- | --- |
| Dell | `F2` | 在 Dell 標誌出現時連續按下 |
| HP | `F10` | 部分機型需先按 `Esc`，再選擇 `F10` |
| Lenovo IdeaPad | `F2` 或 `Fn + F2` | 部分機型可使用 Novo 按鈕並選擇 BIOS Setup |
| Lenovo ThinkPad、ThinkCentre | `F1` 或 `Fn + F1` | 依機型與功能鍵設定而異 |
| ASUS | `F2` 或 `Delete` | 部分畫面需按 `F7` 進入 Advanced Mode |
| Acer | `F2` | 依機型而異 |
| MSI | `Delete` | 筆記型電腦與主機板的畫面可能不同 |
| Microsoft Surface | 按住音量增加鍵，再按一下電源鍵 | 看到 UEFI 畫面後放開音量增加鍵 |

> 若按鍵無法進入，請查閱該電腦型號的官方操作手冊，不要嘗試網路上未經原廠確認的隱藏選單按鍵

## 尋找 CPU 虛擬化設定

進入 BIOS 或 UEFI 後，先查看下列選單名稱：

- `Advanced`
- `Configuration`
- `Security` 或 `System Security`
- `CPU Configuration` 或 `Processor Configuration`
- `System Options`
- `CPU Features`

再依處理器尋找虛擬化設定：

| 處理器 | 畫面中可能出現的名稱 | 需要確認的狀態 |
| --- | --- | --- |
| Intel | `Intel Virtualization Technology` | `Enabled` |
| Intel | `Intel VT-x` | `Enabled` |
| Intel | `Intel (VMX) Virtualization Technology` | `Enabled` |
| AMD | `SVM Mode` | `Enabled` |
| AMD | `Secure Virtual Machine` | `Enabled` |
| AMD | `AMD-V` | `Enabled` |
| 通用名稱 | `Virtualization Technology` 或 `CPU Virtualization` | `Enabled` |

> 同一部電腦通常只會顯示其中一種名稱，不需要找到表中的所有項目

## 不要混淆其他相似設定

本次只確認 CPU 虛擬化設定，不要改動以下項目：

| 畫面文字 | 與本次設定的差異 |
| --- | --- |
| `Intel VT-d` | 屬於裝置 I/O 虛擬化，不等於主要的 `VT-x` 開關 |
| `IOMMU` | 與裝置存取及 I/O 虛擬化有關，不是本次首先要找的設定 |
| `Hyper-Threading` 或 `SMT` | 屬於 CPU 執行緒功能，不是虛擬化開關 |
| `Secure Boot` | 屬於開機安全功能，不要因本次排查而停用 |
| `TPM` | 屬於安全功能，不是 Docker Desktop 的虛擬化開關 |
| `CSM` 或 `Legacy Boot` | 屬於開機模式，不要修改 |
| `Hyper-V` | 屬於 Windows 功能，不是 BIOS 或 UEFI 中的 CPU 虛擬化設定 |
| `SLAT` | 屬於處理器硬體能力，通常不是可手動啟用的項目 |

> 也不要修改磁碟模式、開機順序、超頻、韌體密碼或其他不熟悉的設定

## 儲存設定並重新檢查

1. 確認 CPU 虛擬化設定已是 `Enabled`
2. 選擇 `Save & Exit`、`Save Changes and Exit` 或畫面中意思相同的選項
3. 確認儲存，等候 Windows 重新啟動
4. 再次執行 `00_check-environment.cmd`
5. 確認韌體虛擬化顯示 `PASS`

> 若韌體虛擬化仍未顯示 `PASS`，停止修改 BIOS 或 UEFI，保留畫面並請教師協助

## 回到正常流程

1. 重新開啟 Docker Desktop
2. 等待左下角顯示 `Engine running`
3. 再次執行 `00_check-environment.cmd`
4. 確認虛擬化、WSL 與 Docker Engine 等相關檢查通過後，回到簡報「重新檢查」繼續操作

> 若仍顯示相同錯誤，請提供 Docker 錯誤畫面、環境檢查結果，以及已執行的步驟，交由教師判斷

> 不要為了排除啟動問題而重設 Docker、刪除資料或反覆重新安裝

## 官方參考資料

- [Docker Desktop for Windows 系統需求](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Microsoft：在 Windows 啟用虛擬化](https://support.microsoft.com/en-us/windows/experience/enable-virtualization-on-windows)
- [Dell：啟用或停用硬體虛擬化](https://www.dell.com/support/kbdoc/en-us/000195978/how-to-enable-or-disable-hardware-virtualization-on-dell-systems)
- [Lenovo IdeaPad：進入 BIOS 的建議方式](https://support.lenovo.com/uu/en/solutions/ht500216)
- [ASUS：在 BIOS 設定虛擬化技術](https://www.asus.com/us/support/faq/1045141/)
- [Acer：啟用虛擬化技術](https://community.acer.com/en/kb/articles/14750)
- [Microsoft Surface：使用 Surface UEFI](https://support.microsoft.com/en-us/surface/drivers-firmware/how-to-use-surface-uefi)

回到 [單元 02 說明文件](README.md)
