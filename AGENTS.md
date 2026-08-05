# AGENTS.md

## Scope

These instructions apply to the entire repository. This is a small, single-target macOS SwiftUI application. Work from the repository root and keep changes narrowly scoped.

## Project overview

- `Track Frontmost App.xcodeproj` contains the only target and scheme, both named `Track Frontmost App`.
- The target uses Swift 5 and supports macOS 11.6 or later.
- The app uses only Apple frameworks: SwiftUI, Combine, AppKit, and Foundation. There are no package dependencies.
- The app is sandboxed. Do not add entitlements or privacy permissions unless the requested feature requires them.
- Tracking data is session-only; there is no persistence, networking, or background service.
- There is currently no unit-test or UI-test target.

## Source map

- `Track Frontmost App/Track_Frontmost_AppApp.swift`: app entry point and process start time shown in the window title.
- `Track Frontmost App/FrontMostAppInfoViewModel.swift`: observes `NSWorkspace.shared.frontmostApplication` and reduces focus changes into the published app list.
- `Track Frontmost App/FrontMostAppInfo.swift`: row model, bundle-identifier identity, and runtime app-icon lookup.
- `Track Frontmost App/ContentView.swift`: SwiftUI list, duration formatting, and icon cache.
- `Track Frontmost App/Track_Frontmost_App.entitlements`: sandbox capabilities.
- `Track Frontmost App/Assets.xcassets`: application icon and accent color.

## Runtime behavior to preserve

- `FrontMostAppInfoViewModel` is main-actor isolated because it publishes state consumed by SwiftUI.
- The tracking app's own bundle identifier is excluded from `infos`. Focusing this app still closes the preceding app's active interval.
- There is at most one row per external bundle identifier. Reactivating an app moves its row to the end while retaining its accumulated duration.
- `date` records the latest activation time and is also the start used when closing an active interval.
- Despite its name, `totalUseTimeMs` stores `TimeInterval` values in seconds, not milliseconds. `DateComponentsFormatter` also expects seconds. Do not apply millisecond conversion unless the model and every consumer are deliberately migrated together.
- Elapsed time is committed only when the frontmost application changes; the visible total does not tick continuously while an app remains active.
- Icons are best-effort because `NSRunningApplication` may no longer be running. Keep icon handling optional and avoid blocking work in SwiftUI rendering.

## Code and project conventions

- Follow the existing two-space Swift indentation and keep imports and declarations simple.
- Prefer small SwiftUI views and pure state transformations. If focus-reduction behavior grows, extract testable logic rather than adding side effects to the Combine pipeline.
- Keep UI-observed mutations on `@MainActor` and avoid force-unwrapping values returned by `NSWorkspace` or `NSRunningApplication`.
- Preserve bundle-identifier-based identity unless a requested behavior explicitly requires multiple sessions for the same app.
- When adding or moving Swift files or resources, update `Track Frontmost App.xcodeproj/project.pbxproj` and verify target membership. This project does not use folder-synchronized groups.
- Quote paths containing `Track Frontmost App` in shell commands.
- Do not commit DerivedData, Xcode user state, `.DS_Store`, or other generated files.

## Build and verification

Use a temporary DerivedData location so command-line builds do not dirty the repository:

```sh
xcodebuild \
  -project "Track Frontmost App.xcodeproj" \
  -scheme "Track Frontmost App" \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath /tmp/track-frontmost-app-derived-data \
  CODE_SIGNING_ALLOWED=NO \
  build
```

There is no test action to run until a test target is added. For tracking or UI changes, also run the app manually and verify:

1. Switch among at least two external applications and return to the tracker between switches.
2. Confirm the tracker does not list itself and each external bundle identifier appears only once.
3. Confirm reactivated apps retain accumulated time and move to the end of the list.
4. Confirm missing icons do not break row rendering.

Before handing off, run `git diff --check`, inspect `git diff`, and report any verification that could not be performed.
