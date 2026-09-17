## v0.8.98

- fix: test display version without reassigning late packageInfo

- Move formatting helpers next to packageVersion and cover them as pure functions; packageInfo is late final.

- Changelog: skip

- test: cover appDisplayVersion for lib coverage floor

- Fork display-version helpers in state.dart dropped the root lib bucket below 20%; exercise them so CI stays above the floor.

- Changelog: skip

- fix: satisfy upstream lint rules after fork merge

- Drop platform barrel exports, remove material import, add password tooltip, and use subscriptionEncryptionHeader from profile update.

- Changelog: skip

- chore(test): format migration_v1_to_v2_test

- Changelog: skip

- chore(test): align database tests with fork schemaVersion 4

- Upstream expects schema 3 and 14 profile columns; this fork keeps schema 4 and loginPassword.

- Changelog: skip

- chore(changelog): record fold commit in v0.8.98 notes

- Changelog: skip

- fix: fold v0.8.97 changelog into v0.8.98 for fork tags

- The fork never published v0.8.97, so verify derives notes from v0.8.96..v0.8.98 and rejected the split upstream sections.

- fix: align fork dialogs and state with upstream APIs

- fix: restore CI build after v0.8.98 merge

- chore(release): v0.8.98

- fix(resources): refresh geo file info once the core finishes updating

- The file info was re-read as soon as the update RPC returned, before the

- core had finished writing the file, so the list kept showing the old size

- and time. Refresh when the updating key clears instead, which also covers

- automatic and core-initiated updates.

- Changelog: Refresh the geo file size and time after an update finishes

- fix(core): keep the IPC connection while a half-written frame waits on a suspended host

- Windows Modern Standby suspends the app while the Helper's Core keeps

- running, so a frame that was half written when the host stopped draining

- timed out and closed the connection, which ended the Core with it. A

- timed-out write on a half-written frame is now resumed for as long as the

- stall lasts, and only a hard error still closes. go-winio reports the

- expiry as its own ErrTimeout, so the check goes through Timeout().

- Changelog: Keep the core running while Windows sleeps with the app suspended

- chore(release): v0.8.97

- ci: split the test job into parallel jobs and cache gradle and cargo

- Run Dart, plugin, Go, Android and Rust checks as separate jobs so the

- critical path is the longest one instead of their sum. Android unit

- tests exclude the Flutter compile tasks, which used to run the native

- build hooks for every debug ABI. Gradle and cargo outputs are cached.

- Release builds keep the master channel: stable publishes no Windows or

- Linux arm64 SDK archive, so the action must clone the SDK there.

- Changelog: skip

- refactor(ui): migrate to material_ui and rework views, widgets, empty states, and localization

- Rebuild views, widgets, and pages on material_ui with typed enum labels

- replacing runtime Intl.message lookups, and retranslated ja/ru plus

- polished en/zh arb files. Includes the MATCH-TARGET rule placement

- option for profile overwrites, animated connection list changes, full

- proxy chains on connection and request items, a floating time hint

- beside the scrollbar, FAB-aware list insets, and anchored paused log

- and request lists while the buffer trims.

- The basic configuration page is grouped into Inbound, Authentication,

- and Other sections, with the credentials block shown only while

- authentication is on and blank credentials rejected after normalizing.

- Selection sheets open scrolled to the current selection, scroll bars

- stay out of blurred sheet headers and show on mobile, connections sort

- by total traffic and the list no longer crashes when a row leaves before

- it grows in, and the Android notification stop button has a switch.

- Empty states get semantic illustrations on Material shapes, and

- NullStatusSwitcher crosses between an empty state and its content with a

- fade-through and a fast exit instead of a hard cut. NullStatus scales its

- illustration in and slides the label, description, and action up in a

- stagger, the enter boxes honor the reduced-motion setting without running

- their controllers, and an empty state built while its route is still

- entering skips the entrance the route already animates. The custom rule

- editor's no-resolve and src switches write back through the rule

- provider, its delete action works, and long type, rule-set and target

- names clip with a tooltip.

- Changelog: Rework the app UI and refresh the localization

- refactor(app): rebuild core client, providers, models, database, managers, and window handling

- Rework the application layer end to end: core IPC client, providers,

- models, database, managers, and shared utilities, with riverpod 3.4.2

- and freezed 4.0.1. Keep a rejected profile selected, push the empty

- config to Core when a profile fails to build, and fall back to the

- default activity icon for package icons.

- Add opt-in proxy authentication that injects credentials into the

- generated profile and the runtime config, force-clears profile-provided

- skip-auth-prefixes so loopback stays covered, sends the credentials with

- the app's own proxied requests, and withholds the Android VPN system

- proxy while credentials are set. HelperCoreLease treats an unreachable

- Helper as confirmation once the OS reports the Core pid gone, and the

- lifecycle reconcile retries a parked stop, so the Core comes back after

- the Helper service dies. Launch arguments seed LinkManager so a clash://

- link raises a silently started window, the access control app list is

- fetched on every page entry, the desktop header matches a standard title

- bar height, and the tray icons ship as resolution-aware assets scoped per

- platform. The version moves to 0.8.97+2026090101.

- Rule.parse mirrors mihomo's ParseRulePayload: the type is

- case-insensitive, MATCH rules keep no content field, a two-field rule is

- payload without a target except for comma-payload types whose lone field

- is the target, params are matched whole, and the wildcard and

- REMATCH-NAME types the core accepts get their own actions instead of

- collapsing into DOMAIN. Window routes show, hide and toggle through one

- serialized queue and defers the macOS accessory activation switch until

- a second after the last regular switch, so hotkey bursts no longer leave

- stray Dock icons. The hotkey manager registers through rust_api instead

