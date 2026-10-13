Computer Organization Final Project — Verilog 原始碼與檢查

從指定的四個資料夾擷取 115 個原始 .v 檔，保留原始位元組與檔名。
第三個資料夾的 42 個 .v 位於 RAR 內，已取出。排除 4 個 Xilinx glbl.v、
工程檔、編譯產物、波形、可執行檔與原有簡報／報告。來源一的 ZIP 內
10 個 .v 與外層檔案完全相同，未再重複保存。

來源與目錄

sources/01-computer-program-final/       10 檔，COMPUTER program FINAL
sources/02-final-pj/single-cycle/        15 檔，final_pj 單週期
sources/02-final-pj/pipeline/            19 檔，final_pj 管線
sources/02-final-pj/hazard/              22 檔，final_pj hazard
sources/03-final-project-rar/single-cycle/ 15 檔，計組final project RAR
sources/03-final-project-rar/pipeline/    19 檔，同上
sources/03-final-project-rar/hazard/       8 檔，同上
sources/04-final-project/                7 檔，FInal project

各目錄是獨立設計，具有相同名稱的 module，請分開編譯。
01 的兩個空殼 .v 也原樣保留，因為它們屬於來源，並在報告標示衝突。

檢查結論

四份來源均未完全符合指定簡報。02、03 的單週期版涵蓋全部十種指令，
但 addi 會誤寫資料記憶體。Pipeline／hazard 版本有 jump 缺漏、
分支或 forwarding 缺陷。01、04 另有頂層編譯問題。
本次保留原始碼，沒有替換或修正這些設計。

檢查依據為使用者指定的「計算機組織FinalProject.pptx」第 2–9 頁。
該簡報截止日為 2019/1/15，只能確認這份題目，無法證明每年都相同。

文件與驗證

AUDIT.zh-TW.txt          各版本判定、主要問題、需求及驗證範圍
source-manifest.json     每一檔的來源對照、SHA-256、排除與重複項目
reports/                詳細靜態檢查、實際測試結果與工具診斷
verification/           新增的自動檢查 testbench、案例清單及執行器

verification 裡的 .v 是本次新增的檢查，不計入 115 個原始檔。
測試失敗表示原始設計未通過該項功能，並非以「預期失敗」當作符合。
原有 PDF 與簡報依要求不納入 repo，所以此處不是完整作業繳交壓縮包。

重跑檢查（Python 3 + Icarus Verilog）

python verification/run_checks.py

若工具未在 PATH：
python verification/run_checks.py --iverilog C:/path/bin/iverilog.exe --vvp C:/path/bin/vvp.exe

結果預設寫入 .verification-build/results.json。可加 --case 案例名稱只執行一項。
執行器會先驗證全部 115 個原始檔 SHA-256。存在功能／編譯失敗時會回傳非零。
最終 38 個案例中，27 個 assertion 測試有 10 通過、17 失敗，另確認 3 類
原始碼編譯問題。請參閱 reports 的完整結果，勿將 testbench 能結束視為完整符合。
