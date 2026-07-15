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

## 其它常见保留项（功能）

详见仓库根目录 `DIFF_vs_upstream_v0.8.93.md`（合并后可更新为新版本对照），主要包括：

- `lib/common/constant.dart`：`repository`、`defaultTestUrl`
- `android/app/build.gradle.kts`：`applicationId = "com.go.class"`
- 加密订阅、`LaunchBrowserButton`、DB 幂等迁移、`appDisplayVersion` 等

## 合并后建议

```bash
git fetch upstream refs/tags/vX.Y.Z:refs/tags/upstream-vX.Y.Z
git merge --no-ff upstream-vX.Y.Z
# 解决冲突后对照本文件与 DIFF 文档
flutter pub get && flutter test
```