- of hotkey_manager, the window header restyles the caption buttons after

- the native Windows title bar, and the proxies tab keeps its tab

- controller alive while the empty state animates in. Bootstrap reads the

- Android dynamic palette from the plugin channel without the deprecated

- CorePalette, dynamic_color moves to its material_ui release,

- navigator_resizable 3.1.0 fixes an assertion when popping

- mid-transition, reorderable_grid goes, and the SDK floor rises to 3.10.

- Changelog: Rework the app layer and window handling, and add proxy authentication

- feat(desktop): rework the windows, linux, and macos runners, packaging, and native build

- Update the runner projects for the reworked plugins. The Windows runner

- asks the plugin for the running window before booting a second instance

- and forwards a clash:// link through app_links; the Linux runner routes a

- relaunch to the primary through GApplication; the macOS delegate forwards

- applicationShouldHandleReopen to the plugin. The Linux desktop entries

- claim the clash, clashmeta, and flclash schemes, and the rpm spec stops

- stripping the Core whose hash the Helper validates.

- The runner projects consume the setup build hook's artifacts: macOS drops

- the CocoaPods integration and its script phase, pins release ARCHS to the

- host, and stages the Core after the hook may have rewritten it; Windows

- and Linux copy the Core, Helper and manifest from the CMake install

- rules, and a Debug install on Windows stops a Helper that holds its exe

- open, matched by executable path so a registered release Helper keeps

- running. The deb depends on the appindicator runtime library instead of

- its development package, and the keybinder dependency and README lines

- go with hotkey_manager.

- Changelog: Rework the desktop runners, packaging, and native build

- feat(android): rework the VPN service, tile, lifecycle arbitration, and native build

- ServiceState serializes start, stop, and restart intents so the latest

- request wins, and switching between VPN and proxy mode tears the previous

- service down the way stop() does before binding the next one, so a

- system-started VpnService no longer outlives the switch. The package

- resolver drops its cache on package add, replace, and remove broadcasts

- and notifies Flutter, and the persistent notification can omit its stop

- action through an application setting synced over the shared state.

- The :core module takes the NDK clang directory and API level from the

- setup build hook input instead of ANDROID_NDK and a hardcoded API 21, and

- derives its ABI list from the target-platform property so a single-ABI

- build no longer links ABIs the hook did not produce.

- Changelog: Rework the Android VPN service and lifecycle handling

- refactor(plugins): rework desktop plugins and add rust_api, the helper service, and build hooks

- Replace window_ext with a first-party tray plugin that loads multi-size

- ICO and resolution variants, rework setup, proxy, and wifi_ssid, and add

- the Rust API plugin and the desktop Helper service.

- The Helper now also serves Linux: setup installs it as a systemd unit on

- demand from authorizeCore(), refusing a Helper binary that is not

- root-owned or a unit installed for another UID, and it listens on

- /run/flclash/helper.sock filtered by SO_PEERCRED against the installing

- UID. /start requires the Core address to be a socket owned by the owner

- UID, the listener survives accept() errors, and SIGTERM reaches the Core

- teardown. Hosts without systemd keep the setuid Core, and an AppImage

- reports TUN authorization as unavailable. The Dart-side IPC socket is

- bound at 0600 and admits only a peer whose effective uid is the app's

- own or root, since the Core connects as root under setuid or the Helper.

- Override scripts resolve a main declared with const or let.

- rust_api upgrades flutter_rust_bridge to 2.13.0 and builds through

- Native Assets: the vendored Cargokit harness and the per-platform FFI

- scaffold give way to a Dart build hook on flutter_rust_bridge_hooks, the

- crate pins its toolchain and targets in rust-toolchain.toml, and the hook

- exports the NDK libclang directory that rquickjs's bindgen needs on

- Android, probing lib and lib64 and failing with a clear message when

- neither holds it. It also replaces hotkey_manager: the crate wraps the

- tauri global-hotkey crate, keys arrive as Flutter USB HID usages,

- registration runs on the thread each platform binds it to (a

- message-loop thread on Windows, the main queue on macOS), presses stream

- back to Dart as action ids, and Linux stays X11 only and reports a

- missing DISPLAY instead of registering silently.

- setup builds the Go core and the Rust Helper through a Dart build hook in

- place of the buildkit glue. Flutter runs the hook before every platform

- build and flutter test, once per target architecture; it constructs

- CoreBuilder from the setup_hooks package, which turns the hook input into

- a BuildRequest, compiles the Core and, on Linux and Windows, the Helper

- and manifest, and reports the files it read and the directories it wrote

- as hook dependencies. setup_hooks keeps a fingerprint cache under

- .dart_tool/setup_build_cache keyed on go list -deps inputs, module files,

- build config, harness sources and toolchain versions; builds run in a

- staging directory and move into place on success, and everything the

- hook prints is mirrored into hook.log, which keeps appending when a

- rotation fails. Hook failures reach the runner as BuildError or

- InfraError, filesystem errors included.

- Changelog: Rework the desktop plugins and add the Helper service and Rust bridge

- refactor(core): rebuild the Go core IPC, hub, and ownership model

- Rebuild the IPC server, hub, tiered message queues, and the file

- ownership reclaim a setuid or Helper-spawned Core performs, and move the

- Clash.Meta fork forward. UpdateParams carries the authentication users

- the app injects at runtime.

- Changelog: Rework the core IPC and process lifecycle

- chore(agents,tool): rebuild agent config, lint gates, CI, and release tooling

- Rework .agents/, Claude/Codex config, CI workflows, lint gates and

- lint-rule tests, and the release/changelog tooling. The 5% comment

- density gate stays diff-scoped inside git hooks, where GIT_DIR outranks

