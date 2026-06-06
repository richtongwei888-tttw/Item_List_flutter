# Clear Flow v0.1.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and release the first complete offline Flutter mobile version of Clear Flow as `0.1.0+1`, including task management, sorting, statistics, profile, durable local storage, local reminders, rollback behavior, animations, and visible version information.

**Architecture:** Use feature-first Flutter modules with Riverpod for dependency injection and state, Drift/SQLite as the single source of truth, and a database-backed notification outbox for reliable local reminder scheduling. UI code depends on application services and immutable domain models; platform plugins remain behind small gateways so time, persistence, notifications, files, and package information are testable.

**Tech Stack:** Flutter 3.41.5, Dart 3.11.3, Material 3, `flutter_riverpod 3.3.1`, `drift 2.33.0`, `drift_flutter 0.3.0`, `flutter_local_notifications 21.0.0`, `timezone 0.11.0`, `flutter_timezone 5.1.0`, `image_picker 1.2.2`, `path_provider 2.1.5`, `package_info_plus 10.1.0`, `intl 0.20.2`, `uuid 4.5.3`, `clock 1.1.2`, `drift_dev 2.33.0`, and `build_runner 2.15.0`.

---

## Version Milestones

- `v0.0.1-design`: approved design baseline, already tagged and pushed.
- `0.1.0+1`: first complete runnable offline MVP.
- `v0.1.0`: annotated Git tag created only after all verification commands pass.

Development commits do not increment the public version. The release task updates `VERSION`, `pubspec.yaml`, `CHANGELOG.md`, the in-app version display, the Git tag, and GitHub together.

## File Map

```text
lib/
  main.dart
  app/
    app.dart
    app_bootstrap.dart
    app_lifecycle_observer.dart
    app_theme.dart
  core/
    errors/app_failure.dart
    time/app_clock.dart
    time/date_time_extensions.dart
  data/
    database/app_database.dart
    database/app_database.g.dart
    database/tables.dart
    notifications/local_notification_gateway.dart
    profile/avatar_file_store.dart
    version/package_version_reader.dart
  features/
    tasks/
      domain/task.dart
      domain/task_filter.dart
      domain/task_priority.dart
      domain/reminder_offset.dart
      domain/reminder_sync_status.dart
      domain/due_status.dart
      domain/task_sorter.dart
      domain/reminder_policy.dart
      application/task_repository.dart
      application/notification_gateway.dart
      application/task_service.dart
      application/notification_outbox_processor.dart
      presentation/task_providers.dart
      presentation/task_list_screen.dart
      presentation/task_form_screen.dart
      presentation/widgets/task_card.dart
      presentation/widgets/smart_summary_card.dart
    statistics/
      domain/task_statistics.dart
      presentation/statistics_screen.dart
    profile/
      domain/user_profile.dart
      application/profile_repository.dart
      presentation/profile_providers.dart
      presentation/profile_screen.dart
    shell/
      presentation/app_shell.dart
test/
  core/
  data/
  features/
integration_test/
  offline_task_flow_test.dart
tool/
  release.ps1
.github/workflows/flutter.yml
CHANGELOG.md
VERSION
```

### Task 1: Scaffold Flutter Project and Lock the Toolchain

**Files:**
- Create: Flutter Android/iOS project files in repository root
- Modify: `pubspec.yaml`
- Modify: `.gitignore`
- Create: `analysis_options.yaml`
- Replace: `test/widget_test.dart`
- Create: `CHANGELOG.md`

- [ ] **Step 1: Generate the Flutter project**

Run:

```powershell
flutter create --platforms=android,ios --org com.richtongwei888 .
```

Expected: Flutter creates `android/`, `ios/`, `lib/`, `test/`, and `pubspec.yaml` without changing `docs/`.

- [ ] **Step 2: Set the application identity and dependencies**

Set the relevant `pubspec.yaml` content to:

```yaml
name: item_list_flutter
description: Clear Flow offline task manager.
publish_to: none
version: 0.1.0+1

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  clock: ^1.1.2
  drift: ^2.33.0
  drift_flutter: ^0.3.0
  flutter_local_notifications: ^21.0.0
  flutter_riverpod: ^3.3.1
  flutter_timezone: ^5.1.0
  image_picker: ^1.2.2
  intl: ^0.20.2
  package_info_plus: ^10.1.0
  path_provider: ^2.1.5
  timezone: ^0.11.0
  uuid: ^4.5.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  build_runner: ^2.15.0
  drift_dev: ^2.33.0
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
```

