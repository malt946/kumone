# 光遇身高查询 — iOS 开发入口。
#
# `make project` 用 XcodeGen 从 ios/project.yml 重新生成 ios/KumoneIOS.xcodeproj，
# 仅在修改 project.yml 后需要执行。

.DEFAULT_GOAL := help
.PHONY: help project ios-build ios-test ios-uitest clean

help: ## 显示可用命令
	@echo "光遇身高查询 make targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

project: ## 从 project.yml 重新生成 Xcode 工程（需要 xcodegen）
	@cd ios && xcodegen generate

IOS_DESTINATION ?= platform=iOS Simulator,name=iPhone 16

ios-build: ## 编译 iOS 应用（模拟器，无需签名）
	@xcodebuild build \
		-project ios/KumoneIOS.xcodeproj \
		-scheme KumoneIOS \
		-destination '$(IOS_DESTINATION)' \
		CODE_SIGNING_ALLOWED=NO

ios-test: ## 运行 iOS 单元测试（Swift Package）
	@cd ios/KumoneIOSPackage && xcodebuild test \
		-scheme KumoneIOSFeature \
		-destination '$(IOS_DESTINATION)'

ios-uitest: ## 运行 iOS UI 测试
	@xcodebuild test \
		-workspace ios/KumoneIOS.xcworkspace \
		-scheme KumoneIOS \
		-destination '$(IOS_DESTINATION)'

clean: ## 清理构建产物
	@rm -rf .build
	@rm -rf ios/Config/Generated