- the -C the gate uses to locate the repository. The tray icon generator

- writes multi-size ICO files from the SVG sources into the per-platform

- tray asset directories. The custom code-review subagents are gone: the

- built-in /code-review never dispatched them, and the subagent model now

- lives in a user-level setting outside the repository.

- The Makefile, build_config.yaml and CI hand the Core and Helper builds to

- the setup build hook, so the buildkit launchers go, and setup.dart

- packages AppImage and rpm on arm64 with flutter_distributor pinned to the

- fork tag that normalizes packaging permissions.

- Changelog: skip

## v0.8.96

- fix: resolve Inno language file from script directory

- fix: point Inno resources at dist from repo root

- fix: stage Inno resources into dist before packaging

- fix: use forward slashes for Inno resource paths

- fix: anchor Inno resource paths to script directory

- fix: resolve Inno installer paths from repo root

- fix: build Windows installer resources

- fix: resolve Windows installer resource paths

- fix: avoid hard-coded unix socket temp path

- Optimize commented policy

- Fix whole group delay test failing on Windows

- Optimize package icon loading and connections polling

- Optimize core service

- Optimize Android TV launcher icon

- Optimize back navigation

- Optimize more details

- Fix some issues

- Optimize app layout

- Optimize focus control

- Adjust android process

## v0.8.94.1

- fix: preserve release patch suffix

- fix: compare fork release build suffixes

- Update CHANGELOG.md

- fix: fall back to TUN when system proxy fails

- docs: add upstream merge checklist for fork CI steps

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.94

- ci: disable Homebrew tap push without deploy key

- Co-authored-by: Cursor <cursoragent@cursor.com>

- docs: point README downloads to fork and remove extra install sections

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: preserve profile selection and update dependencies

- Fix macos performance issue

- Support custom global-ua

- Update core

- Optimize some details

- Fix linux silent launching not working

- Update CHANGELOG.md

## v0.8.93.4

- fix(db): repair schema idempotently to avoid missing rule_action on upgrade

- Older installs stored schemaVersion 2 with the legacy rules table, so the version-gated migration skipped adding rule_action and the proxy_groups / icon_records tables, causing a blank proxy page after upgrade. Bump to schemaVersion 4 and reconcile by table/column existence instead.

- Co-authored-by: Cursor <cursoragent@cursor.com>

- Update CHANGELOG.md

- Update CHANGELOG.md

## v0.8.93.3

- fix: show build suffix in displayed version

- Convert package build numbers back into the visible release suffix for window and About page version text.

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.93.1

## v0.8.93.2

- fix: include tag suffix in release artifact names

- Use the release tag when generating artifact names so four-part tags keep their suffix in uploaded files.

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: patch repository links in release notes

- Replace repository placeholders when generating release notes and point the downloads badge at the release page.

- Co-authored-by: Cursor <cursoragent@cursor.com>

- ui: update displayed product title

- Change the visible product title in the window header and About page only.

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.93

- fix: match upstream proxy selection after v0.8.93 sync

- Restore upstream proxy filtering and profile selection behavior while keeping encrypted subscription password prompts.

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: preserve fork profile behavior after v0.8.93 sync

- Keep current profile recovery, non-hidden proxy groups, and encrypted subscription password prompts while staying on the upstream v0.8.93 merge.

- Co-authored-by: Cursor <cursoragent@cursor.com>

- Support custom overwrite

- Support run on demand

- Optimize windows ipc

- Optimize windows arm64

- Optimize build

- Optimize some details

- Update core

## v0.8.92.13

- chore: set default test URL to http://cp.cloudflare.com

- Made-with: Cursor

- fix: use valid Dart version format 0.8.92+13

- Made-with: Cursor

- chore: point auto update to fqfqgo/FlClash-new, bump to v0.8.92.13

- Made-with: Cursor

## v0.8.92.12

