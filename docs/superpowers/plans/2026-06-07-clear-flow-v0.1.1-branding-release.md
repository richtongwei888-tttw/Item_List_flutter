# Clear Flow v0.1.1 Branding Release Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship `v0.1.1+2` with the approved A3 folded-page identity, reliable immediate reminders, and verified Android release artifacts.

**Architecture:** Keep the existing Flutter application architecture unchanged. Generate one deterministic vector master mark, derive platform raster resources from it, and configure Android/iOS native launch surfaces directly. Preserve notification reliability in the domain policy and outbox processor, with regression tests at both boundaries.

**Tech Stack:** Flutter, Dart, Android resource XML, iOS asset catalogs/storyboards, SVG/PNG asset generation, Drift, `flutter_local_notifications`, Git.

---

### Task 1: Finalize the three v0.1.0 regression fixes

**Files:**
- Modify: `lib/features/tasks/presentation/widgets/task_card.dart`
- Modify: `lib/features/tasks/presentation/task_form_screen.dart`
- Modify: `lib/features/tasks/domain/reminder_policy.dart`
- Modify: `lib/features/tasks/application/notification_outbox_processor.dart`
- Test: `test/features/tasks/presentation/task_card_test.dart`
- Test: `test/features/tasks/presentation/task_form_screen_test.dart`
- Test: `test/features/tasks/domain/task_rules_test.dart`
- Test: `test/features/tasks/application/notification_outbox_processor_test.dart`

- [ ] **Step 1: Verify focused regression tests**

Run:

```powershell
flutter test test/features/tasks/presentation/task_card_test.dart test/features/tasks/presentation/task_form_screen_test.dart test/features/tasks/domain/task_rules_test.dart test/features/tasks/application/notification_outbox_processor_test.dart
```

Expected: all tests pass, including no-note actions, date-only immediate prompt, five-second lead time, and stale immediate reminder rebasing.

- [ ] **Step 2: Review the production diff**

Run:

```powershell
git diff --check
git diff -- lib test
```

Expected: no whitespace errors and no unrelated behavior changes.

- [ ] **Step 3: Commit regression fixes**

```powershell
git add lib test
git commit -m "fix: harden task actions and immediate reminders"
```

### Task 2: Create the A3 master artwork

**Files:**
- Create: `assets/branding/clear_flow_mark.svg`
- Create: `assets/branding/clear_flow_mark_1024.png`
- Create: `assets/branding/clear_flow_foreground.png`
- Create: `assets/branding/clear_flow_splash.png`

- [ ] **Step 1: Create the vector master**

Build a 1024 x 1024 SVG containing:

```xml
<svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
  <rect width="1024" height="1024" rx="224" fill="#607A63"/>
  <path d="..." fill="#FFFDF7"/>
  <path d="..." fill="#E7EEE2"/>
  <path d="..." stroke="#607A63" stroke-width="42" stroke-linecap="round"/>
  <path d="..." stroke="#E7674C" stroke-width="72" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

The paper silhouette must include a visible folded upper-right corner. Use no text, gradients, transparency-dependent shadows, or details thinner than 32 px.

- [ ] **Step 2: Render deterministic PNG masters**

Render:

- Full icon: 1024 x 1024, opaque sage background.
- Adaptive foreground: 1024 x 1024, transparent outside the paper/check artwork with Android safe-zone padding.
- Splash mark: 512 x 512, transparent outside the full rounded-square mark.

- [ ] **Step 3: Inspect the masters**

Verify:

- All corners of the full icon are opaque.
- Foreground and splash PNGs have alpha channels.
- The paper fold and coral check remain visible at 48 x 48.
- No unintended text, edge fringe, or raster blur.

### Task 3: Apply Android branding

**Files:**
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `android/app/src/main/res/drawable/launch_background.xml`
- Modify: `android/app/src/main/res/values/styles.xml`
- Create: `android/app/src/main/res/values/colors.xml`
- Create: `android/app/src/main/res/values-v31/styles.xml`
- Create: `android/app/src/main/res/drawable/launch_mark.png`
- Create: `android/app/src/main/res/drawable-v31/launch_mark.png`
- Create: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- Create: `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`
- Create: `android/app/src/main/res/drawable/ic_launcher_foreground.png`
- Modify: `android/app/src/main/res/mipmap-*/ic_launcher.png`

- [ ] **Step 1: Set the native display name**

Set:

```xml
<application android:label="清序" ...>
```

- [ ] **Step 2: Install legacy and adaptive icons**

Generate legacy PNGs at 48, 72, 96, 144, and 192 px. Configure adaptive icons with `#607A63` background and the transparent A3 foreground.

