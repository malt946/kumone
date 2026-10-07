<div align="right">

[English](README.md) | **简体中文**

</div>

<div align="center">

# 光遇身高查询

**SwiftUI 编写的 iOS 应用 · 查询《光·遇》角色身高体型 · 内含小工具与会员商城**

</div>

## 简介

「光遇身高查询」是一款面向《光·遇》玩家的 iOS 工具类应用，提供身高查询、实用小工具与会员服务。当前仓库处于**空壳阶段**：导航结构、页面骨架与首次启动协议流程已完成，具体业务逻辑与接口将在后续补充。

> 内部模块名（`KumoneCore`、`KumoneIOSFeature`）为迁移期占位，后续会统一重命名；用户可见名称已更新为「光遇身高」。

## 功能结构

应用由四个主 Tab 组成，底部为可拖动的悬浮玻璃导航栏：

| Tab | 说明 |
| --- | --- |
| **查询** | 输入好友码 / 昵称，展示身高数值与体型档位、历史查询记录 |
| **工具** | 身高换算器、体型对照表、蜡烛计算器、复刻进度、先祖图鉴等入口 |
| **商城** | 会员权益展示与套餐开通（月卡 / 季卡 / 年卡 / 永久） |
| **我的** | 个人信息、会员状态（开通时间 / 到期时间 / 剩余天数）与设置 |

**首次启动**会弹出用户协议与隐私政策同意页，需勾选并同意后方可进入应用。

## 构建

要求 macOS + Xcode 16+、iOS 16.0 及以上设备或模拟器。

```bash
# 若修改了 ios/project.yml，先重新生成工程（需要 xcodegen）
make project

# 编译到模拟器
make ios-build

# 或直接用 Xcode 打开 ios/KumoneIOS.xcworkspace 运行
```

命令行方式（等价）：

```bash
cd ios && xcodegen generate
xcodebuild build \
  -project ios/KumoneIOS.xcodeproj \
  -scheme KumoneIOS \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## 项目结构

```
Sources/Kumone/
├── App/                 # 应用入口、根 Tab 视图、悬浮导航栏、首次协议页
│   ├── AppTab.swift
│   ├── SkyAppRoot.swift
│   ├── SkyTabBar.swift
│   └── OnboardingView.swift
├── Sky/                 # 业务领域层与页面
│   ├── Core/            # 模型、会话、设置、Toast（当前为本地 mock）
│   └── Views/           # 查询 / 工具 / 商城 / 我的 页面
│       └── SkyComponents.swift   # 卡片、徽章、按钮等共享组件
├── DesignSystem/        # Theme 设计令牌与按钮样式
└── Resources/           # 多语言与隐私清单

ios/
├── Config/              # Info.plist、entitlements、xcconfig
├── KumoneIOS/           # Xcode 应用壳（仅入口）
├── KumoneIOSPackage/    # 承载全部功能代码的 Swift Package
└── project.yml          # XcodeGen 工程描述
```

## 说明

本项目仅供学习交流，与《光·遇》官方及 thatgamecompany 无任何关联。应用名称、Bundle ID 均为占位，发布前请替换。
