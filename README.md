# 計算機組織 Final Project：可執行修正版

下載本 repo 即包含五個保留架構的修正版、新寫的 A／B／C 參考實作、testbench、獨立 MIPS 模型及測資產生器。題目指定的十種指令、byte addressing、signed `slt`、branch／jump、forwarding 與 load-use 均有實際 Icarus 模擬驗證。

## 題面與所需檔案

[官方 FinalProject 簡報](originals/計算機組織FinalProject.pptx) 原始位元組完整保留，含 9 張投影片與 5 個嵌入圖片。ISA、A／B／C 等級及程式例子已在文件內；沒有另需下載的 ROM、圖片或資料附件。課程要求繳交的 RTL、top testbench 和學生報告是須自行製作的成果。[specifications.json](originals/specifications.json) 記錄原檔 SHA-256 與引用分類。

歷史匿名原碼、六份保留原 filesets／top／generics／part／version 並改成可攜路徑的 XPR，以及不同 ROM 的 ZIP／RAR 原始變體，保存在 [computer-organization-verilog-projects](https://github.com/handsomegary/computer-organization-verilog-projects)。本 repo 的修正版模擬不依賴那個 repo 或本機 Downloads 資料夾。

## 重跑功能驗證

需要 Python 3（建議 3.12）與 Icarus Verilog，將 `iverilog`、`vvp` 加入 PATH。Python runner 僅使用標準函式庫。從 repo 根目錄執行：

```sh
python verification/check_course_specification.py
python verification/check_package.py
python verification/check_all.py
```

應得到 `ALL: 173/173`：回歸 38、新參考 97、pipeline 22、壓力測試 16。測資及預期記憶體由已收錄腳本產生，任何編譯、模擬、逾時或功能錯誤都回傳非零。工具不在 PATH 時可指定：

```sh
python verification/check_all.py --iverilog C:/path/bin/iverilog.exe --vvp C:/path/bin/vvp.exe --iverilog-base C:/path/lib/ivl
```

快速執行新參考 A／B／C 的內建程式：

```sh
iverilog -g2012 -s reference_demo_tb -o demo.vvp verification/reference_demo_tb.v reference/rtl/mips_single_cycle.v reference/rtl/mips_pipeline.v
vvp demo.vvp
```

成功會輸出 `REFERENCE DEFAULT ROM PASS` 並正常結束。介面、記憶體容量、reset 與 ISA 範圍見 [詳細說明](README.txt)，修正對照見 [AUDIT.zh-TW.txt](AUDIT.zh-TW.txt)。

## Vivado 模擬入口

[create_vivado_sim.tcl](scripts/create_vivado_sim.tcl) 由 committed 相對來源建立新的 behavioral simulation 工程。預設 `reference` 使用兩個參考 RTL 與 `reference_demo_tb`，同一個 testbench 檢查 A／B／C、內建 ROM、全部暫存器、資料記憶體與 reset。

```sh
vivado -mode batch -source scripts/create_vivado_sim.tcl -tclargs -variant reference -out-dir vivado-sim -run
```

成功的 testbench 應輸出 `REFERENCE DEFAULT ROM PASS`，腳本再確認 simulation log 的 PASS 標記及錯誤。省略 `-run` 可只建立工程。既有輸出路徑會被拒絕，不會覆寫；重跑請使用另一個 `-out-dir`。預設 part 為 `xc7a35tcsg324-1`，可用 `-part` 選擇已安裝的器件。

| `-variant` | 設計來源 |
|---|---|
| `reference` | `reference/rtl/`：新參考 A／B／C |
| `s02-single-cycle` | `sources/02-final-pj/single-cycle/`：A |
| `s02-pipeline` | `sources/02-final-pj/pipeline/`：B |
| `s02-hazard` | `sources/02-final-pj/hazard/`：C |
| `s03-single-cycle` | `sources/03-final-project-rar/single-cycle/`：A |
| `s03-pipeline` | `sources/03-final-project-rar/pipeline/`：B |

六個變體必須各自建立工程，以免同名模組衝突。Python 含標準 `tkinter`／Tcl 時可無 GUI 執行：

```sh
python scripts/check_vivado_sim.py
```

此檢查使用 Tcl interpreter 與 mock Vivado commands，涵蓋來源預檢、六個工程／模擬分支、錯誤傳遞及不覆寫保護。本機沒有 Vivado／XSim，未在 Vivado 實際開啟或執行；mock 結果不當成 RTL 功能證明。RTL 功能由 Icarus 實際模擬驗證。尚未執行 FPGA synthesis、timing closure 或實體板驗證。

Tcl API 已核對官方 [UG835 2018.3](https://docs.amd.com/v/u/2018.3-English/ug835-vivado-tcl-commands)：`create_project`、`add_files`、`get_files`、`set_property`、`update_compile_order`、`launch_simulation`、`run -all`、`close_sim`、`close_project`。Testbench 明確設為 SystemVerilog，以支援 `$fatal` 自我檢查；流程範例與 `xsim.simulate.runtime` 依 [UG900 2019.2](https://docs.amd.com/v/u/2019.2-English/ug900-vivado-logic-simulation) 第 73、174 頁。