- [ ] **Step 3: Configure launch visuals**

Use `#F7F5EF` for the native window background. Center the A3 mark on pre-Android 12 launch backgrounds and configure Android 12 `windowSplashScreenBackground` and `windowSplashScreenAnimatedIcon`.

- [ ] **Step 4: Validate Android resources**

Run:

```powershell
flutter build apk --debug
```

Expected: Gradle resource merge and debug APK build succeed.

### Task 4: Apply iOS branding

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `ios/Runner/Base.lproj/LaunchScreen.storyboard`
- Modify: `ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png`
- Modify: `ios/Runner/Assets.xcassets/LaunchImage.imageset/*.png`
- Modify: `ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json`

- [ ] **Step 1: Set the iOS display name**

Set both `CFBundleDisplayName` and `CFBundleName` to `清序`, and retain valid XML for the photo-library usage description.

- [ ] **Step 2: Generate the complete app icon set**

Derive every filename listed in `AppIcon.appiconset/Contents.json` from the opaque 1024 px master. No icon may contain alpha.

- [ ] **Step 3: Configure the launch storyboard**

Use `#F7F5EF` as the launch background and center the A3 launch image with aspect-fit constraints.

- [ ] **Step 4: Validate iOS assets statically**

Parse both asset-catalog JSON files, verify all referenced files exist with the expected dimensions, and parse `Info.plist` as XML.

### Task 5: Version and release documentation

**Files:**
- Modify: `VERSION`
- Modify: `pubspec.yaml`
- Modify or Create: `CHANGELOG.md`

- [ ] **Step 1: Bump the release version**

Set:

```text
VERSION: 0.1.1
pubspec.yaml: version: 0.1.1+2
```

- [ ] **Step 2: Record release changes**

Add `0.1.1` notes covering A3 branding, task-card actions, date-only reminder handling, and reliable immediate scheduling.

- [ ] **Step 3: Verify version consistency**

Run:

```powershell
rg -n "0\.1\.1|0\.1\.0" VERSION pubspec.yaml CHANGELOG.md
```

Expected: current release metadata uses `0.1.1+2`; historical changelog entries may retain `0.1.0`.

### Task 6: Full automated verification

**Files:**
- Verify all modified files.

- [ ] **Step 1: Verify formatting**

```powershell
dart format --output=none --set-exit-if-changed lib test
```

Expected: exit code 0 and zero changed files.

- [ ] **Step 2: Run static analysis**

```powershell
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Run the complete test suite**

```powershell
flutter test
```

Expected: all tests pass.

- [ ] **Step 4: Build Android release APK**

```powershell
flutter build apk --release
```

Expected: `build/app/outputs/flutter-apk/app-release.apk` exists and build exits 0.

### Task 7: Huawei HarmonyOS 4.2 device acceptance

**Files:**
- Verify installed application and device state.

- [ ] **Step 1: Restore the Huawei debug transport**

```powershell
& 'C:\Program Files (x86)\HiSuite\hwtools\hwtransport.exe' devices -l
```

Expected: serial `33Z0224509062978` appears as `device`.

- [ ] **Step 2: Install the release APK**

```powershell
& 'C:\Program Files (x86)\HiSuite\hwtools\hwtransport.exe' install -r build\app\outputs\flutter-apk\app-release.apk
```

Expected: `Success`, with existing task data retained.

- [ ] **Step 3: Verify visual identity**

Confirm launcher name “清序”, A3 launcher icon, warm-ivory splash, and profile version `0.1.1 (2)`.

- [ ] **Step 4: Verify reminder delivery**

Create a date-only task after 09:00, choose “立即提醒”, leave the app, and confirm the local notification appears. Inspect `dumpsys alarm` and `dumpsys notification` if delivery does not appear.

- [ ] **Step 5: Verify persistence**

Force-stop and relaunch the app. Confirm previously created tasks remain.

### Task 8: Commit, tag, and publish

**Files:**
- Commit all release changes.

- [ ] **Step 1: Review the release diff**

```powershell
git status --short
git diff --check
git diff --stat
```

Expected: only v0.1.1 implementation, assets, tests, and release metadata are present.

- [ ] **Step 2: Commit the release**

```powershell
git add .
git commit -m "release: v0.1.1"
```

- [ ] **Step 3: Create the annotated tag**

```powershell
git tag -a v0.1.1 -m "Clear Flow v0.1.1"
```

- [ ] **Step 4: Push branch and tag**

```powershell
git push origin main
git push origin v0.1.1
```

Expected: GitHub accepts both pushes and `origin/main` points to the release commit.