- fix(macos): avoid high CPU when tray traffic is disabled (fix #1644)

- When showTrayTitle is false, trayTitleState no longer depends on trafficsProvider,

- so macOS status bar is not updated every second and NSStatusItem redraw is avoided.

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.11

- feat(release): show full version and refine about page

- Inject tag version into app display and streamline About page content and localized description for cleaner release presentation.

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.10

- fix(ci): stabilize android artifacts and release notes

- Ensure Android releases always include split ABI APKs, normalize artifact names to the current tag version, and limit release notes to current branch changes between tags.

## v0.8.92.9

- fix(ci): collect android apk into dist fallback

- Collect APK outputs into dist when setup.dart leaves dist empty in Android job, and ignore env.json locally to avoid accidental commits.

## v0.8.92.8

- feat(ui): improve subscription password UX and release notes

- Improve password entry flows by adding show/hide toggles and filling missing localized strings, while refining release note generation to keep published notes concise and focused on project changes.

## v0.8.92.7

- feat(dashboard): add launch-browser button beside start button

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(release): use commit subjects and filter co-author trailers

- Co-authored-by: Cursor <cursoragent@cursor.com>

- chore(ci): disable fdroid push step

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.6

- chore(ci): disable telegram push in release workflow

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(ci): make telegram push resilient and non-blocking

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.5

- chore(android): switch applicationId and stop tracking google-services.json

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.4

- fix(ci): validate and robustly write google-services.json

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.3

- fix(ci): make material_color_utilities constraint compatible across Flutter pins

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.2

- chore(build): refresh generated sources for CI packaging

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(dev): enforce precheck failures and align SDK-pinned dependency

- Co-authored-by: Cursor <cursoragent@cursor.com>

- feat: update subscription password flow and add local precheck hooks

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: sync generated profile model and import InputDialog

- Co-authored-by: Cursor <cursoragent@cursor.com>

## v0.8.92.1

- chore(ci): sync macOS build workflow with upstream

- Co-authored-by: Cursor <cursoragent@cursor.com>

- ci: align macOS build with upstream, remove FLUTTER_ROOT override

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(macos): use wrapper script to resolve FLUTTER_ROOT for CI Flutter Assemble

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(macos): pre-create Flutter-Generated.xcconfig in CI, robust read in Xcode script

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(macos): set FLUTTER_ROOT in Xcode Run Script from Flutter-Generated.xcconfig or which flutter

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(ci): set FLUTTER_ROOT for macOS/Linux so xcodebuild Flutter Assemble script finds macos_assemble.sh

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix(ci): android description, exit(1), appdmg optional, upload ignore empty dist, macos install appdmg

- Co-authored-by: Cursor <cursoragent@cursor.com>

- chore: print full setup errors in CI logs

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: ensure build output dirs exist before go build

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: stabilize CI builds across platforms

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: use valid Flutter version format 0.8.92+1

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: prevent matrix cancel when linux arm64 fails

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: remove secrets from if condition in Android signing step

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: remove invalid secrets check in workflow (use continue-on-error)

- Co-authored-by: Cursor <cursoragent@cursor.com>

- chore: bump version to 0.8.92.1

- Co-authored-by: Cursor <cursoragent@cursor.com>

- fix: skip telegram step when TELEGRAM_BOT_TOKEN is not set

- Co-authored-by: Cursor <cursoragent@cursor.com>

- feat: add subscription decryption support

- Co-authored-by: Cursor <cursoragent@cursor.com>

- Add sqlite store

- Optimize android quick action

- Optimize backup and restore

- Optimize more details

- Fix windows some issues

- Optimize overwrite handle

- Optimize access control page

- Optimize some details

- Fix android tile service

- Support append system DNS

- Fix some issues

- Fix some issues

- Optimize Windows service mode

- Update core

- Add android separates the core process

- Support core status check and force restart

- Optimize proxies page and access page

- Update flutter and pub dependencies

- Update go version

- Optimize more details

- Optimize desktop view

- Optimize logs, requests, connection pages

- Optimize windows tray auto hide

- Optimize some details

- Update core

- Fix windows tun issues

- Optimize android get system dns

- Optimize more details

- Support override script

- Support proxies search

- Support svg display

- Optimize config persistence

- Add some scenes auto close connections

- Update core

- Optimize more details

- Fix issues that TUN repeat failed to open.

- Fix windows service verify issues

- Add windows server mode start process verify

- Add linux deb dependencies

- Add backup recovery strategy select

- Support custom text scaling

- Optimize the display of different text scale

- Optimize windows setup experience

- Optimize startTun performance

- Optimize android tv experience

- Optimize default option

- Optimize computed text size

- Optimize hyperOS freeform window

- Add developer mode

- Update core

- Optimize more details

- Add issues template

- Optimize android vpn performance

- Add custom primary color and color scheme

- Add linux nad windows arm release

- Optimize requests and logs page

- Fix map input page delete issues

- Add rule override

- Update core

- Optimize more details

- Optimize dashboard performance

- Fix some issues

- Fix unselected proxy group delay issues

- Fix asn url issues

- Fix tab delay view issues

- Fix tray action issues

- Fix get profile redirect client ua issues

- Fix proxy card delay view issues

- Add Russian, Japanese adaptation

- Fix some issues

- Fix list form input view issues

- Fix traffic view issues

- Optimize performance

- Update core

- Optimize core stability

- Fix linux tun authority check error

- Fix some issues

- Fix scroll physics error

- Add windows storage corruption detection

- Fix core crash caused by windows resource manager restart

- Optimize logs, requests, access to pages

- Fix macos bypass domain issues

- Fix some issues

- Update popup menu

- Add file editor

- Fix android service issues

- Optimize desktop background performance

- Optimize android main process performance

- Optimize delay test

- Optimize vpn protect

- Update core

- Fix some issues

- Remake dashboard

- Optimize theme

- Optimize more details

- Update flutter version

- Support better window position memory

- Add windows arm64 and linux arm64 build script

- Optimize some details

- Remake desktop

- Optimize change proxy

- Optimize network check

- Fix fallback issues

- Optimize lots of details

- Update change.yaml

- Fix android tile issues

- Fix windows tray issues

- Support setting bypassDomain

- Update flutter version

- Fix android service issues

- Fix macos dock exit button issues

- Add route address setting

- Optimize provider view

- Update CHANGELOG.md

- Add android shortcuts

- Fix init params issues

- Fix dynamic color issues

- Optimize navigator animate

- Optimize window init

- Optimize fab

- Optimize save

- Fix the collapse issues

- Add fontFamily options

- Update core version

- Update flutter version

- Optimize ip check

- Optimize url-test

- Update release message

- Init auto gen changelog

- Fix windows tray issues

- Fix urltest issues

- Add auto changelog

- Fix windows admin auto launch issues

- Add android vpn options

- Support proxies icon configuration

- Optimize android immersion display

- Fix some issues

- Optimize ip detection

- Support android vpn ipv6 inbound switch

- Support log export

- Optimize more details

- Fix android system dns issues

- Optimize dns default option

- Fix some issues

- Update readme

- Fix build error2

- Fix build error

- Support desktop hotkey

- Support android ipv6 inbound

- Support android system dns

- fix some bugs

- Fix delete profile error

- Fix submit error 2

- Fix submit error

- Optimize DNS strategy

- Fix the problem that the tray is not displayed in some cases

- Optimize tray

- Update core

- Fix some error

- Fix tun update issues

- Add DNS override

- Fixed some bugs

- Optimize more detail

- Add Hosts override

- fix android tip error

- fix windows auto launch error

- Fix windows tray issues

- Optimize windows logic

- Optimize app logic

- Support windows administrator auto launch

- Support android close vpn

- Change flutter version

- Support profiles sort

- Support windows country flags display

- Optimize proxies page and profiles page columns

- Update flutter version

- Update version

- Update timeout time

- Update access control page

- Fix bug

- Optimize provider page

- Optimize delay test

- Support local backup and recovery

- Fix android tile service issues

- Fix linux core build error

- Add proxy-only traffic statistics

- Update core

- Optimize more details

- Add fdroid-repo

- Optimize proxies page

- Fix ua issues

- Optimize more details

- Fix windows build error

- Update app icon

- Fix desktop backup error

- Optimize request ua

- Change android icon

- Optimize dashboard

- Remove request validate certificate

- Sync core

- Fix windows error

- Fix setup.dart error

- Fix android system proxy not effective

- Add macos arm64

- Optimize proxies page

- Support mouse drag scroll

- Adjust desktop ui

- Revert "Fix android vpn issues"

- This reverts commit 891977408e6938e2acd74e9b9adb959c48c79988.

- Fix android vpn issues

- Fix android vpn issues

- Rollback partial modification

- Fix the problem that ui can't be synchronized when android vpn is occupied by an external

- Override default socksPort,port

- Fix fab issues

- Update version

- Fix the problem that vpn cannot be started in some cases

- Fix the problem that geodata url does not take effect

- Update ua

- Fix change outbound mode without check ip issues

- Separate android ui and vpn

- Fix url validate issues 2

- Add android hidden from the recent task

- Add geoip file

- Support modify geoData URL

- Fix url validate issues

- Fix check ip performance problem

- Optimize resources page

- Add ua selector

- Support modify test url

- Optimize android proxy

- Fix the error that async proxy provider could not selected the proxy

- Fix android proxy error

- Fix submit error

- Add windows tun

- Optimize android proxy

- Optimize change profile

- Update application ua

- Optimize delay test

- Fix android repeated request notification issues

- Fix memory overflow issues

- Optimize proxies expansion panel 2

- Fix android scan qrcode error

- Optimize proxies expansion panel

- Fix text error

- Optimize proxy

- Optimize delayed sorting performance

- Add expansion panel proxies page

- Support to adjust the proxy card size

- Support to adjust proxies columns number

- Fix autoRun show issues

- Fix Android 10 issues

- Optimize ip show

- Add intranet IP display

- Add connections page

- Add search in connections, requests

- Add keyword search in connections, requests, logs

- Add basic viewing editing capabilities

- Optimize update profile

- Update version

- Fix the problem of excessive memory usage in traffic usage.

- Add lightBlue theme color

- Fix start unable to update profile issues

- Fix flashback caused by process

- Add build version

- Optimize quick start

- Update system default option

- Update build.yml

- Fix android vpn close issues

- Add requests page

- Fix checkUpdate dark mode style error

- Fix quickStart error open app

- Add memory proxies tab index

- Support hidden group

- Optimize logs

- Fix externalController hot load error

- Add tcp concurrent switch

- Add system proxy switch

- Add geodata loader switch

- Add external controller switch

- Add auto gc on trim memory

- Fix android notification error

- Fix ipv6 error

- Fix android udp direct error

- Add ipv6 switch

- Add access all selected button

- Remove android low version splash

- Update version

- Add allowBypass

- Fix Android only pick .text file issues

- Fix search issues

- Fix LoadBalance, Relay load error

- Fix build.yml4

- Fix build.yml3

- Fix build.yml2

- Fix build.yml

- Add search function at access control

- Fix the issues with the profile add button to cover the edit button

- Adapt LoadBalance and Relay

- Add arm

- Fix android notification icon error

- Add one-click update all profiles

- Add expire show

- Temp remove tun mode

- Remove macos in workflow

- Change go version

- Update Version

- Fix tun unable to open

- Optimize delay test2

- Optimize delay test

- Add check ip

- add check ip request

- Fix the problem that the download of remote resources failed after GeodataMode was turned on, which caused the application to flash back.

- Fix edit profile error

- Fix quickStart change proxy error

- Fix core version

- Fix core version

- Update file_picker

- Add resources page

- Optimize more detail

- Add access selected sorted

- Fix notification duplicate creation issue

- Fix AccessControl click issue

- Fix Workflow

- Fix Linux unable to open

- Update README.md 3

- Create LICENSE

- Update README.md 2

- Update README.md

- Optimize workFlow

- optimize checkUpdate

- Fix submit error

- add WebDAV

- add Auto check updates

- Optimize more details

- optimize delayTest

- upgrade flutter version

- Update kernel

- Add import profile via QR code image

- Add compatibility mode and adapt clash scheme.

- update Version

- Reconstruction application proxy logic

- Fix Tab destroy error

- Optimize repeat healthcheck

- Optimize Direct mode ui

- Optimize Healthcheck

- Remove proxies position animation, improve performance

- Add Telegram Link

- Update healthcheck policy

- New Check URLTest

- Fix the problem of invalid auto-selection

- New Async UpdateConfig

- add changeProfileDebounce

- Update Workflow

- Fix ChangeProfile block

- Fix Release Message Error

- Update Selector 2

- Update Version

- Fix Proxies Select Error

- Fix the problem that the proxy group is empty in global mode.

- Fix the problem that the proxy group is empty in global mode.

- Add ProxyProvider2

- Add ProxyProvider

- Update Version

- Update ProxyGroup Sort

- Fix Android quickStart VpnService some problems

- Update version

- Set Android notification low importance

- Fix the issue that VpnService can't be closed correctly in special cases

- Fix the problem that TileService is not destroyed correctly in some cases

- Adjust tab animation defaults

- Add Telegram in README_zh_CN.md

- Add Telegram

- update mobile_scanner

- Initial commit

# Changelog

## v0.8.98 (2026-09-14)

**Features**

- **ui** Rework the app UI and refresh the localization (26cfbaf)
- **app** Rework the app layer and window handling, and add proxy authentication (aaf934c)
- **desktop** Rework the desktop runners, packaging, and native build (c0fcbc0)
- **android** Rework the Android VPN service and lifecycle handling (ae29f38)
- **plugins** Rework the desktop plugins and add the Helper service and Rust bridge (adf715f)
- **core** Rework the core IPC and process lifecycle (c6eaa0a)

**Bug Fixes**

- Fold v0.8.97 changelog into v0.8.98 for fork tags (edcca09)
- Align fork dialogs and state with upstream APIs (cb4f86f)
- Restore CI build after v0.8.98 merge (bbd4c46)
- **resources** Refresh the geo file size and time after an update finishes (c5bf5bd)
- **core** Keep the core running while Windows sleeps with the app suspended (60f371a)

<!-- changelog:frozen -->
<!-- Entries below predate the structured pipeline. Their wording is kept as written; only the heading and list style were normalized. -->

## v0.8.96 (2026-08-17)

- Optimize commented policy
- Fix whole group delay test failing on Windows
- Optimize package icon loading and connections polling

## v0.8.95 (2026-08-14)

- Optimize core service
- Optimize Android TV launcher icon
- Optimize back navigation
- Optimize more details
- Fix some issues
- Optimize app layout
- Optimize focus control
- Adjust Android process

## v0.8.94.1

- fix: fall back to TUN when system proxy fails

- docs: add upstream merge checklist for fork CI steps


## v0.8.94 (2026-07-11)

- Fix macOS performance issue

- Support custom global UA

- Update core

- Fix Linux silent launching

## v0.8.93.4

- fix(db): repair schema idempotently to avoid missing rule_action on upgrade

- Older installs stored schemaVersion 2 with the legacy rules table, so the version-gated migration skipped adding rule_action and the proxy_groups / icon_records tables, causing a blank proxy page after upgrade. Bump to schemaVersion 4 and reconcile by table/column existence instead.

## v0.8.93.3

## v0.8.93 (2026-05-29)

- Support custom overwrite
- Support run on demand
- Optimize windows ipc
- Optimize windows arm64
- Optimize build
- Optimize some details
- Update core

## v0.8.92 (2026-02-02)

- Add sqlite store
- Optimize android quick action
- Optimize backup and restore
- Optimize more details

## v0.8.91 (2025-12-12)

- Fix windows some issues
- Optimize overwrite handle
- Optimize access control page
- Optimize some details

## v0.8.90 (2025-10-08)

- Fix android tile service
- Support append system DNS
- Fix some issues
- Update changelog

## v0.8.89 (2025-09-27)

- Fix some issues
- Optimize Windows service mode
- Update core
- Update changelog

## v0.8.88 (2025-09-23)

- Add android separates the core process
- Support core status check and force restart
- Optimize proxies page and access page
- Update flutter and pub dependencies
- Update go version
- Optimize more details
- Update changelog

## v0.8.87 (2025-07-29)

- Optimize desktop view
- Optimize logs, requests, connection pages
- Optimize windows tray auto hide
- Optimize some details
- Update core
- Update changelog

## v0.8.86 (2025-06-15)

- Fix windows tun issues
- Optimize android get system dns
- Optimize more details
- Update changelog

## v0.8.85 (2025-06-07)

- Support override script
- Support proxies search
- Support svg display
- Optimize config persistence
- Add some scenes auto close connections
- Update core
- Optimize more details

## v0.8.84 (2025-05-01)

- Fix windows service verify issues
- Update changelog

## v0.8.83 (2025-05-01)

- Add windows server mode start process verify
- Add linux deb dependencies
- Add backup recovery strategy select
- Support custom text scaling
- Optimize the display of different text scale
- Optimize windows setup experience
- Optimize startTun performance
- Optimize android tv experience
- Optimize default option
- Optimize computed text size
- Optimize hyperOS freeform window
- Add developer mode
- Update core
- Optimize more details
- Add issues template
- Update changelog

## v0.8.82 (2025-04-18)

- Optimize android vpn performance
- Add custom primary color and color scheme
- Add linux nad windows arm release
- Optimize requests and logs page
- Fix map input page delete issues
- Update changelog

## v0.8.81 (2025-04-08)

- Add rule override
- Update core
- Optimize more details
- Update changelog

## v0.8.80 (2025-03-10)

- Optimize dashboard performance
- Fix some issues
- Fix unselected proxy group delay issues
- Fix asn url issues
- Update changelog

## v0.8.79 (2025-03-07)

- Fix tab delay view issues
- Fix tray action issues
- Fix get profile redirect client ua issues
- Fix proxy card delay view issues
- Add Russian, Japanese adaptation
- Fix some issues
- Update changelog

## v0.8.78 (2025-03-05)

- Fix list form input view issues
- Fix traffic view issues
- Update changelog

## v0.8.77 (2025-03-05)

- Optimize performance
- Update core
- Optimize core stability
- Fix linux tun authority check error
- Fix some issues
- Fix scroll physics error
- Update changelog

## v0.8.75 (2025-02-09)

- Add windows storage corruption detection
- Fix core crash caused by windows resource manager restart
- Optimize logs, requests, access to pages
- Fix macos bypass domain issues
- Update changelog

## v0.8.74 (2025-02-03)

- Fix some issues
- Update changelog

## v0.8.73 (2025-02-02)

- Update popup menu
- Add file editor
- Fix android service issues
- Optimize desktop background performance
- Optimize android main process performance
- Optimize delay test
- Optimize vpn protect
- Update changelog

## v0.8.72 (2025-01-10)

- Update core
- Fix some issues
- Update changelog

## v0.8.71 (2025-01-09)

- Remake dashboard
- Optimize theme
- Optimize more details
- Update flutter version
- Update changelog

## v0.8.70 (2024-12-09)

- Support better window position memory
- Add windows arm64 and linux arm64 build script
- Optimize some details

## v0.8.69 (2024-12-06)

- Remake desktop
- Optimize change proxy
- Optimize network check
- Fix fallback issues
- Optimize lots of details
- Update change.yaml
- Fix android tile issues
- Fix windows tray issues
- Support setting bypassDomain
- Update flutter version
- Fix android service issues
- Fix macos dock exit button issues
- Add route address setting
- Optimize provider view
- Update changelog
- Update CHANGELOG.md

## v0.8.67 (2024-11-09)

- Add android shortcuts
- Fix init params issues
- Fix dynamic color issues
- Optimize navigator animate
- Optimize window init
- Optimize fab
- Optimize save

## v0.8.66 (2024-10-26)

- Fix the collapse issues
- Add fontFamily options

## v0.8.65 (2024-10-26)

- Update core version
- Update flutter version
- Optimize ip check
- Optimize url-test

## v0.8.64 (2024-10-12)

- Update release message
- Init auto gen changelog
- Fix windows tray issues
- Fix urltest issues
- Add auto changelog
- Fix windows admin auto launch issues
- Add android vpn options
- Support proxies icon configuration
- Optimize android immersion display
- Fix some issues
- Optimize ip detection
- Support android vpn ipv6 inbound switch
- Support log export
- Optimize more details
- Fix android system dns issues
- Optimize dns default option
- Fix some issues
- Update readme

## v0.8.60 (2024-09-17)

- Fix build error2
- Fix build error
- Support desktop hotkey
- Support android ipv6 inbound
- Support android system dns
- fix some bugs

## v0.8.59 (2024-09-09)

- Fix delete profile error

## v0.8.58 (2024-09-08)

- Fix submit error 2
- Fix submit error
- Optimize DNS strategy
- Fix the problem that the tray is not displayed in some cases
- Optimize tray
- Update core
- Fix some error

## v0.8.57 (2024-09-02)

- Fix tun update issues
- Add DNS override
- Fixed some bugs
- Optimize more detail
- Add Hosts override

## v0.8.56 (2024-08-26)

- fix android tip error
- fix windows auto launch error

## v0.8.55 (2024-08-25)

- Fix windows tray issues
- Optimize windows logic
- Optimize app logic
- Support windows administrator auto launch
- Support android close vpn

## v0.8.53 (2024-08-15)

- Change flutter version
- Support profiles sort
- Support windows country flags display
- Optimize proxies page and profiles page columns

## v0.8.52 (2024-08-11)

- Update flutter version
- Update version
- Update timeout time
- Update access control page
- Fix bug

## v0.8.51 (2024-08-05)

- Optimize provider page
- Optimize delay test
- Support local backup and recovery
- Fix android tile service issues

## v0.8.49 (2024-07-31)

- Fix linux core build error
- Add proxy-only traffic statistics
- Update core
- Optimize more details
- Merge pull request #140 from txyyh/main
- 添加自建 F-Droid 仓库相关 workflow
- Rename readme fingerprint
- Rename workflow deploy repo name
- Add download guide to README
- Add push release files to fdroid-repo

## v0.8.48 (2024-07-25)

- Optimize proxies page
- Fix ua issues
- Optimize more details

## v0.8.47 (2024-07-22)

- Fix windows build error

## v0.8.46 (2024-07-22)

- Update app icon
- Fix desktop backup error
- Optimize request ua
- Change android icon
- Optimize dashboard

## v0.8.44 (2024-07-18)

- Remove request validate certificate
- Sync core

## v0.8.43 (2024-07-18)

- Fix windows error

## v0.8.42 (2024-07-18)

- Fix setup.dart error
- Fix android system proxy not effective
- Add macos arm64

## v0.8.41 (2024-07-17)

- Optimize proxies page
- Support mouse drag scroll
- Adjust desktop ui
- Revert "Fix android vpn issues"
- This reverts commit 891977408e6938e2acd74e9b9adb959c48c79988.

## v0.8.40 (2024-07-15)

- Fix android vpn issues
- Fix android vpn issues
- Rollback partial modification

## v0.8.39 (2024-07-15)

- Fix the problem that ui can't be synchronized when android vpn is occupied by an external
- Override default socksPort,port

## v0.8.38 (2024-07-14)

- Fix fab issues

## v0.8.37 (2024-07-14)

- Update version
- Fix the problem that vpn cannot be started in some cases
- Fix the problem that geodata url does not take effect

## v0.8.36 (2024-07-13)

- Update ua
- Fix change outbound mode without check ip issues
- Separate android ui and vpn
- Fix url validate issues 2
- Add android hidden from the recent task
- Add geoip file
- Support modify geoData URL

## v0.8.35 (2024-07-07)

- Fix url validate issues
- Fix check ip performance problem
- Optimize resources page

## v0.8.34 (2024-07-04)

- Add ua selector
- Support modify test url
- Optimize android proxy
- Fix the error that async proxy provider could not selected the proxy

## v0.8.33 (2024-07-01)

- Fix android proxy error
- Fix submit error
- Add windows tun
- Optimize android proxy
- Optimize change profile
- Update application ua
- Optimize delay test

## v0.8.32 (2024-06-28)

- Fix android repeated request notification issues

## v0.8.31 (2024-06-28)

- Fix memory overflow issues

## v0.8.30 (2024-06-27)

- Optimize proxies expansion panel 2
- Fix android scan qrcode error

## v0.8.29 (2024-06-27)

- Optimize proxies expansion panel
- Fix text error

## v0.8.28 (2024-06-26)

- Optimize proxy
- Optimize delayed sorting performance
- Add expansion panel proxies page
- Support to adjust the proxy card size
- Support to adjust proxies columns number
- Fix autoRun show issues
- Fix Android 10 issues
- Optimize ip show

## v0.8.26 (2024-06-22)

- Add intranet IP display
- Add connections page
- Add search in connections, requests
- Add keyword search in connections, requests, logs
- Add basic viewing editing capabilities
- Optimize update profile

## v0.8.25 (2024-06-19)

- Update version
- Fix the problem of excessive memory usage in traffic usage.
- Add lightBlue theme color
- Fix start unable to update profile issues
- Fix flashback caused by process

## v0.8.23 (2024-06-16)

- Add build version
- Optimize quick start
- Update system default option

## v0.8.22 (2024-06-16)

- Update build.yml
- Fix android vpn close issues
- Add requests page
- Fix checkUpdate dark mode style error
- Fix quickStart error open app
- Add memory proxies tab index
- Support hidden group
- Optimize logs
- Fix externalController hot load error

## v0.8.21 (2024-06-13)

- Add tcp concurrent switch
- Add system proxy switch
- Add geodata loader switch
- Add external controller switch
- Add auto gc on trim memory
- Fix android notification error

## v0.8.20 (2024-06-12)

- Fix ipv6 error
- Fix android udp direct error
- Add ipv6 switch
- Add access all selected button
- Remove android low version splash

## v0.8.19 (2024-06-10)

- Update version
- Add allowBypass
- Fix Android only pick .text file issues

## v0.8.18 (2024-06-09)

- Fix search issues

## v0.8.17 (2024-06-09)

- Fix LoadBalance, Relay load error
- Fix build.yml4
- Fix build.yml3
- Fix build.yml2
- Fix build.yml
- Add search function at access control
- Fix the issues with the profile add button to cover the edit button
- Adapt LoadBalance and Relay
- Add arm
- Fix android notification icon error

## v0.8.16 (2024-06-08)

- Add one-click update all profiles
- Add expire show

## v0.8.15 (2024-06-06)

- Temp remove tun mode
- Remove macos in workflow
- Change go version

## v0.8.14 (2024-06-06)

- Update Version
- Fix tun unable to open

## v0.8.13 (2024-06-06)

- Optimize delay test2
- Optimize delay test
- Add check ip
- add check ip request

## v0.8.12 (2024-06-06)

- Fix the problem that the download of remote resources failed after GeodataMode was turned on, which caused the
  application to flash back.
- Fix edit profile error
- Fix quickStart change proxy error
- Fix core version

## v0.8.10 (2024-06-05)

- Fix core version

## v0.8.9 (2024-06-05)

- Update file_picker
- Add resources page
- Optimize more detail
- Add access selected sorted
- Fix notification duplicate creation issue
- Fix AccessControl click issue

## v0.8.7 (2024-05-31)

- Fix Workflow
- Fix Linux unable to open
- Update README.md 3
- Create LICENSE
- Update README.md 2
- Update README.md
- Optimize workFlow

## v0.8.6 (2024-05-31)

- optimize checkUpdate

## v0.8.5 (2024-05-30)

- Fix submit error

## v0.8.4 (2024-05-30)

- add WebDAV
- add Auto check updates
- Optimize more details
- optimize delayTest

## v0.8.2 (2024-05-15)

- upgrade flutter version

## v0.8.1 (2024-05-15)

- Update kernel
- Add import profile via QR code image

## v0.8.0 (2024-05-11)

- Add compatibility mode and adapt clash scheme.

## v0.7.14 (2024-05-07)

- update Version
- Reconstruction application proxy logic

## v0.7.13 (2024-05-06)

- Fix Tab destroy error

## v0.7.12 (2024-05-06)

- Optimize repeat healthcheck

## v0.7.11 (2024-05-06)

- Optimize Direct mode ui

## v0.7.10 (2024-05-06)

- Optimize Healthcheck
- Remove proxies position animation, improve performance
- Add Telegram Link
- Update healthcheck policy
- New Check URLTest
- Fix the problem of invalid auto-selection

## v0.7.8 (2024-05-05)

- New Async UpdateConfig
- add changeProfileDebounce
- Update Workflow
- Fix ChangeProfile block
- Fix Release Message Error

## v0.7.7 (2024-05-04)

- Update Selector 2

## v0.7.6 (2024-05-04)

- Update Version
- Fix Proxies Select Error

## v0.7.5 (2024-05-03)

- Fix the problem that the proxy group is empty in global mode.
- Fix the problem that the proxy group is empty in global mode.

## v0.7.4 (2024-05-03)

- Add ProxyProvider2

## v0.7.3 (2024-05-03)

- Add ProxyProvider
- Update Version
- Update ProxyGroup Sort
- Fix Android quickStart VpnService some problems

## v0.7.1 (2024-05-01)

- Update version
- Set Android notification low importance
- Fix the issue that VpnService can't be closed correctly in special cases
- Fix the problem that TileService is not destroyed correctly in some cases
- Adjust tab animation defaults
- Add Telegram in README_zh_CN.md
- Add Telegram

## v0.7.0 (2024-04-30)

- update mobile_scanner
- Initial commit
