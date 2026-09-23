# 任务2 · flutter doctor 问题定位与修复记录

> 要求：至少记录 1 个真实问题及其解决。本文记录 **2 个真实问题**（一为主问题，
> 一为连带问题），外加 1 个环境性警告，全部来自本机 2026-09-23 的实际操作，
> 现象、定位、解决、验证四段式书写。

---

## 问题 1（主问题）：Android license status unknown，且 `--android-licenses` 无法修复

### 现象
```
[!] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
    X Android license status unknown.
      Run `flutter doctor --android-licenses` to accept the SDK licenses.
```
按提示执行 `flutter doctor --android-licenses`，只输出：
```
WARNING: The SDK Manager CLI tool (sdkmanager) is deprecated. Android CLI will be used instead.
Warning: The --licenses option is no longer needed.
```
未出现任何 "Accept? (y/N)" 问句，复查 doctor 状态依旧是 unknown，**提示语给出的标准修复路径失效**。

### 定位
1. 怀疑新版 cmdline-tools（23.0.0）行为变化：`sdkmanager.bat` 只是转发器，
   真正逻辑在 `bin\android.exe`；它对 `--licenses` 直接返回"不再需要"。
2. 手工测试 `android.exe sdk list`、`android.exe sdk install ...`：
   网络类子命令一律崩溃，退出码 `0xC0000409`（STATUS_STACK_BUFFER_OVERRUN），
   而纯本地命令（`info`、`emulator list`）正常——新 CLI 本身有缺陷。
3. 阅读 Flutter SDK 源码
   `flutter\packages\flutter_tools\lib\src\android\android_workflow.dart`
   中 `licensesAccepted` 的实现：doctor 会启动
   `cmdline-tools\latest\bin\sdkmanager.bat --licenses` 并解析输出中的
   **"All SDK package licenses accepted"** 等字样；壳转发后拿不到这些字样
   → 状态只能判为 unknown。
4. 结论：**根因不是"没接受许可"，而是新版 cmdline-tools 的 sdkmanager 壳
   让 flutter doctor 拿不到许可状态**。

### 解决（系统级操作，人工确认后执行）
1. 从 dl.google.com 下载官方经典版
   `commandlinetools-win-11076708_latest.zip`（约 146 MB）。
2. 备份原目录：`cmdline-tools\latest` → 改名保留。
3. 解压 zip，用经典版 `bin\`、`lib\` 覆盖进 `cmdline-tools\latest\`。
4. 用 Android Studio 自带 JBR 的 Java 运行：
   `sdkmanager --licenses`，逐项输入 y，末行输出
   **`All SDK package licenses accepted`**。

### 验证
`flutter doctor` 中 Android toolchain 变为 `[√]`；最终体检全绿
（见 docs/flutter_doctor_green.png 全屏截图）。

---

## 问题 2（连带问题）：Gradle assembleDebug 失败，退出码 0xC0000409

### 现象
首次 `flutter run -d emulator-5554` 构建报错：
```
Package ndk not found.
Package 28.2.13676358 not found.
FAILURE: Build failed with an exception.
> Process 'command '...\cmdline-tools\latest\bin\sdkmanager.bat''
  finished with non-zero exit value -1073740791 (NTSTATUS 0xC0000409)
```

### 定位
Flutter 的 Gradle 插件在配置期检测到项目需要 NDK 28.2.13676358 而本机未装，
于是自动调用 sdkmanager 补装；此时 latest 里仍是"壳"，壳又去拉起会崩的
`android.exe` → 构建被拖崩。与问题 1 同根：**坏的是 cmdline-tools 本体**。

### 解决
1. 先完成问题 1 的工具替换（壳 → 经典 Java 版 sdkmanager）。
2. 手动补装：`sdkmanager --install "ndk;28.2.13676358"`。

### 验证
重新 `flutter run -d emulator-5554`，Gradle 不再请求安装 NDK，
构建进入正常编译流程并最终在模拟器上启动（见 docs/emulator_run.png）。

---

## 问题 3（环境性警告，未修复，属网络环境限制）：Network resources 检查失败

### 现象
`flutter doctor` 偶发输出：
```
[!] Network resources
    X An HTTP error occurred while checking "https://github.com/": 信号灯超时时间已到
```

### 定位
该项只是 doctor 对 github.com 的连通性抽检。本机访问 GitHub 常规直连不稳定
（连接重置/超时交替出现），属网络环境问题，与 Flutter 工具链无关。

### 处理与验证
不修改任何工具配置；网络可达时段复查该项自动恢复 `[√]`（最终体检即为全绿）。
推论：**git push 到 GitHub 也需选择网络可达的时段执行**，失败时先重试再排查代理。

---

## 复盘：doctor "只开报告不开药"的正确用法

- doctor 的提示语是**线索**而不是药方：本题中提示语开的"药"（`--android-licenses`）
  本身失效，必须下钻一层定位到 cmdline-tools。
- 修复后一定要回到 doctor 复检闭环，而不是只看修复动作的退出码。
