# hello-world — 移动应用软件开发实训 第 1 课

《移动应用软件开发实训》第 1 次课的课堂案例复现、自主实践与选做任务仓库。
分支：`lecture1`（按作业要求"分支或目录名为 lecture1"）。

## 目录结构

```
lecture1/
├── hello_world/              # 课堂案例：flutter create 生成的计数器应用（含逐行中文注释）
│   └── lib/main.dart
├── 2-自主实践/               # 基本要求 5 项
│   ├── 1-安装过程记录.md
│   ├── 2-doctor问题定位与修复.md
│   ├── 3-手工安装原理说明.md
│   ├── 4-main.dart逐行中文注释.dart
│   └── 5-AI使用边界说明.md
├── 3-选做-独立研究/          # 选做任务 3 项
│   ├── 1-镜像实验报告.md
│   ├── 2-TraeCode与TraeWork能力差异实测.md
│   └── 3-性能对比报告.md
└── docs/                     # 全屏截图证据
    ├── web_run_chrome.png        # Web 端（Chrome）运行全屏
    ├── flutter_doctor_green.png  # flutter doctor 全绿全屏
    └── emulator_run.png          # Android 模拟器运行全屏
```

## 运行方式

环境：Flutter 3.47.2 stable（Dart 3.13.2）/ Android SDK（API 36）/ Windows 11

```bash
cd hello_world
flutter pub get

# Web 端
flutter run -d chrome

# Android 模拟器（AVD: Medium_Phone_API_36）
flutter emulators --launch Medium_Phone_API_36
flutter run -d emulator-5554

# Windows 桌面
flutter run -d windows
```

## Git 提交规范

按指南要求使用语义化提交（feat/docs/fix/chore），第 1 课共 4 次提交。
