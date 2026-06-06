# 清序 Clear Flow

清序是一款 Flutter 手机端离线待办清单。任务、个人资料和偏好都保存在本机，无网络也能使用。

当前版本：`0.1.0+1`

## 核心功能

- 任务新增、编辑、删除、完成、恢复和备注。
- 截止日期、具体时间、三级优先级和智能排序。
- 未完成、已完成、全部任务筛选。
- 逾期、今天、明天、三天内和剩余天数展示。
- 任务数量、近三天到期、完成率和进度统计。
- Drift/SQLite 离线存储与失败回滚。
- 本地通知：定时任务默认提前两小时，仅日期任务默认当天 09:00。
- 本地用户名、头像、默认筛选和动画偏好。

## 本地运行

需要 Flutter `3.41.5`、Dart `3.11.3`。

```powershell
flutter pub get
dart run build_runner build
flutter run
```

## 验证

```powershell
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/offline_task_flow_test.dart -d emulator-5554
flutter build apk --debug
```

## 发布

版本号同时维护在 `VERSION`、`pubspec.yaml`、应用信息和 Git 标签中。

```powershell
powershell -ExecutionPolicy Bypass -File tool/release.ps1 `
  -Version 0.1.0 `
  -Build 1 `
  -DryRun
```

移除 `-DryRun` 后，脚本只允许在与 `origin/main` 完全同步的 `main` 分支运行，并自动创建发布提交、`v0.1.0` 标签和 GitHub 推送。

## 已知限制

- 当前没有账号、云同步和跨设备同步。
- Android 使用非精确闹钟，省电策略可能导致通知轻微延迟。
- iOS 正式安装需要 Apple 开发者签名。
