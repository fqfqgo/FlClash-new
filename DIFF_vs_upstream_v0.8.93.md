# FlClash-new 与上游 v0.8.93 差异对照

> 对比基准  
> - **本地**：`D:\aicoding\FlClash-new`（`HEAD` = `89d4950`，描述标签 `v0.8.93.4`，另含未提交改动）  
> - **上游**：[chen08209/FlClash `v0.8.93`](https://github.com/chen08209/FlClash/releases/tag/v0.8.93)（真实 tag 提交 `45015f856b44cb52cca755c04c885d73c45ae6b9`，标题 *Support custom overwrite*）  
> - **对比方式**：`git fetch` 后以 `upstream-v0.8.93`（`refs/tags/upstream-v0.8.93`）为基准；三方点差异 `upstream-v0.8.93...HEAD`  
> - **统计（已提交）**：相对上游 **超前 57 个提交**、**落后 0**；约 **45 个文件**，**+1255 / -1182** 行  
> - **生成日期**：2026-07-11  

> **注意**：本地名为 `v0.8.93` 的 tag 曾被指向 fork 提交 `0765c6d`（*fix: match upstream proxy selection after v0.8.93 sync*），**并非** GitHub 上游 release 的真实提交。本文以上游官方 tag 内容为准。

---

## 1. 总览

本 fork 在同步上游 `v0.8.93` 后，保留并叠加了面向 **fqfqgo/FlClash-new** 的定制，主要包括：

| 类别 | 要点 |
|------|------|
| 产品标识 | 展示名「FlClash for v2free」、自动更新仓库、Android `applicationId` |
| 功能 | 加密订阅解密、仪表盘「启动浏览器」、版本号展示带 build 后缀 |
| 行为/修复 | 代理组类型解析、空配置拒绝、macOS 托盘 CPU、DB 幂等迁移、当前订阅兜底选择（未提交） |
| CI/发布 | 禁用 Telegram/F-Droid 推送、产物命名含 tag 后缀、Android 签名与 APK 兜底 |
| 依赖 | 新增 `encrypt`，下调 `test` 等版本约束 |
| 文档/文案 | CHANGELOG 大幅精简；关于页/描述文案改写 |

---

## 2. 相对上游的全部提交（`upstream-v0.8.93..HEAD`，时间正序）

共 **57** 个提交（含大量 changelog 与 CI 迭代）：

```
1a5138f feat: add subscription decryption support
4f54dca fix: skip telegram step when TELEGRAM_BOT_TOKEN is not set
e7e489a chore: bump version to 0.8.92.1
d066ce2 fix: remove invalid secrets check in workflow (use continue-on-error)
0b67c41 fix: remove secrets from if condition in Android signing step
17c260d fix: prevent matrix cancel when linux arm64 fails
b4b38b9 fix: use valid Flutter version format 0.8.92+1
0a07e45 fix: stabilize CI builds across platforms
b17651c fix: ensure build output dirs exist before go build
f56258e chore: print full setup errors in CI logs
e094ccc fix(ci): android description, exit(1), appdmg optional, upload ignore empty dist, macos install appdmg
aa49a18 fix(ci): set FLUTTER_ROOT for macOS/Linux ...
7771de8 fix(macos): set FLUTTER_ROOT in Xcode Run Script ...
ec778ad fix(macos): pre-create Flutter-Generated.xcconfig in CI ...
a9d4b74 fix(macos): use wrapper script to resolve FLUTTER_ROOT ...
fb826f0 ci: align macOS build with upstream, remove FLUTTER_ROOT override
02b090a chore(ci): sync macOS build workflow with upstream
5b0549a fix: sync generated profile model and import InputDialog
2c757aa feat: update subscription password flow and add local precheck hooks
e423228 fix(dev): enforce precheck failures and align SDK-pinned dependency
627c10c chore(build): refresh generated sources for CI packaging
e19bd2d fix(ci): make material_color_utilities constraint compatible across Flutter pins
068f782 fix(ci): validate and robustly write google-services.json
c4fd9ab chore(android): switch applicationId and stop tracking google-services.json
c24abc2 Update changelog
1b643d8 fix(ci): make telegram push resilient and non-blocking
5c53aef chore(ci): disable telegram push in release workflow
2e7b22b Update changelog
cb015de chore(ci): disable fdroid push step
2e04cdb fix(release): use commit subjects and filter co-author trailers
7304912 feat(dashboard): add launch-browser button beside start button
80ccdc3 Update changelog
0b0e5a1 feat(ui): improve subscription password UX and release notes
845f30a fix(ci): collect android apk into dist fallback
2d761a0 Update changelog
622d91a fix(ci): stabilize android artifacts and release notes
7a50ff5 Update changelog
7d488f5 feat(release): show full version and refine about page
51cf6f0 Update changelog
f781584 fix(macos): avoid high CPU when tray traffic is disabled (fix #1644)
312450d Update changelog
2ba7dce chore: point auto update to fqfqgo/FlClash-new, bump to v0.8.92.13
bdca25d fix: use valid Dart version format 0.8.92+13
cb73dc9 chore: set default test URL to http://cp.cloudflare.com
815a792 merge: upstream FlClash v0.8.93 with fork customizations preserved
f1578ad fix: preserve fork profile behavior after v0.8.93 sync
0765c6d fix: match upstream proxy selection after v0.8.93 sync
6ee0362 Update changelog
21505d3 ui: update displayed product title
0c56d68 fix: patch repository links in release notes
5c9f30a Update changelog
29bcbbc fix: include tag suffix in release artifact names
11e48ec fix: show build suffix in displayed version
3fdf0f2 / 1889d96 / a68a805 Update CHANGELOG.md
89d4950 fix(db): repair schema idempotently to avoid missing rule_action on upgrade
```

---

## 3. 文件级变更清单（已提交）

### 3.1 仅本仓库新增

| 路径 | 说明 |
|------|------|
| `.githooks/pre-commit` | 提交前调用 `scripts/precheck.ps1` |
| `scripts/install-git-hook.ps1` | 安装上述 hook |
| `scripts/precheck.ps1` | 本地 precheck（`pub get` / `build_runner` / `analyze`，可选 Windows release 构建） |
| `lib/common/subscription_decrypt.dart` | AES-128-CBC 订阅解密（与 v2rayN 同类协议） |
| `lib/common/subscription_exception.dart` | 加密订阅缺密码/错密码异常 |
| `lib/views/dashboard/widgets/start_button_base.dart` | 备份/对照用启动按钮源（当前未被 import，含 BOM，git 显示为 binary） |
| `lib/views/dashboard/widgets/start_button_upstream.dart` | 上游版启动按钮备份（含 UTF-8 BOM，**未被引用**） |

### 3.2 仅上游有、本仓库删除

| 路径 | 说明 |
|------|------|
| `android/app/google-services.json` | 停止纳入版本库；改由 CI secret 写入；`.gitignore` 忽略该文件 |

### 3.3 修改的文件

```
.github/release_template.md
.github/workflows/build.yaml
.gitignore
CHANGELOG.md
android/app/build.gradle.kts
arb/intl_{en,ja,ru,zh_CN}.arb
lib/common/common.dart
lib/common/constant.dart
lib/common/task.dart
lib/core/controller.dart
lib/database/database.dart
lib/database/generated/database.g.dart
lib/database/profiles.dart
lib/enum/enum.dart
lib/l10n/intl/messages_{en,ja,ru,zh_CN}.dart
lib/l10n/l10n.dart
lib/manager/window_manager.dart
lib/models/generated/profile.{freezed,g}.dart
lib/models/profile.dart
lib/providers/action.dart
lib/providers/state.dart
lib/state.dart
lib/views/about.dart
lib/views/dashboard/dashboard.dart
lib/views/dashboard/widgets/start_button.dart
lib/views/profiles/edit.dart
pubspec.lock
pubspec.yaml
release_telegram.py
setup.dart
```

---

## 4. 产品标识与默认配置

### 4.1 版本号（`pubspec.yaml`）

| | 上游 v0.8.93 | 本仓库 HEAD |
|--|-------------|-------------|
| `version` | `0.8.93+2026052901` | `0.8.93+14` |

本地 tag 描述为 `v0.8.93.4`（与 `+14` 的 pubspec 可能不完全一致，以实际打包/CI 注入为准）。

### 4.2 仓库与测速 URL（`lib/common/constant.dart`）

| 常量 | 上游 | 本仓库 |
|------|------|--------|
| `repository` | `chen08209/FlClash` | `fqfqgo/FlClash-new` |
| `defaultTestUrl` | `https://www.gstatic.com/generate_204` | `http://cp.cloudflare.com` |

影响应用内更新检查、关于页项目链接等。

### 4.3 Android `applicationId`

- 上游：`com.follow.clash`
- 本仓库：`com.go.class`（`android/app/build.gradle.kts`）

与上游包名不同，无法与上游 APK 互相覆盖安装。

### 4.4 产品展示名

- 窗口标题（`lib/manager/window_manager.dart`）：`FlClash for v2free-v{version}`（各平台均显示，不再仅 macOS 显示 `appName`）
- 关于页（`lib/views/about.dart`）：标题 `FlClash for v2free`；版本使用 `globalState.appDisplayVersion`（可带 `v` 前缀与 build 后缀）
- 应用描述文案（四语 ARB `desc`）：去掉「基于 ClashMeta / 开源无广告」等表述，改为更短的「多平台代理客户端…」

### 4.5 版本展示逻辑（`lib/state.dart`）

新增 `appDisplayVersion`：

- 优先 `String.fromEnvironment('APP_VERSION')`
- 否则将 `packageInfo.version` + `buildNumber` 拼成 `x.y.z.N` 形式（`+0` 或无 build 则不拼）

---

## 5. 功能差异

### 5.1 加密订阅解密

**上游无此功能。** 本仓库新增：

1. 依赖：`encrypt: ^5.0.3`（及传递依赖 `pointycastle`、`asn1lib`、`js`）
2. 协议：响应头 `subscription-encryption: true` 时，按 AES-128-CBC 解密（密钥 = MD5(密码) 的 16 字节，IV = Base64 数据前 16 字节）
3. 数据模型：`Profile.loginPassword`；DB 列 `profiles.login_password`
4. UI：配置编辑页增加「网站登录密码」输入框（可显隐）
5. 流程：`ProfilesAction.updateProfileDecrypted` 遇加密异常弹窗索要密码；导入 URL / 更新订阅 / setup 拉配置均走该路径
6. 文案：ARB 增加 `subscriptionLoginPassword` / `Hint` / `subscriptionPasswordWrongTip`（en/ja/ru/zh_CN）

### 5.2 仪表盘「启动浏览器」按钮

**上游无此功能。**

- `dashboard.dart`：FAB 改为 `LaunchBrowserButton` + `StartButton` 横排
- `LaunchBrowserButton`（同文件 `start_button.dart`）：非 Android；若未启动则先启动核心；用独立用户数据目录启动 Edge（Windows）/ Chrome（macOS/Linux），并带 `--proxy-server=http://127.0.0.1:$port`
- 用户数据目录：优先可写桌面（含 OneDrive Desktop）下的 `flclash-edge` / `flclash-chrome`
- 本地化：生成文件中有 `launchBrowser` / `launchBrowserFailed`；**ARB 源文件中未见这两键**（仅存在于 `lib/l10n/**`，与上游/ARB 源不同步，属微小但真实差异）

### 5.3 备份文件（无运行时影响）

- `start_button_upstream.dart`、`start_button_base.dart` 未被其它 Dart 文件引用，仅为对照备份。

---

## 6. 行为与逻辑差异（相对上游的细微改动）

### 6.1 代理组解析（`lib/common/task.dart` + `lib/enum/enum.dart`）

- 使用 `GroupType.parse` / `isProxyGroupType`，兼容 API 返回 `Selector` 与 yaml 风格 `select`
- 构建 group map 时补 `name ??= groupName`，成员用 `whereType<Map>` 再拷贝，避免空/类型问题
- `getProxies` 增加调试日志（`lib/core/controller.dart`）
- `updateGroups` 失败时打印 stack，并设 `LogLevel.warning`（`action.dart`）

### 6.2 Setup / 配置更新（`lib/providers/action.dart`）

- `setup` 中更新当前配置改为 `profilesAction.checkAndUpdateIfNeeded`（仅当本地 profile 文件不存在或长度为 0 才强制更新）
- 生成的 yaml 为空时直接抛 `emptyTip(profile)`，避免空配置进入核心

### 6.3 macOS 托盘流量（`lib/providers/state.dart`）

- `showTrayTitle == false` 时提前返回空 `TrayTitleState`，**避免订阅 traffic 导致高 CPU**（对应上游 issue #1644）

### 6.4 数据库迁移（`lib/database/database.dart` 等）

| | 上游 | 本仓库 |
|--|------|--------|
| `schemaVersion` | `2` | `4` |
| 升级策略 | `from < 2` 时建表 + `_migrateRules` | `from < 4` 时**按表/列是否存在幂等修复** |
| 其它 | `beforeOpen` 中有注释掉的调试迁移 | 去掉 `beforeOpen`；新增 `_migrateLoginPassword` |

说明注释写明：fork 与上游曾对 `schemaVersion` 语义不一致，故不能只靠版本号区分。

相关生成文件：`database.g.dart`、`profile.freezed.dart`、`profile.g.dart` 同步变更。

### 6.5 打包产物命名（`setup.dart`）

- 若存在 `distribute_options.yaml` 中的 `artifact_name`，传给 `flutter_distributor --artifact-name=...`
- 配合 CI「按 tag 写 version / distribute_options」，使产物名可带 `0.8.93.4` 这类后缀

### 6.6 依赖约束微调（`pubspec.yaml` / `pubspec.lock`）

- 新增：`encrypt: ^5.0.3`
- `test`: `^1.30.0` → `^1.29.0`（及相关传递版本下调，如部分 `matcher`/`test_api` 等）
- `material_color_utilities` 等 hash/版本随 lock 刷新（为兼容不同 Flutter pin）

---

## 7. CI / 发布流程差异（`.github/workflows/build.yaml` 等）

相对上游的主要改动：

1. **Android 签名**：secret 经 `env` 注入；`SERVICE_JSON` 支持 base64 或原始 JSON；校验 JSON；keystore/密码可选写入
2. **从 tag 写版本**：`Set version from tag` 将 `v0.8.93.4` 写成 `0.8.93+4`，并生成带完整 tag 的 `artifact_name`
3. **Android APK 兜底**：`flutter build apk --split-per-abi` 并拷贝到 `dist/`；另有 PowerShell fallback 收集
4. **校验 dist**：无产物则失败；`upload-artifact` 使用 `if-no-files-found: error`
5. **Telegram**：workflow 中推送步骤**注释禁用**；`release_telegram.py` 仍改为本地/公网双端点、缺 token 或失败不阻断（exit 0）
6. **F-Droid 推送**：步骤**注释禁用**（不再推到 `chen08209/FlClash-fdroid-repo`）
7. **Release 模板**：`chen08209/FlClash` → 占位符 `REPO`（运行时替换为 `github.repository`）；Linux rpm 链接从误用的 `.deb` 改为 `.rpm`
8. **changelog 生成**：使用 commit subject，并过滤 co-author 等 trailer（相关提交说明）

其它历史 CI 修复（macOS `FLUTTER_ROOT`、matrix 取消、`appdmg` 等）多已合并进当前 workflow 形态，细节见第 2 节提交列表。

---

## 8. 本地开发钩子

上游无。本仓库增加：

- `.githooks/pre-commit` → PowerShell `scripts/precheck.ps1`
- `scripts/install-git-hook.ps1` 安装 hook
- precheck：`flutter pub get`、`build_runner`、`flutter analyze --no-fatal-infos lib`；可选 `PRECHECK_RUN_WINDOWS_BUILD=1`

---

## 9. 文档与杂项

### 9.1 `CHANGELOG.md`

- 上游：保留从较旧版本起的长历史（约 900+ 行）
- 本仓库：大幅收缩，当前内容以 `v0.8.93.3` 等短条目为主（几乎重写）

### 9.2 `.gitignore`

新增：

- `/android/app/google-services.json`
- `/run_*_logs/`、`/run_*_logs.zip`
- `env.json`
- 文件末尾补换行

### 9.3 `common.dart` export

增加导出：`subscription_decrypt.dart`、`subscription_exception.dart`

---

## 10. 工作区未提交改动（相对当前 HEAD，亦相对上游）

以下 **尚未 commit**，但属于「当前树」与上游的额外差异：

### 10.1 `README.md`

- 去掉 Telegram Channel 徽章
- Downloads / Latest / GitHub 下载链接指向 `https://github.com/fqfqgo/FlClash-new/releases/`（徽章图仍部分写 `chen08209/FlClash`）

### 10.2 `core/common.go`

`updateConfig` 在 `currentConfig == nil` 时直接 `return`，避免空指针。

### 10.3 `lib/providers/action.dart` + `lib/state.dart`

新增 `ProfilesAction.ensureCurrentProfileSelected()`：

- 当订阅列表非空但 `currentProfileId` 丢失/无效时，自动选中第一个 profile
- 在 `GlobalState` 加载 profiles 后、以及 `SetupAction.setup` 开头调用  

用于修复「DB 有订阅但代理页空白」。

---

## 11. 与上游一致的部分（说明）

在已对比范围内，**Go Clash.Meta 子模块与核心主体、绝大多数 Flutter UI/业务**仍基于上游 `v0.8.93` 同步结果；未在第 3 节列出的路径，与上游 tag **无内容差异**（或未纳入本对比的 submodule 内部若另有独立历史，需单独 `git submodule` 比对）。

本对比未展开：

- `core/Clash.Meta/` 子模块内部提交是否与上游 release 打包时完全一致（需对 submodule SHA 单独核对）
- 未跟踪的本地构建产物（`build/`、`dist/`、`env.json` 等）

---

## 12. 差异速查表（按影响面）

| # | 差异 | 影响 |
|---|------|------|
| 1 | `repository` → `fqfqgo/FlClash-new` | 更新检查 / 项目链接 |
| 2 | Android `applicationId` → `com.go.class` | 安装包身份 |
| 3 | 展示名「FlClash for v2free」 | UI 文案 |
| 4 | 默认测速 URL → Cloudflare | 延迟检测 |
| 5 | 加密订阅 + `loginPassword` | 功能 / DB schema |
| 6 | 启动浏览器 FAB | 桌面端功能 |
| 7 | 版本展示带 build 后缀 | 关于页 / 窗口标题 / 产物名 |
| 8 | DB schema 2→4 幂等迁移 | 升级兼容 |
| 9 | 托盘关闭流量时跳过订阅 | macOS CPU |
| 10 | 代理组类型兼容 + 日志 | 代理列表稳定性 |
| 11 | setup 空 yaml 拒绝 / 按需更新文件 | 启动行为 |
| 12 | CI 禁 Telegram/F-Droid；产物命名；APK 兜底 | 发布流程 |
| 13 | 删除跟踪的 `google-services.json` | 安全 / CI |
| 14 | `encrypt` 依赖 | 构建依赖 |
| 15 | CHANGELOG / 描述文案精简 | 文档 |
| 16 | git precheck hooks | 开发流程 |
| 17 | （未提交）`currentConfig == nil` 防护 | 核心更新配置 |
| 18 | （未提交）自动恢复 `currentProfileId` | 代理页空白 |
| 19 | （未提交）README 指向 fork releases | 文档链接 |
| 20 | `launchBrowser*` 仅在生成 l10n、不在 ARB | 本地化源不一致 |

---

## 13. 复现对比命令

```bash
git fetch upstream refs/tags/v0.8.93:refs/tags/upstream-v0.8.93
git log --oneline upstream-v0.8.93..HEAD
git diff --stat upstream-v0.8.93...HEAD
git diff --name-status upstream-v0.8.93...HEAD
git diff   # 工作区未提交
```

上游 release 页：<https://github.com/chen08209/FlClash/releases/tag/v0.8.93>
