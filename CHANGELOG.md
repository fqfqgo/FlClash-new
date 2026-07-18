## v0.8.94.1

- fix: fall back to TUN when system proxy fails

- docs: add upstream merge checklist for fork CI steps



## v0.8.94

- Fix macOS performance issue

- Support custom global UA

- Update core

- Fix Linux silent launching

## v0.8.93.4

- fix(db): repair schema idempotently to avoid missing rule_action on upgrade

- Older installs stored schemaVersion 2 with the legacy rules table, so the version-gated migration skipped adding rule_action and the proxy_groups / icon_records tables, causing a blank proxy page after upgrade. Bump to schemaVersion 4 and reconcile by table/column existence instead.

## v0.8.93.3

- Optimize build

- Optimize some details

- Update core

