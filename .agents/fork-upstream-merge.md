# Fork 合并上游检查清单

合并 [chen08209/FlClash](https://github.com/chen08209/FlClash) 新 tag 后，除业务功能外必须核对 **CI / 发布** 定制，避免 release 在 upload 阶段失败。

## 必查：`.github/workflows/build.yaml`（upload job）

上游常会重新启用以下步骤；本 fork **无对应 secret / 仓库**，必须保持 **注释禁用**：

| 步骤 | 失败原因 |
|------|----------|
| `Push to telegram` | 无 `TELEGRAM_BOT_TOKEN` |
| `Create Homebrew Cask Source Dir` + `Push to Homebrew tap` | 无 `HOMEBREW_SSH_DEPLOY_KEY`，且目标是 `chen08209/homebrew-tap` |
| `Push to fdroid repo` | 无 `SSH_DEPLOY_KEY`，且目标是上游 F-Droid 仓库 |

**2026-07-15 实例**：合并 v0.8.94 后未禁用 Homebrew push，tag 发布报错  
`API_TOKEN_GITHUB and SSH_DEPLOY_KEY are empty`。

### 本 fork 应保留的 CI 差异（相对上游）

- `release_template.md` / `Patch release.md`：使用 `REPO` 占位符 → `fqfqgo/FlClash-new`
- Android 签名：`SERVICE_JSON` 支持 base64 或原始 JSON，并校验 JSON
- `Set version from tag`、APK 兜底收集、`if-no-files-found: error` 等 fork 构建加固
- **不要**恢复推送到 `chen08209` 的 Telegram / Homebrew / F-Droid
- `windows/packaging/exe/make_config.yaml` 的图标/语言文件路径必须用正斜杠（`../windows/...`），不能用反斜杠。GitHub Actions 工作区是 `D:\a\...`，Inno Setup 6.7.1 会把路径里的 `\a`、`\resources` 的 `\r` 当成转义，报 `The filename, directory name, or volume label syntax is incorrect`

## 必查：发布版本与应用内更新

本 fork 使用四段 release tag 表达 build 后缀，例如 `v0.8.94.1`。上游合并时不得遗漏以下**成套**逻辑：

| 位置 | 必须保持的规则 |
|------|----------------|
| `build.yaml` 的 `Set version from tag` | `vX.Y.Z` → `X.Y.Z+0`；`vX.Y.Z.N` → `X.Y.Z+N` |
| `lib/common/request.dart` | 检查更新必须使用本地 `packageInfo.version` **和** `buildNumber` |
| `lib/common/utils.dart` | release tag 的四段形式必须规范化为 Flutter build 版本后再比较 |
| `test/common/utils_test.dart` | 覆盖 base tag 与四段 tag 的更新比较 |
| `lib/state.dart` | 关于页/窗口展示版本应保留 build 后缀 |
| `setup.dart` 与 `distribute_options.yaml` | 发布产物名应保留完整 tag 后缀 |

**2026-07-18 实例**：合并 v0.8.94 后，仅保留了产物名和展示版本；`checkForUpdate()` 忽略 `v0.8.94.1` 的第四段及本地 build number，导致 v0.8.94 客户端误报“当前应用已经是最新版”。此前 v0.8.93.x 已处理过同类问题（例如 `79a8702`、`0248332`、`006c20e`、`29bcbbc`、`11e48ec`），同步上游时遗漏了运行时比较部分。

**版本映射**：应用内将 build number 原样展示为第四段，因此 build number 必须与 tag 后缀一致；不可额外加 `1`，否则 `vX.Y.Z.1` 会显示为 `vX.Y.Z.2`。

> 已发布的旧客户端无法通过服务端修复其内置比较逻辑。修复发布后，如需让旧客户端自动发现更新，应提高 `X.Y.Z` 中的 patch 版本（例如 `v0.8.95`），不能只增加第四段。

## 其它常见保留项（功能）

详见仓库根目录 `DIFF_vs_upstream_v0.8.93.md`（合并后可更新为新版本对照），主要包括：

- `lib/common/constant.dart`：`repository`、`defaultTestUrl`
- `android/app/build.gradle.kts`：`applicationId = "com.go.class"`
- 加密订阅、`LaunchBrowserButton`、DB 幂等迁移、`appDisplayVersion` 等

### v0.8.96 架构迁移位置

- `ProfilesAction` 和 `SetupAction` 已拆到 `lib/providers/actions/`；加密订阅交互、当前订阅兜底、空配置拒绝及系统代理失败回退 TUN 必须在拆分文件中保留。
- 桌面 core 启动已拆到 `lib/core/desktop/`；Unix socket 必须继续使用 `unix_ipc.dart` 选择可写目录，并将该目录作为 `TMPDIR` 传给直接启动的 core。
- Linux/macOS 系统代理实现已拆到 `plugins/proxy/lib/src/`；设置后的读回验证必须随实现迁移，Windows 继续在原生插件中验证。
- `lib/views/dashboard/widgets/start_button_base.dart` 与 `start_button_upstream.dart` 只是未引用的旧备份，已删除，避免非 UTF-8 内容阻塞代码生成。

## 合并后建议

```bash
git fetch upstream refs/tags/vX.Y.Z:refs/tags/upstream-vX.Y.Z
git merge --no-ff upstream-vX.Y.Z
# 解决冲突后对照本文件与 DIFF 文档
flutter pub get && flutter test
```
