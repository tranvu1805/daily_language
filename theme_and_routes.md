# Theme & Routes Reference — daily_language

> Auto-generated reference. Files: `lib/core/theme/app_theme.dart`, `lib/core/constants/colors_app.dart`, `lib/core/route/routes.dart`, `lib/core/route/router.dart`, `lib/core/route/app_shell.dart`

---

## 1. Color Palette — `ColorApp` (`lib/core/constants/colors_app.dart`)

| Name | Hex | Notes |
|---|---|---|
| `primary` | `#6366F1` | Indigo – main brand color |
| `secondary` | `#667EEA` | Light indigo/blue |
| `purple` | `#6D0EC7` | Deep purple |
| `green` | `#16A34A` | Success green |
| `orange` | `#F97316` | Warning orange |
| `linenWhite` | `#FEFBF7` | App scaffold background |
| `taupeGray` | `#8A8885` | Muted gray |
| `chestnutBrown` | `#583C29` | Brown (same hex as `brown`) |
| `pureWhite` | `#FEFEFE` | Near-white (bottom bar bg, body text color) |
| `charcoalBlue` | `#3B4556` | Dark blue-gray |
| `almondCream` | `#F8F1EC` | Warm cream |
| `ashGray` | `#A9ABAC` | Light gray |
| `bronzeGold` | `#B19371` | Warm gold |
| `lightOrange` | `#FAEDDF` | Very light orange |
| `cyanBlue` | `#C6E1F1` | Pastel blue |
| `cyanOrange` | `#F7EADD` | Pastel orange |
| `brown` | `#583C29` | Same as chestnutBrown |
| `darkGray` | `#3B3B3B` | Near-black gray |
| `failedRed` | `#EF4444` | Error/fail |
| `backgroundGradient` | `#C5CFF6` → `#D4B2F5` | LinearGradient, bottomLeft→topRight |

---

## 2. App Theme — `appTheme` (`lib/core/theme/app_theme.dart`)

Uses **Material 3** (`useMaterial3: true`).

```dart
ColorScheme.fromSeed(
  seedColor: ColorApp.linenWhite,
  brightness: Brightness.light,
  primary: ColorApp.primary,
)
scaffoldBackgroundColor: ColorApp.linenWhite
```

### TextTheme Summary

| Style | Size | Weight | Color | Notes |
|---|---|---|---|---|
| `displayLarge` | 72 | bold | (default) | |
| `titleLarge` | 24 | w400 | `Colors.black` | |
| `titleMedium` | 20 | w500 | (default) | |
| `titleSmall` | 18 | w300 | (default) | |
| `bodyLarge` | 16 | w600 | `ColorApp.pureWhite` | White text on colored bg |
| `bodyMedium` | 14 | w400 | `ColorApp.secondary` | |
| `bodySmall` | 14 | w300 | `Colors.black` | |
| `labelLarge` | 16 | w600 | `Colors.black` | |

### Other Theme Props
- `textSelectionTheme`: cursorColor = `ColorApp.primary`
- `iconTheme`: `Colors.black`, size 24
- `primaryIconTheme`: `ColorApp.primary`, size 24
- `checkboxTheme`: `MaterialTapTargetSize.shrinkWrap`
- `inputDecorationTheme`: default (no custom styling)

---

## 3. Routes — `Routes` (`lib/core/route/routes.dart`)

```dart
abstract class Routes {
  static const splash       = '/';
  static const home         = '/home';
  static const diary        = '/diary';
  static const diaryAdd     = 'add';        // relative → /diary/add
  static const words        = '/words';
  static const wordsAdd     = 'add';        // relative → /words/add
  static const account      = '/account';
  static const accountEdit  = '/account_edit';
  static const onboarding   = '/onboarding';
}
```

> ⚠️ `diaryAdd` and `wordsAdd` are **relative** paths (`'add'`), not absolute. They are always used as child routes.

---

## 4. Router — `router()` function (`lib/core/route/router.dart`)

- Uses **go_router** with `StatefulShellRoute.indexedStack` for bottom-nav tabs.
- Auth redirect via `AuthenticationBloc`:
  - If not authenticated → redirect to `Routes.splash`
  - If authenticated and on splash → redirect to `Routes.home`
- Refresh triggered by `GoRouterRefreshStream(authBloc.stream)`.

### Route Tree (active router function)

```
/ (splash)         → SplashPage
  └─ Shell (AppPage with bottom nav)
       ├─ Branch 0: /home          → HomePage
       ├─ Branch 1: /diary         → RecordPage
       │              └─ add       → RecordAddPage
       ├─ Branch 2: /words         → WordPage
       │              └─ add       → WordAddPage
       └─ Branch 3: /account       → AccountPage
                       └─ /account_edit → AccountEditPage
```

### BLoCs provided at shell level (MultiBlocProvider)
- `RecordBloc` — via `sl<RecordBloc>()`
- `RecordsBloc` — via `sl<RecordsBloc>()`
- `WordBloc` — via `sl<WordBloc>()`
- `WordsBloc` — via `sl<WordsBloc>()`

> `AppRouter` class also exists in the file but appears to be an older/unused version — it lacks BLoC providers and uses a simpler redirect.

---

## 5. App Shell — `AppPage` (`lib/core/route/app_shell.dart`)

Shell widget wrapping all bottom-nav tabs.

### Bottom Navigation Bar
- 4 tabs with icons & localized labels:
  | Index | Icon | Label key |
  |---|---|---|
  | 0 | `Icons.home_outlined` | `l10n.home` |
  | 1 | `Icons.edit_calendar_rounded` | `l10n.diary` |
  | 2 | `Icons.menu_book_rounded` | `l10n.words` |
  | 3 | `Icons.person_outline_rounded` | `l10n.profile` |
- `backgroundColor`: `ColorApp.pureWhite`
- `selectedItemColor`: `ColorApp.primary`

### FAB
- Circular `FloatingActionButton`, centered-docked
- `backgroundColor`: `ColorApp.primary`
- Icon: `Icons.add` in `ColorApp.pureWhite`
- `onPressed`: **currently empty `() {}`** (TODO)

### Navigation
- `navigationShell.goBranch(index, initialLocation: true)`

---

## 6. How to Navigate (usage patterns)

```dart
// Go to a top-level route
context.go(Routes.home);
context.go(Routes.words);
context.go(Routes.account);

// Go to a child route (push style)
context.push('${Routes.diary}/${Routes.diaryAdd}');  // /diary/add
context.push('${Routes.words}/${Routes.wordsAdd}');   // /words/add

// Go back
context.pop();
```

---

## 7. Flutter & UI Rules (from `.copilot` & `.github` configs)

**Widgets & Build Methods:**
- Prefer `StatelessWidget` whenever possible.
- **CRITICAL:** Do NOT create helper functions that return `Widget` (e.g. `Widget buildHeader()`).
- Extract UI sections into separate `StatelessWidget` classes instead.
- If a widget tree becomes longer than ~20-30 lines, split it into smaller widgets.
- Prefer composition over deeply nested widgets. Each widget should have a single responsibility.
- Use `const` constructors to avoid unnecessary rebuilds.

**Naming Conventions:**
- Widgets: `UserAvatarWidget`, `RecordItemWidget`, `ChapterCardWidget`
- Events: `XxxRequested` (or `LoadRecordsEvent`)
- States: `XxxSuccess` (or `RecordsLoadedState`)

**Architecture Limits:**
- UI must not contain business logic.
- BLoC must not depend on UI.
- UI interacts with BLoC only by dispatching events.
- Presentation layer depends on domain layer. Data layer implements domain repositories. Do not mix layers.