- [ ] **Step 3: Add the first failing smoke test**

Replace `test/widget_test.dart` with:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app.dart';

void main() {
  testWidgets('shows the Clear Flow task shell', (tester) async {
    await tester.pumpWidget(const ClearFlowApp());

    expect(find.text('任务'), findsOneWidget);
    expect(find.text('统计'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Verify the smoke test fails for the expected reason**

Run:

```powershell
flutter pub get
flutter test test/widget_test.dart
```

Expected: FAIL because `lib/app/app.dart` and `ClearFlowApp` do not exist.

- [ ] **Step 5: Add the minimal app shell**

Create `lib/app/app.dart`:

```dart
import 'package:flutter/material.dart';

class ClearFlowApp extends StatelessWidget {
  const ClearFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const SizedBox.shrink(),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.check_circle_outline), label: '任务'),
            NavigationDestination(icon: Icon(Icons.donut_large), label: '统计'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
          ],
        ),
      ),
    );
  }
}
```

Replace `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:item_list_flutter/app/app.dart';

void main() {
  runApp(const ClearFlowApp());
}
```

- [ ] **Step 6: Verify scaffold health**

Run:

```powershell
dart format .
flutter analyze
flutter test test/widget_test.dart
```

Expected: analyzer reports no issues and the smoke test passes.

- [ ] **Step 7: Record and push the scaffold**

```powershell
git add .
git commit -m "chore: scaffold Clear Flow Flutter app"
git push origin main
```

### Task 2: Implement Immutable Task Domain Rules

**Files:**
- Create: `lib/core/time/app_clock.dart`
- Create: `lib/features/tasks/domain/task.dart`
- Create: `lib/features/tasks/domain/task_filter.dart`
- Create: `lib/features/tasks/domain/task_priority.dart`
- Create: `lib/features/tasks/domain/reminder_offset.dart`
- Create: `lib/features/tasks/domain/reminder_sync_status.dart`
- Create: `lib/features/tasks/domain/due_status.dart`
- Create: `lib/features/tasks/domain/task_sorter.dart`
- Create: `lib/features/tasks/domain/reminder_policy.dart`
- Test: `test/features/tasks/domain/task_rules_test.dart`

- [ ] **Step 1: Write failing domain tests**

Create `test/features/tasks/domain/task_rules_test.dart` with tests that assert:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/features/tasks/domain/due_status.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_policy.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';
import 'package:item_list_flutter/features/tasks/domain/task_sorter.dart';

void main() {
  final now = DateTime(2026, 6, 6, 10);

  test('date-only task becomes overdue after its local day ends', () {
    final task = Task.test(dueDate: DateTime(2026, 6, 5));
    expect(DueStatus.from(task, now), DueStatus.overdue);
  });

  test('same due moment sorts high priority before normal priority', () {
    final due = DateTime(2026, 6, 7, 12);
    final high = Task.test(id: 'high', dueDate: due, priority: TaskPriority.high);
    final normal = Task.test(id: 'normal', dueDate: due);
    expect(TaskSorter.pending([normal, high], now).map((task) => task.id), ['high', 'normal']);
  });

  test('timed reminder defaults to two hours before due time', () {
    final task = Task.test(dueDate: DateTime(2026, 6, 6, 18));
    expect(
      ReminderPolicy.calculate(task, ReminderOffset.twoHours, now),
      DateTime(2026, 6, 6, 16),
    );
  });

  test('date-only reminder defaults to 09:00 on due date', () {
    final task = Task.test(dueDate: DateTime(2026, 6, 7), hasDueTime: false);
    expect(
      ReminderPolicy.calculate(task, ReminderOffset.dateAtNine, now),
      DateTime(2026, 6, 7, 9),
    );
  });
}
```

- [ ] **Step 2: Verify the tests fail**

Run:

```powershell
flutter test test/features/tasks/domain/task_rules_test.dart
```

Expected: FAIL because the domain types do not exist.

- [ ] **Step 3: Implement the domain model**

Create `task_priority.dart`:

```dart
enum TaskPriority { low, normal, high }
```

Create `task_filter.dart`:

```dart
enum TaskFilter { pending, completed, all }
```

Create `reminder_offset.dart`:

```dart
enum ReminderOffset {
  atTime,
  tenMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
  oneDay,
  dateAtNine,
}
```

Create `reminder_sync_status.dart`:

```dart
enum ReminderSyncStatus { synced, pending, failed }
```

Create `task.dart` as an immutable value with all fields from the design spec, a validated `create` factory, `copyWith`, `dueAt`, and a `Task.test` test factory. Enforce title length `1..100`, note length `0..2000`, and `completedAt != null` only when completed.

- [ ] **Step 4: Implement due status, sorting, and reminder calculations**

`DueStatus.from` must classify overdue, today, tomorrow, withinThreeDays, later, and none. `TaskSorter.pending` must apply due bucket, due time, priority, and `createdAt` tie-breakers. `ReminderPolicy.calculate` must return `null` for disabled reminders, missing due dates, overdue due moments, or reminder moments already in the past.

- [ ] **Step 5: Verify domain behavior**

Run:

```powershell
dart format lib/core lib/features/tasks/domain test/features/tasks/domain
flutter test test/features/tasks/domain/task_rules_test.dart
flutter analyze
```

Expected: all domain tests pass and analyzer reports no issues.

- [ ] **Step 6: Commit and push**

```powershell
git add lib/core lib/features/tasks/domain test/features/tasks/domain
git commit -m "feat: add task domain rules"
git push origin main
```

### Task 3: Add Drift Database and Repository

**Files:**
- Create: `lib/data/database/tables.dart`
- Create: `lib/data/database/app_database.dart`
- Generate: `lib/data/database/app_database.g.dart`
- Create: `lib/features/tasks/application/task_repository.dart`
- Test: `test/data/database/app_database_test.dart`

- [ ] **Step 1: Write failing repository tests**

Create an in-memory Drift test covering insert, update, complete, restore, delete, persistence mapping, and notification job creation:

```dart
test('saving a reminder task writes task and schedule job atomically', () async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  final repository = DriftTaskRepository(database);
  final task = Task.test(
    id: 'task-1',
    dueDate: DateTime(2026, 6, 7, 12),
    reminderEnabled: true,
  );

  await repository.save(task);

  expect(await repository.findById('task-1'), task);
  expect((await database.pendingNotificationJobs()).single.operation, 'schedule');
});
```

- [ ] **Step 2: Verify repository tests fail**

Run:

```powershell
flutter test test/data/database/app_database_test.dart
```

Expected: FAIL because database and repository classes do not exist.

- [ ] **Step 3: Define Drift tables**

Define:

```dart
class TaskRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get dueDateTime => dateTime().nullable()();
  BoolColumn get hasDueTime => boolean().withDefault(const Constant(false))();
  TextColumn get priority => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get reminderOffset => text().nullable()();
  TextColumn get reminderSyncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class NotificationJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text()();
  TextColumn get operation => text()();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class ProfileRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get displayName => text().withDefault(const Constant('用户'))();
  TextColumn get avatarPath => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PreferenceRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get defaultFilter => text().withDefault(const Constant('pending'))();
  BoolColumn get animationsEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationPermissionPrompted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
```

- [ ] **Step 4: Implement database and repository transactions**

`DriftTaskRepository.save`, `setCompleted`, `restore`, and `delete` must use `database.transaction`. Each task mutation must replace any unprocessed job for that task and add exactly one latest `schedule` or `cancel` job.

- [ ] **Step 5: Generate Drift code**

Run:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Expected: `lib/data/database/app_database.g.dart` is generated.

- [ ] **Step 6: Verify persistence**

Run:

```powershell
dart format lib/data/database lib/features/tasks/application test/data/database
flutter test test/data/database/app_database_test.dart
flutter analyze
```

Expected: database tests pass with no analyzer issues.

- [ ] **Step 7: Commit generated code and push**

```powershell
git add lib/data/database lib/features/tasks/application/task_repository.dart test/data/database
git commit -m "feat: persist tasks with notification outbox"
git push origin main
```

### Task 4: Implement Task Service and Failure Rollback

**Files:**
- Create: `lib/core/errors/app_failure.dart`
- Create: `lib/features/tasks/application/notification_gateway.dart`
- Create: `lib/features/tasks/application/task_service.dart`
- Create: `lib/features/tasks/application/notification_outbox_processor.dart`
- Test: `test/features/tasks/application/task_service_test.dart`
- Test: `test/features/tasks/application/notification_outbox_processor_test.dart`

- [ ] **Step 1: Write failing service tests**

Tests must verify:

- Repository failure returns `saveFailed` and does not emit a success state.
- Completing stores `completedAt`.
- Restoring clears `completedAt`.
- Deleting creates a cancel job.
- Notification gateway failure leaves task data saved and job pending with incremented attempts.
- Successful notification processing removes the outbox job and marks the task reminder synced.

Use hand-written fakes implementing `TaskRepository` and `NotificationGateway`; do not mock Drift internals.

- [ ] **Step 2: Verify service tests fail**

Run:

```powershell
flutter test test/features/tasks/application
```

Expected: FAIL because services and failures do not exist.

- [ ] **Step 3: Implement typed results**

Create:

```dart
sealed class AppFailure {
  const AppFailure(this.message);
  final String message;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class PersistenceFailure extends AppFailure {
  const PersistenceFailure() : super('未能保存更改，已恢复到操作前状态');
}

final class ReminderFailure extends AppFailure {
  const ReminderFailure() : super('任务已保存，但提醒设置失败');
}
```

Use a sealed `TaskActionResult` with `TaskActionSuccess` and `TaskActionFailed` rather than throwing plugin errors into widgets.

- [ ] **Step 4: Implement service and outbox processor**

`TaskService` owns validation and repository calls. `NotificationOutboxProcessor.processPending()` reads jobs oldest-first, calls `schedule` or `cancel`, and updates/removes the job in a database transaction.

- [ ] **Step 5: Verify service behavior**

Run:

```powershell
dart format lib/core/errors lib/features/tasks/application test/features/tasks/application
flutter test test/features/tasks/application
flutter analyze
```

Expected: all application tests pass.

- [ ] **Step 6: Commit and push**

```powershell
git add lib/core/errors lib/features/tasks/application test/features/tasks/application
git commit -m "feat: coordinate task changes and reminder retries"
git push origin main
```

### Task 5: Build the Clear Flow Theme and Navigation Shell

**Files:**
- Create: `lib/app/app_theme.dart`
- Create: `lib/features/shell/presentation/app_shell.dart`
- Modify: `lib/app/app.dart`
- Test: `test/features/shell/app_shell_test.dart`

- [ ] **Step 1: Write failing navigation tests**

Assert that the shell defaults to tasks, switches to statistics and profile, preserves each tab state with `IndexedStack`, and shows the add button only on tasks.

- [ ] **Step 2: Verify tests fail**

Run:

```powershell
flutter test test/features/shell/app_shell_test.dart
```

Expected: FAIL because the production shell does not exist.

- [ ] **Step 3: Implement theme tokens**

Use:

```dart
abstract final class ClearFlowColors {
  static const background = Color(0xFFF7F5EF);
  static const text = Color(0xFF282C23);
  static const sage = Color(0xFF607A63);
  static const sageSurface = Color(0xFFE7EEE2);
  static const coral = Color(0xFFE7674C);
  static const amber = Color(0xFFD2A847);
}
```

Configure Material 3, 44-pixel minimum interactive dimensions, card radius 18, input radius 16, and Chinese locale delegates.

- [ ] **Step 4: Implement the three-tab shell**

Use `NavigationBar`, `IndexedStack`, and a page-specific `FloatingActionButton`. Provide semantic labels for all navigation destinations.

- [ ] **Step 5: Verify shell and accessibility**

Run:

```powershell
dart format lib/app lib/features/shell test/features/shell
flutter test test/features/shell/app_shell_test.dart
flutter analyze
```

Expected: shell tests pass.

- [ ] **Step 6: Commit and push**

```powershell
git add lib/app lib/features/shell test/features/shell
git commit -m "feat: add Clear Flow app shell and theme"
git push origin main
```

### Task 6: Implement Task Providers, Filters, and Statistics

**Files:**
- Create: `lib/features/tasks/presentation/task_providers.dart`
- Create: `lib/features/statistics/domain/task_statistics.dart`
- Test: `test/features/tasks/presentation/task_providers_test.dart`
- Test: `test/features/statistics/domain/task_statistics_test.dart`

- [ ] **Step 1: Write failing provider and statistics tests**

Cover:

- pending, completed, and all filters;
- automatic refresh when repository stream changes;
- pending-before-completed behavior in all tasks;
- `0%` for an empty task list;
- near-term count includes today, tomorrow, and the day after tomorrow only;
- completion rate uses completed divided by total.

- [ ] **Step 2: Verify tests fail**

Run:

```powershell
flutter test test/features/tasks/presentation/task_providers_test.dart test/features/statistics/domain/task_statistics_test.dart
```

Expected: FAIL because providers and statistics do not exist.

- [ ] **Step 3: Implement Riverpod providers**

Provide database, repository, task service, current filter, task stream, filtered/sorted tasks, statistics, profile, clock, and outbox processor through overridable Riverpod providers. Avoid global singletons.

- [ ] **Step 4: Implement statistics derivation**

Create a pure `TaskStatistics.fromTasks(List<Task>, DateTime now)` factory returning pending, completed, total, dueWithinThreeDays, and completionRate.

- [ ] **Step 5: Verify state derivation**

Run:

```powershell
dart format lib/features/tasks/presentation lib/features/statistics test/features
flutter test test/features/tasks/presentation/task_providers_test.dart test/features/statistics/domain/task_statistics_test.dart
flutter analyze
```

Expected: provider and statistics tests pass.

- [ ] **Step 6: Commit and push**

```powershell
git add lib/features/tasks/presentation/task_providers.dart lib/features/statistics test/features
git commit -m "feat: derive filtered tasks and statistics"
git push origin main
```

### Task 7: Build Task List, Smart Summary, and Task Card Interactions

**Files:**
- Create: `lib/features/tasks/presentation/task_list_screen.dart`
- Create: `lib/features/tasks/presentation/widgets/smart_summary_card.dart`
- Create: `lib/features/tasks/presentation/widgets/task_card.dart`
- Test: `test/features/tasks/presentation/task_list_screen_test.dart`
- Test: `test/features/tasks/presentation/task_card_test.dart`

- [ ] **Step 1: Write failing widget tests**

Verify:

- empty state copy and add action;
- smart summary shows overdue, today, pending, near-term, and completion values;
- filter chips change the visible list;
- card displays title, due label, note indicator, and priority text/icon in addition to color;
- tapping the checkbox completes or restores;
- tapping the card expands/collapses notes;
- edit and delete actions appear only in expanded state;
- completion and deletion SnackBars contain an undo action.

- [ ] **Step 2: Verify widget tests fail**

Run:

```powershell
flutter test test/features/tasks/presentation/task_list_screen_test.dart test/features/tasks/presentation/task_card_test.dart
```

Expected: FAIL because widgets do not exist.

- [ ] **Step 3: Implement the task list**

Use `CustomScrollView`, `SliverList`, stable keys based on task IDs, filter `SegmentedButton` or chips, and grouped headings for overdue, today, tomorrow, within three days, later, and no date.

- [ ] **Step 4: Implement card interactions and motion**

Use:

- `TweenAnimationBuilder` for the 180ms check mark;
- `AnimatedSize` and `AnimatedOpacity` for 220ms note expansion;
- `AnimatedSwitcher` for 200ms filter changes;
- immediate UI feedback only after the database operation succeeds;
- reduced-motion branch that removes translation and scale.

- [ ] **Step 5: Verify task UI**

Run:

```powershell
dart format lib/features/tasks/presentation test/features/tasks/presentation
flutter test test/features/tasks/presentation
flutter analyze
```

Expected: task presentation tests pass.

- [ ] **Step 6: Commit and push**

```powershell
git add lib/features/tasks/presentation test/features/tasks/presentation
git commit -m "feat: build interactive task list"
git push origin main
```

### Task 8: Build Add and Edit Task Form

**Files:**
- Create: `lib/features/tasks/presentation/task_form_screen.dart`
- Test: `test/features/tasks/presentation/task_form_screen_test.dart`

- [ ] **Step 1: Write failing form tests**

Verify:

- title is required and capped at 100 characters;
- note is capped at 2000 characters;
- time selector is disabled until a date exists;
- default priority is normal;
- timed reminders default to two hours;
- date-only reminders default to 09:00;
- past reminder time offers immediate reminder or reminder off;
- repository failure keeps form input and displays the persistence message;
- successful add/edit closes the form and displays the correct SnackBar.

- [ ] **Step 2: Verify tests fail**

Run:

```powershell
flutter test test/features/tasks/presentation/task_form_screen_test.dart
```

Expected: FAIL because the form does not exist.

- [ ] **Step 3: Implement form state and validation**

Use a `Form`, `TextEditingController`s, `showDatePicker`, `showTimePicker`, priority segmented control, reminder switch, reminder offset menu, and a single primary save button.

- [ ] **Step 4: Verify form behavior**

Run:

```powershell
dart format lib/features/tasks/presentation/task_form_screen.dart test/features/tasks/presentation/task_form_screen_test.dart
flutter test test/features/tasks/presentation/task_form_screen_test.dart
flutter analyze
```

Expected: all form tests pass.

- [ ] **Step 5: Commit and push**

```powershell
git add lib/features/tasks/presentation/task_form_screen.dart test/features/tasks/presentation/task_form_screen_test.dart
git commit -m "feat: add task editor and validation"
git push origin main
```

### Task 9: Build Statistics Screen

**Files:**
- Create: `lib/features/statistics/presentation/statistics_screen.dart`
- Test: `test/features/statistics/presentation/statistics_screen_test.dart`

- [ ] **Step 1: Write failing screen tests**

Verify the four counts, completion percentage, zero-task state, progress semantics, and near-term explanatory copy.

- [ ] **Step 2: Verify tests fail**

Run:

```powershell
flutter test test/features/statistics/presentation/statistics_screen_test.dart
```

Expected: FAIL because the screen does not exist.

- [ ] **Step 3: Implement lightweight statistics UI**

Use one completion ring, a two-by-two metric grid, and a near-term card. Do not add historical charts or persisted aggregate tables.

- [ ] **Step 4: Verify and commit**

```powershell
dart format lib/features/statistics/presentation test/features/statistics/presentation
flutter test test/features/statistics
flutter analyze
git add lib/features/statistics test/features/statistics
git commit -m "feat: add task statistics screen"
git push origin main
```

### Task 10: Implement Profile, Avatar Storage, Preferences, and App Version

**Files:**
- Create: `lib/features/profile/domain/user_profile.dart`
- Create: `lib/features/profile/application/profile_repository.dart`
- Create: `lib/data/profile/avatar_file_store.dart`
- Create: `lib/data/version/package_version_reader.dart`
- Create: `lib/features/profile/presentation/profile_providers.dart`
- Create: `lib/features/profile/presentation/profile_screen.dart`
- Test: `test/features/profile/profile_repository_test.dart`
- Test: `test/features/profile/profile_screen_test.dart`

- [ ] **Step 1: Write failing profile tests**

Verify:

- default display name is `用户`;
- missing avatar shows the first visible username character;
- blank username falls back to `用`;
- selected image is copied into application support storage rather than referenced from the picker cache;
- replacing an avatar deletes the old managed file;
- animation and default-filter preferences persist in Drift;
- app info displays `0.1.0 (1)` from an injected version reader.

- [ ] **Step 2: Verify tests fail**

Run:

```powershell
flutter test test/features/profile
```

Expected: FAIL because profile types do not exist.

- [ ] **Step 3: Implement profile storage**

Wrap `ImagePicker`, `path_provider`, file copy/delete, and `PackageInfo.fromPlatform()` behind injectable interfaces. Keep username and preferences in Drift, not `shared_preferences`, because they are application data that must survive consistently.

- [ ] **Step 4: Implement profile screen**

Display avatar, username editor, default filter, animation switch, local storage status, and app version. Request image library permission only from the explicit avatar action.

- [ ] **Step 5: Verify and commit**

```powershell
dart format lib/features/profile lib/data/profile lib/data/version test/features/profile
flutter test test/features/profile
flutter analyze
git add lib/features/profile lib/data/profile lib/data/version test/features/profile
git commit -m "feat: add local profile and version display"
git push origin main
```

### Task 11: Configure and Implement Local Notifications

**Files:**
- Create: `lib/data/notifications/local_notification_gateway.dart`
- Create: `lib/app/app_bootstrap.dart`
- Create: `lib/app/app_lifecycle_observer.dart`
- Modify: `lib/main.dart`
- Modify: `android/app/build.gradle.kts`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Create: `android/app/src/main/res/drawable/ic_stat_clear_flow.xml`
- Create: `android/app/src/main/res/xml/keep.xml`
- Modify: `ios/Runner/AppDelegate.swift`
- Modify: `ios/Runner/Info.plist`
- Test: `test/data/notifications/local_notification_gateway_test.dart`

- [ ] **Step 1: Write failing gateway tests**

Verify:

- timezone initialization uses the device IANA timezone;
- notification IDs are stable for a task ID;
- scheduling uses `zonedSchedule`;
- cancel uses the same stable ID;
- permission denial returns a typed unavailable result;
- app bootstrap processes pending outbox jobs;
- app resume processes pending jobs and refreshes date-sensitive providers.

- [ ] **Step 2: Verify tests fail**

Run:

```powershell
flutter test test/data/notifications/local_notification_gateway_test.dart
```

Expected: FAIL because the gateway does not exist.

- [ ] **Step 3: Add Android configuration**

Enable core library desugaring and add:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

Register the plugin scheduled notification receivers exactly as required by `flutter_local_notifications 21.0.0`. Use inexact scheduling for v0.1.0 to avoid requesting exact-alarm access. Add keep resources for the notification icon.

- [ ] **Step 4: Add iOS configuration**

Set `UNUserNotificationCenter.current().delegate` in `AppDelegate.swift`. Initialize with permission requests disabled, then request permission from a user-triggered reminder action.

- [ ] **Step 5: Implement gateway and bootstrap**

Initialize `timezone`, read the device zone with `FlutterTimezone.getLocalTimezone()`, set `tz.local`, initialize the notification plugin, process pending jobs, and expose notification-tap payloads containing the task ID.

- [ ] **Step 6: Verify notifications**

Run:

```powershell
dart format lib/data/notifications lib/app test/data/notifications
flutter test test/data/notifications/local_notification_gateway_test.dart
flutter analyze
flutter build apk --debug
```

Expected: tests pass, analyzer is clean, and Android debug APK builds.

- [ ] **Step 7: Commit and push**

```powershell
git add lib/data/notifications lib/app lib/main.dart android ios test/data/notifications
git commit -m "feat: schedule reliable local task reminders"
git push origin main
```

### Task 12: Add Integration Flow and Visual QA

**Files:**
- Create: `integration_test/offline_task_flow_test.dart`
- Create: `test/helpers/test_app.dart`
- Modify: presentation files only when defects are found

- [ ] **Step 1: Write the integration flow**

Cover:

1. Launch with empty database.
2. Add a high-priority task due tomorrow with a note and reminder.
3. Verify it appears in pending tasks and statistics.
4. Expand the note and edit the title.
5. Complete the task and verify it moves to completed.
6. Restore it and verify completion time is cleared.
7. Delete it and undo deletion.
8. Restart the app harness and verify persistence.

- [ ] **Step 2: Run integration and full tests**

Run:

```powershell
flutter test
flutter test integration_test/offline_task_flow_test.dart
```

Expected: all tests pass.

- [ ] **Step 3: Run mobile visual QA**

Launch an Android emulator and verify:

- 360x800 and 412x915 layouts;
- large system font;
- long title and note;
- empty, populated, all-completed, and overdue states;
- keyboard does not obscure save actions;
- reduced-motion setting;
- notification permission denied and granted paths;
- avatar pick, replace, and missing-file fallback.

- [ ] **Step 4: Commit any verified fixes**

```powershell
git add lib test integration_test
git commit -m "test: cover offline task workflow"
git push origin main
```

### Task 13: Add CI and Release Automation

**Files:**
- Create: `.github/workflows/flutter.yml`
- Create: `tool/release.ps1`
- Modify: `CHANGELOG.md`
- Modify: `README.md`
- Test: local dry-run of release script

- [ ] **Step 1: Add CI workflow**

The GitHub Actions workflow must:

```yaml
name: Flutter CI
on:
  push:
    branches: [main]
  pull_request:
jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 3.41.5
          channel: stable
          cache: true
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug
  ios-build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 3.41.5
          channel: stable
          cache: true
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter build ios --debug --no-codesign
```

- [ ] **Step 2: Implement guarded release script**

`tool/release.ps1` must accept `-Version` and `-Build`, then:

1. Require a clean worktree before changing release metadata.
2. Validate `VERSION` and `pubspec.yaml`.
3. Write `VERSION` as `MAJOR.MINOR.PATCH`.
4. Write `pubspec.yaml` as `MAJOR.MINOR.PATCH+BUILD`.
5. Require a matching `CHANGELOG.md` heading.
6. Run code generation, formatting check, analysis, tests, and `flutter build apk --release`.
7. Commit as `release: vMAJOR.MINOR.PATCH`.
8. Create annotated tag `vMAJOR.MINOR.PATCH`.
9. Push `main` and the tag to `origin`.

The script must stop on any failed command and must never use force-push.

- [ ] **Step 3: Test release script without external side effects**

Add a `-DryRun` switch that performs metadata validation and all verification commands but skips commit, tag, and push.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tool/release.ps1 -Version 0.1.0 -Build 1 -DryRun
```

Expected: verification passes and output says commit/tag/push were skipped.

- [ ] **Step 4: Commit and push automation**

```powershell
git add .github tool CHANGELOG.md README.md
git commit -m "ci: verify and automate version releases"
git push origin main
```

### Task 14: Release v0.1.0

**Files:**
- Modify: `VERSION`
- Modify: `pubspec.yaml`
- Modify: `CHANGELOG.md`
- No application code changes are allowed during this task

- [ ] **Step 1: Add final changelog entry**

Document all v0.1.0 user-facing features, supported platforms, notification limitations, and known limitations.

- [ ] **Step 2: Commit the prepared changelog**

```powershell
git add CHANGELOG.md
git commit -m "docs: prepare v0.1.0 changelog"
git push origin main
```

Expected: the worktree is clean before the guarded release script runs.

- [ ] **Step 3: Run final verification**

Run:

```powershell
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --release
git diff --check
```

Expected: every command exits `0`.

- [ ] **Step 4: Confirm GitHub CI is green**

Expected: both `verify` and `ios-build` jobs pass for the changelog commit.

- [ ] **Step 5: Execute the release workflow**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tool/release.ps1 -Version 0.1.0 -Build 1
```

Expected:

- commit `release: v0.1.0` exists;
- annotated tag `v0.1.0` exists;
- `main` tracks `origin/main`;
- branch and tag are visible at `https://github.com/richtongwei888-tttw/Item_List_flutter`;
- application displays `0.1.0 (1)` in “我的 > 应用信息”.

## Final Verification Checklist

- [ ] `flutter analyze` reports no issues.
- [ ] `flutter test` reports zero failures.
- [ ] Android release APK builds.
- [ ] GitHub CI builds iOS without code signing.
- [ ] Offline add/edit/delete/complete/restore survives restart.
- [ ] Sorting and statistics match the design spec.
- [ ] Date-only reminders default to 09:00.
- [ ] Timed reminders default to two hours before due time.
- [ ] Notification failures remain retryable without losing task data.
- [ ] Profile and avatar survive restart.
- [ ] Version is consistent in `VERSION`, `pubspec.yaml`, app UI, changelog, commit, tag, and GitHub.
- [ ] Worktree is clean after release.

## Primary Documentation References

- Flutter SDK locally installed: `3.41.5`, Dart `3.11.3`.
- Riverpod package: https://pub.dev/packages/flutter_riverpod
- Drift packages: https://pub.dev/packages/drift and https://pub.dev/packages/drift_flutter
- Local notifications: https://pub.dev/packages/flutter_local_notifications
- Timezone packages: https://pub.dev/packages/timezone and https://pub.dev/packages/flutter_timezone
- Flutter-maintained plugins: https://pub.dev/packages/image_picker and https://pub.dev/packages/path_provider
- App version API: https://pub.dev/packages/package_info_plus
