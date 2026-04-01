# AGENTS.md — Neo Brutalism UI

Reference guide for AI agents working with the `neo_brutalism_ui` Flutter package.

---

## AI Migration Protocol

> **Trigger phrases:** "implement neo brutalism ui", "migrate to neo brutalism", "apply neo brutalism", "replace components with neo brutalism ui"

When you receive one of these instructions, execute the following steps in order. Do not ask the user for clarification — read the project and proceed.

---

### Step 1 — Install the package

Add to `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  neo_brutalism_ui:
    git:
      url: https://github.com/viinkepin/flutter-neo-brutalism.git
      ref: main
```

Then run:
```bash
flutter pub get
```

---

### Step 2 — Extract the project's color palette

Before writing the `NbTheme` wrapper, scan the project for existing colors. This is the only place where you read colors from the project — do it once, here.

#### 2a — Where to look

Search these locations **in order**. Stop at each step if you find the color.

| NbColorScheme parameter | Where to look in the project |
|---|---|
| `primary` | `ThemeData.colorScheme.primary` → `ThemeData.primaryColor` → `ThemeData.primarySwatch` → `MaterialColor` definition → constant named `primaryColor` / `kPrimary` / `brandColor` / `accentColor` |
| `primaryForeground` | `ThemeData.colorScheme.onPrimary` → compute from primary luminance: if primary is dark (luminance < 0.3), use `Color(0xFFFFFFFF)`; else use `Color(0xFF000000)` |
| `secondary` | `ThemeData.colorScheme.secondary` → `ThemeData.colorScheme.tertiary` → constant named `secondaryColor` / `kSecondary` |
| `secondaryForeground` | `ThemeData.colorScheme.onSecondary` → same luminance rule as above |
| `background` | `ThemeData.colorScheme.surface` (Material 3) → `ThemeData.scaffoldBackgroundColor` → `ThemeData.backgroundColor` (deprecated) |
| `surface` | `ThemeData.colorScheme.surfaceContainerHighest` → `ThemeData.colorScheme.surface` → `ThemeData.cardColor` |
| `border` | `ThemeData.dividerColor` → `ThemeData.colorScheme.outline` → leave unset (defaults to black/white) |
| `danger` | `ThemeData.colorScheme.error` → constant named `errorColor` / `kError` / `dangerColor` |
| `dangerForeground` | `ThemeData.colorScheme.onError` → same luminance rule |
| `muted` | `ThemeData.colorScheme.surfaceContainerHighest` → `ThemeData.colorScheme.surfaceVariant` → leave unset |
| `success` / `warning` | Look for constants named `successColor` / `warningColor` / `kSuccess` / `kWarning` → leave unset if not found |

**If a color is not found in the project, do NOT pass that parameter** — `NbColorScheme.light()` and `NbColorScheme.dark()` have sensible defaults for every slot.

#### 2b — Wrap the app with NbTheme

Find the root widget (usually `main.dart` where `MaterialApp` or `runApp` is called).
Wrap `MaterialApp` (or `CupertinoApp`) with `NbTheme` using the colors you extracted:

```dart
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';

// Before
runApp(MaterialApp(home: MyApp()));

// After — pass only the colors you actually found in Step 2a
runApp(
  NbTheme(
    data: NbThemeData.light(
      colorScheme: NbColorScheme.light(
        primary: Color(0xFF6366F1),           // extracted from project
        primaryForeground: Color(0xFFFFFFFF), // computed from luminance
        secondary: Color(0xFFF59E0B),         // extracted from project
        danger: Color(0xFFEF4444),            // extracted from ThemeData.colorScheme.error
        // omit parameters not found — library uses defaults
      ),
    ),
    child: MaterialApp(home: MyApp()),
  ),
);
```

**If no brand color is found anywhere in the project**, use the default `NbColorScheme.light()` with no parameters (which gives the neo-brutalism yellow palette).

#### 2c — Dark mode

If the project has `darkTheme:` in `MaterialApp`, also set up a dark color scheme. Apply the same extraction logic but read from the dark `ThemeData` instance:

```dart
NbTheme(
  data: NbThemeData.light(colorScheme: NbColorScheme.light(primary: ...)),
  darkData: NbThemeData.dark(colorScheme: NbColorScheme.dark(primary: ...)),
  child: MaterialApp(
    theme: ...,
    darkTheme: ...,
    home: MyApp(),
  ),
)
```

---

### Step 3 — Set up typography

#### 3a — Find the project's current font

Search for font declarations in this order:
1. `ThemeData(fontFamily: '...')` — direct font name string
2. `GoogleFonts.<fontName>()` — if `google_fonts` package is used, extract the font name
3. `pubspec.yaml` → `fonts:` section — list of declared font families
4. `TextStyle(fontFamily: '...')` used in 3+ places — likely the brand font

#### 3b — Decide which font to use

| Situation | Action |
|---|---|
| Project has a custom font already in `pubspec.yaml` | Use that font — pass its name to `NbThemeData.light(fontFamily: 'FontName')` |
| Project uses `google_fonts` | Add `google_fonts` dependency if not present, keep it; pass the font family name to `NbThemeData` |
| Project has no font or uses the default (Roboto) | Use **DM Sans** — it is the best neo-brutalism fit. Add it to `pubspec.yaml` and pass `fontFamily: 'DMSans'` |

**Recommended neo-brutalism fonts (in order of preference):** DM Sans → Space Grotesk → Plus Jakarta Sans → Inter

#### 3c — Add the font to pubspec.yaml (if switching to DM Sans or another new font)

```yaml
flutter:
  fonts:
    - family: DMSans
      fonts:
        - asset: fonts/DMSans-Regular.ttf
          weight: 400
        - asset: fonts/DMSans-Medium.ttf
          weight: 500
        - asset: fonts/DMSans-SemiBold.ttf
          weight: 600
        - asset: fonts/DMSans-Bold.ttf
          weight: 700
        - asset: fonts/DMSans-ExtraBold.ttf
          weight: 800
```

Then download the font files to `fonts/` and run `flutter pub get`.

> If using `google_fonts`, you do NOT need to add font files — just pass `fontFamily: 'DM Sans'` and use `GoogleFonts.dmSansTextTheme()` in `MaterialApp.theme` if desired.

#### 3d — Pass fontFamily to NbThemeData

```dart
NbTheme(
  data: NbThemeData.light(
    colorScheme: NbColorScheme.light(primary: ...),
    fontFamily: 'DMSans', // the font name matching the family: key in pubspec.yaml
  ),
  child: MaterialApp(...),
)
```

`NbTypography` uses this font family across all text variants (display, headline, body, label, caption). Every `NbText.*` and all component labels automatically use it — no per-widget font setting needed.

#### 3e — Replace Text widgets with NbText

After the font is set, replace content `Text` widgets according to the **Text** section of the Component Mapping Table (Step 6). The font will apply automatically through `NbTypography`. Do **not** replace:
- `Text` widgets inside third-party package widgets
- `Text` used only as debug/placeholder content
- `Text` inside custom painters or canvas code

---

### Step 4 — Scan the project

Use grep or file search to find all `.dart` files under `lib/`. For each file, look for components listed in the **Component Mapping Table** below. Build a list:

```
FILE                         COMPONENT FOUND              NB REPLACEMENT
lib/screens/login_page.dart  ElevatedButton               NbButton.primary
lib/screens/login_page.dart  TextField                    NbTextField
lib/widgets/app_bar.dart     AppBar                       NbAppBar
...
```

---

### Step 5 — Execute replacements file by file

For each file in your list, replace the Flutter/Material component with its NbComponent equivalent using the mapping table below. Follow the **Rules** below the table.

---

### Step 6 — Verify

Run `flutter analyze` after all replacements. Fix any errors before finishing.

---

## Component Mapping Table

> Left column = what to look for in the project. Right column = what to replace it with.
> "Skip" means leave it as-is — no NbComponent equivalent exists.

### Navigation & Layout

| Found in project | Replace with | Notes |
|---|---|---|
| `AppBar(...)` | `NbAppBar(title: '...', actions: [...])` | `NbAppBar` implements `PreferredSizeWidget`; use as `Scaffold.appBar` directly |
| `SliverAppBar(...)` | `NbAppBar(...)` | Use `NbAppBar` inside `CustomScrollView > SliverToBoxAdapter`; `SliverAppBar` has no NbComponent |
| `BottomNavigationBar(...)` | `NbNavBar(items: [...], selectedIndex: ..., onChanged: ...)` | Replace `BottomNavigationBarItem` with `NbNavItem` |
| `NavigationBar(...)` | `NbNavBar(...)` | Same as above |
| `Drawer(child: ListView(...))` | `NbDrawer(sections: [...], header: NbDrawerHeader(...))` | Extract `ListTile` items → `NbDrawerItem`; extract header widget → `NbDrawerHeader` |
| `TabBar(...)` + `DefaultTabController` | `NbTabBar(tabs: [...], selectedIndex: ..., onChanged: ...)` | Manage tab index in `setState` instead of `DefaultTabController` |
| `NavigationRail(...)` | Skip | No NbComponent equivalent |

### Buttons

| Found in project | Replace with | Notes |
|---|---|---|
| `ElevatedButton(...)` | `NbButton.primary(label: '...', onPressed: ...)` | |
| `OutlinedButton(...)` | `NbButton.secondary(label: '...', onPressed: ...)` | |
| `TextButton(...)` | `NbButton.ghost(label: '...', onPressed: ...)` | |
| `FilledButton(...)` | `NbButton.primary(label: '...', onPressed: ...)` | |
| `ElevatedButton.icon(...)` | `NbButton.primary(label: '...', leading: Icon(...), onPressed: ...)` | |
| `IconButton(...)` in AppBar actions | `NbAppBarAction(icon: ..., onTap: ...)` | Only for AppBar; keep bare `IconButton` elsewhere if no nb equivalent fits |
| `FloatingActionButton(...)` | `NbButton.primary(...)` with `isFullWidth: false` inside a `Positioned` | No direct FAB equivalent; use `NbButton.primary` + manual positioning |
| `PopupMenuButton(...)` | `NbPopupMenuButton(items: [...], child: ...)` | Replace `PopupMenuItem` with `NbPopupMenuItem` |

### Cards & Containers

| Found in project | Replace with | Notes |
|---|---|---|
| `Card(child: ...)` | `NbCard(child: ...)` | Flat card; no shadow |
| `Card(elevation: >0, child: ...)` | `NbCard.elevated(child: ...)` | Has hard 4px shadow |
| `Card(color: someColor, child: ...)` | `NbCard.filled(backgroundColor: someColor, child: ...)` | |
| `InkWell(onTap: ..., child: Card(...))` | `NbCard.elevated(onTap: ..., child: ...)` | Tappable card with press animation |
| Custom container with `BoxDecoration` border | Keep as-is OR rebuild with `NbCard` | Replace only if the container acts as a card/list item |

### Text

| Found in project | Replace with | Notes |
|---|---|---|
| `Text('...', style: TextStyle(fontSize: 28+, fontWeight: FontWeight.bold))` | `NbText.headline('...')` or `NbText.display('...')` | Match by size: 36+=display, 28-35=headline, 20-27=title, 16-19=titleSmall |
| `Text('...', style: TextStyle(fontSize: 13-15))` | `NbText.body('...')` | |
| `Text('...', style: TextStyle(fontSize: 10-12))` | `NbText.caption('...')` or `NbText.bodySmall('...')` | |
| `Text('...', style: Theme.of(context).textTheme.labelLarge)` | `NbText.label('...')` | |
| Plain `Text('...')` with no style | `NbText.body('...')` | Only replace where it's visible UI content, not utility text |
| `RichText(...)` | Keep as-is | No NbComponent equivalent |

### Form inputs

| Found in project | Replace with | Notes |
|---|---|---|
| `TextField(decoration: InputDecoration(labelText: '...'))` | `NbTextField(label: '...', controller: ..., hint: '...')` | |
| `TextFormField(...)` | `NbTextField(...)` | If inside a `Form`, keep `Form` but replace the field widget; note NbTextField does not use `validator` — validate manually in `onChanged` or on submit |
| `TextField(maxLines: null)` or `maxLines: > 1` | `NbTextareaField(...)` | Use `NbTextareaField` not `NbTextarea` |
| `Switch(...)` | `NbSwitch(value: ..., onChanged: ...)` | |
| `SwitchListTile(...)` | `Row(mainAxisAlignment: spaceBetween, children: [NbText.body('...'), NbSwitch(...)])` | SwitchListTile has no direct equivalent; use this pattern |
| `Checkbox(...)` | `NbCheckbox(value: ..., onChanged: ...)` | |
| `CheckboxListTile(...)` | `NbCheckbox(value: ..., label: '...', onChanged: ...)` | |
| `Radio(...)` | `NbRadio(value: ..., groupValue: ..., onChanged: ...)` | |
| `RadioListTile(...)` | `NbRadioGroup(options: [...], groupValue: ..., onChanged: ...)` | Group multiple radio options |
| `DropdownButton(...)` | `NbSelect(options: [...], value: ..., onChanged: ...)` | Opens bottom sheet — not an inline dropdown |
| `DropdownButtonFormField(...)` | `NbSelect(...)` or `NbCombobox(...)` | Use `NbCombobox` if the list is long and needs search |
| `Autocomplete(...)` | `NbAutocomplete(options: [...], onSelected: ..., onChanged: ...)` | |
| `FilterChip(...)` / `InputChip(...)` / `Chip(...)` | `NbChip(...)` or `NbChipGroup(options: [...])` | Match variant: filter=selectable, input=removable, display=read-only |
| `showDatePicker(...)` | `await NbDatePicker.show(context, initialDate: ...)` | Returns `DateTime?` — same as `showDatePicker` |
| Custom increment/decrement row | `NbNumberStepper(value: ..., onChanged: ...)` | |
| `GridView` of product cards | `NbProductGridView(items: [...])` | Use `NbProductItem` as the data model |
| `ListView` of product rows | `NbProductListView(items: [...])` | Image on left, title/price/rating on right |
| `ExpansionTile(...)` | `NbAccordion(title: '...', child: ...)` | |
| `ExpansionPanelList(...)` | `NbAccordionGroup(items: [...])` | |

### Dialogs & Overlays

| Found in project | Replace with | Notes |
|---|---|---|
| `showDialog(builder: (_) => AlertDialog(...))` | `NbDialog.show(context: context, title: '...', content: ..., actions: [...])` | |
| `AlertDialog(...)` | `NbDialog(title: '...', content: ..., actions: [...])` | Use inside `showDialog` |
| `SimpleDialog(...)` | `NbDialog(content: ..., showCloseButton: true)` | |
| `SnackBar(...)` / `ScaffoldMessenger.showSnackBar(...)` | Skip | No NbComponent equivalent — keep as-is |
| `BottomSheet(...)` / `showModalBottomSheet(...)` | Skip unless replacing with NbSelect/NbCombobox | Keep custom bottom sheets as-is |
| `Tooltip(...)` | Skip | No NbComponent equivalent |

### Upload / Media

| Found in project | Replace with | Notes |
|---|---|---|
| Custom file upload button/zone | `NbFileUpload(onTap: ..., fileName: ...)` | UI only — keep existing file picker logic in `onTap` |
| Custom avatar/image upload | `NbPhotoUpload(hasImage: ..., imageChild: ..., onTap: ...)` | UI only — keep existing image picker logic in `onTap` |

---

## Migration Rules

Follow these rules when executing replacements:

1. **Never remove existing logic** — only replace the widget layer. Keep `onPressed` callbacks, state variables, controllers, and validators intact.

2. **Preserve existing controllers** — `TextEditingController`, `FocusNode`, `ScrollController` etc. are passed directly to NbComponents unchanged.

3. **Form validation** — `TextFormField` with `validator:` has no direct equivalent. Replace the widget with `NbTextField` and move validation to `onChanged` + a state variable for `errorText`, OR keep a `Form` widget and use `NbTextField` inside it (the `Form` will still work since `NbTextField` internally uses `TextField`).

4. **Theme colors** — color extraction is done once in **Step 2a**. Do not re-scan for colors during Step 5. When replacing components, do not hardcode colors — use `context.nbColors.*` (e.g. `context.nbColors.primary`) if the original widget used a theme color, or keep the original literal if it was a one-off override.

5. **`isFullWidth` in Row** — whenever replacing a button inside a `Row`, wrap with `Expanded`. Never use `isFullWidth: true` directly inside a `Row`.

6. **Skip when no equivalent** — if a component has no NbComponent equivalent (Tooltip, SnackBar, SliverAppBar, NavigationRail, etc.), leave it as-is. Do not build custom replacements unless the user asks.

7. **Drawer with `ListTile`** — when replacing `Drawer`, group `ListTile` items by their visual sections (dividers, headers) into `NbDrawerSection` objects. Map each `ListTile` to `NbDrawerItem`. The header widget (UserAccountsDrawerHeader or custom) becomes `NbDrawerHeader`.

8. **Text replacement scope** — only replace `Text` widgets that are clearly content/UI text (labels, titles, descriptions). Do NOT replace `Text` inside existing custom widget internals that you are not refactoring.

9. **`NbAppBar.showLeading: false`** — set on the root/home page where there is no back navigation. On all other pages leave at default `true` so the auto back button works.

10. **One file at a time** — process files sequentially. Run `flutter analyze` after every 5–10 files to catch errors early.

---

## Project Structure

```
lib/
  neo_brutalism_ui.dart          # Library barrel — all public exports
  src/
    theme/
      nb_color_scheme.dart       # NbColorScheme
      nb_theme_data.dart         # NbThemeData
      nb_theme.dart              # NbTheme widget + NbThemeExtension
    tokens/
      nb_typography.dart         # NbTypography
    components/
      nb_text.dart               # NbText, NbTextVariant
      nb_button.dart             # NbButton, NbButtonVariant, NbButtonSize
      nb_card.dart               # NbCard, NbCardVariant
      nb_text_field.dart         # NbTextField, NbTextarea, NbTextareaField
      nb_switch.dart             # NbSwitch, NbSwitchLabelPosition
      nb_checkbox.dart           # NbCheckbox
      nb_radio.dart              # NbRadio, NbRadioGroup, NbRadioOption
      nb_select.dart             # NbSelect, NbSelectOption
      nb_accordion.dart          # NbAccordion, NbAccordionGroup, NbAccordionItem
      nb_upload.dart             # NbFileUpload, NbPhotoUpload, NbPhotoUploadShape
      nb_chip.dart               # NbChip, NbChipVariant, NbChipGroup, NbChipOption
      nb_number_stepper.dart     # NbNumberStepper
      nb_combobox.dart           # NbCombobox, NbComboboxOption
      nb_autocomplete.dart       # NbAutocomplete
      nb_dialog.dart             # NbDialog
      nb_tab.dart                # NbTabBar
      nb_appbar.dart             # NbAppBar, NbAppBarAction
      nb_navbar.dart             # NbNavBar, NbNavItem
      nb_popup_menu.dart         # NbPopupMenuButton, NbPopupMenuItem
      nb_drawer.dart             # NbDrawer, NbDrawerItem, NbDrawerSection, NbDrawerHeader
      nb_date_picker.dart        # NbDatePicker
      nb_product_list.dart       # NbProductItem, NbProductGridView, NbProductListView
example/
  lib/
    main.dart                    # Full showcase app (Dashboard, Components, Typography tabs)
    pages/
      inputs_page.dart           # All form components — interactive & stateful
```

**Always import from the barrel:**
```dart
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';
```

---

## Setup

`NbTheme` must wrap the widget tree (inside or outside `MaterialApp`):

```dart
NbTheme(
  data: NbThemeData.light(
    colorScheme: NbColorScheme.light(primary: Color(0xFFFDE047)),
    fontFamily: 'DMSans',
  ),
  child: MaterialApp(...),
)
```

Context extensions for quick access:
```dart
context.nbTheme   // NbThemeData
context.nbColors  // NbColorScheme
context.nbType    // NbTypography
```

---

## Design Token Defaults

| Token | Value |
|---|---|
| Border width | `2.0px` solid |
| Border radius | `8.0px` |
| Shadow offset | `4px 4px` |
| Shadow blur | `0px` (hard, no blur) |
| Shadow color (light) | `#000000` |
| Shadow color (dark) | `#FFFFFF` |
| Primary color | `#FDE047` (yellow) |
| Background (light) | `#FAFAF9` |
| Surface (light) | `#FFFFFF` |
| Foreground (light) | `#000000` |

---

## Shadow Rule — CRITICAL

**Shadow is a hierarchy tool, not decoration.** Applying it to every element causes visual noise and removes hierarchy.

| Element | Shadow | Border |
|---|---|---|
| `NbButton` with `variant: primary` | ✅ YES | ✅ 2px |
| `NbCard.elevated` | ✅ YES | ✅ 2px |
| `NbCard` (flat, default) | ❌ NO | ✅ 2px |
| `NbCard.filled` | ❌ NO | ✅ 2px |
| All form inputs | ❌ NO | ✅ 2px |
| List items | ❌ NO | ✅ 2px |
| Inner elements inside a card | ❌ NO | ✅ 2px |
| Bottom nav bar | ❌ NO | ✅ border-top only |

---

## Typography Scale

| Constructor | Size | Weight | When to use |
|---|---|---|---|
| `NbText.display` | 36px | w800 | Hero title, main page header |
| `NbText.headline` | 28px | w800 | Section heading |
| `NbText.title` | 20px | w700 | Card title, dialog title |
| `NbText.titleSmall` | 16px | w700 | Sub-section heading |
| `NbText.body` | 14px | w500 | Regular content text |
| `NbText.bodySmall` | 12px | w500 | Secondary/supporting content |
| `NbText.label` | 13px | w600 | Form labels, button text |
| `NbText.labelSmall` | 11px | w600 | Section labels (uppercase feel), badges |
| `NbText.caption` | 10px | w500 | Metadata, timestamps, helper text |

Override options on all constructors: `color`, `fontWeight`, `textAlign`, `maxLines`, `overflow`, `softWrap`, `style`.

---

## Component API Reference

### NbButton

```dart
NbButton.primary(label: 'Save', onPressed: () {})
NbButton.secondary(label: 'Cancel', onPressed: () {})
NbButton.danger(label: 'Delete', onPressed: () {})
NbButton.ghost(label: 'See all', onPressed: () {})
NbButton(label: 'Confirm', variant: NbButtonVariant.success, onPressed: () {})
```

Key parameters:
- `onPressed: null` → disabled state
- `isLoading: true` → shows spinner, disables tap
- `isFullWidth: true` → expands to parent width
- `leading` / `trailing` → icon widgets
- `size` → `NbButtonSize.small` / `.medium` / `.large`

**GOTCHA: `isFullWidth` inside a `Row`**
When placing a button with `isFullWidth: true` inside a `Row`, always wrap it in `Expanded`:
```dart
// WRONG — causes "BoxConstraints forces an infinite width" error
Row(children: [NbButton.primary(label: 'OK', onPressed: () {}, isFullWidth: true)])

// CORRECT
Row(children: [
  Expanded(child: NbButton.secondary(label: 'Cancel', onPressed: () {}, isFullWidth: true)),
  SizedBox(width: 12),
  Expanded(child: NbButton.primary(label: 'Save', onPressed: () {}, isFullWidth: true)),
])
```

---

### NbCard

```dart
NbCard(child: ...)                           // flat — border only, no shadow
NbCard.elevated(child: ...)                  // hard 4px shadow — use sparingly
NbCard.elevated(onTap: () {}, child: ...)    // tappable — press animation
NbCard.filled(backgroundColor: colors.primary, child: ...)  // colored background
```

Key parameters: `padding`, `margin`, `borderRadius`, `borderColor`, `width`, `height`, `clipBehavior`.

`NbCard.filled` requires `backgroundColor` (it's a named required param).

---

### NbTextField

Label always renders **above** the field. Border turns primary on focus, danger on error.

```dart
NbTextField(
  controller: _ctrl,
  label: 'Full Name',
  hint: 'placeholder',
  required: true,           // adds red * to label
  errorText: _error,        // red border + error text below
  helperText: 'helper',     // shown when no error
  leading: Icon(Icons.search_rounded),
  trailing: Icon(Icons.close_rounded),
  onTrailingTap: () => _ctrl.clear(),
  leadingText: 'Rp',        // text prefix (not icon)
  trailingText: 'kg',       // text suffix (not icon)
  obscureText: _hidden,
  enabled: false,           // grayed out
  readOnly: true,
  keyboardType: TextInputType.number,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
)
```

`leading`/`trailing` are icon widgets. `leadingText`/`trailingText` are short strings (currency, unit).
Both can coexist: `leadingText: 'Rp'` + `trailing: clearIcon` is valid.

---

### NbTextareaField

Use `NbTextareaField` (not `NbTextarea`) — it correctly exposes `minLines`/`maxLines`.

```dart
NbTextareaField(
  controller: _ctrl,
  label: 'Description',
  minLines: 4,
  maxLines: 8,    // null = unbounded
  maxLength: 200,
)
```

---

### NbSwitch

```dart
NbSwitch(value: _on, onChanged: (v) => setState(() => _on = v))
NbSwitch(value: _on, onChanged: null)  // disabled
NbSwitch(
  value: _on,
  label: 'Enable notifications',
  labelPosition: NbSwitchLabelPosition.left,  // or .right (default)
  activeColor: Colors.green,
  onChanged: (v) => setState(() => _on = v),
)
```

For a full-width row with label, use a `Row` + `MainAxisAlignment.spaceBetween` in the page, not built-in label. The built-in `label` uses `mainAxisSize: min`.

---

### NbCheckbox

```dart
NbCheckbox(
  value: _checked,           // bool? — null is indeterminate
  tristate: false,           // set true to allow null
  label: 'Accept terms',
  onChanged: (v) => setState(() => _checked = v ?? false),
  size: 22,                  // default
  activeColor: colors.primary,
)
```

Tristate cycle: `false → null → true → false`

---

### NbRadioGroup / NbRadio

```dart
NbRadioGroup<String>(
  label: 'Payment Method',
  groupValue: _payment,
  onChanged: (v) => setState(() => _payment = v),
  direction: Axis.vertical,   // or Axis.horizontal
  spacing: 12,
  options: [
    NbRadioOption(value: 'cash', label: 'Cash'),
    NbRadioOption(value: 'card', label: 'Card', disabled: true),
  ],
)
```

`NbRadio` standalone — use only when custom layout is needed:
```dart
NbRadio<String>(
  value: 'option_a',
  groupValue: _selected,
  onChanged: (v) => setState(() => _selected = v),
  label: 'Option A',
)
```

---

### NbSelect

Opens a **bottom sheet** (not a dropdown) with options. Renders visually identical to `NbTextField`.

```dart
NbSelect<String>(
  label: 'Category',
  hint: 'Select one',
  value: _value,
  clearable: true,          // shows × button to reset to null
  sheetTitle: 'Pick Category',
  onChanged: (v) => setState(() => _value = v),
  options: [
    NbSelectOption(value: 'a', label: 'Option A'),
    NbSelectOption(value: 'b', label: 'Option B', leading: Icon(Icons.star)),
    NbSelectOption(value: 'c', label: 'Disabled', disabled: true),
  ],
)
```

`onChanged` receives `T?` — it can be `null` when user taps × to clear.

---

### NbAccordion / NbAccordionGroup

```dart
// Standalone — manages its own open/close state
NbAccordion(
  title: 'Section Title',
  leading: Icon(Icons.info_outline, size: 18),
  initiallyExpanded: false,
  onExpansionChanged: (isOpen) {},
  child: NbText.body('Content'),
)

// Group — only one panel open at a time
NbAccordionGroup(
  gap: 8,
  items: [
    NbAccordionItem(title: 'First', child: Text('...'), initiallyExpanded: true),
    NbAccordionItem(title: 'Second', leading: Icon(Icons.info, size: 18), child: Text('...')),
  ],
)
```

`NbAccordionGroup` manages which item is open. Do not try to control open state externally — use `NbAccordion` standalone + `onExpansionChanged` for that.

---

### NbFileUpload

UI only — no file picker logic included. Wire `onTap` to a file picker package.

```dart
NbFileUpload(
  label: 'Document',
  required: true,
  hint: 'Tap to select a file',
  acceptedTypes: 'PDF · DOC · XLSX',
  maxSizeLabel: 'Max 10 MB',
  fileName: _fileName,      // null = placeholder, non-null = file preview row
  helperText: 'helper',
  errorText: _error,
  enabled: true,
  onTap: () async {
    // e.g. FilePicker.platform.pickFiles()
    setState(() => _fileName = 'document.pdf');
  },
  onClear: () => setState(() => _fileName = null),
)
```

When `fileName` is set, shows a file preview row (icon + filename + clear button). When null, shows the dashed upload zone.

---

### NbPhotoUpload

```dart
NbPhotoUpload(
  label: 'Product Photo',
  size: 120,                          // width and height (square)
  shape: NbPhotoUploadShape.square,   // or .circle
  hasImage: _hasImage,
  imageChild: _hasImage
      ? Image.memory(_bytes!, fit: BoxFit.cover)
      : null,
  hint: 'Add Photo',
  helperText: 'Square image recommended',
  errorText: _error,
  required: true,
  enabled: true,
  onTap: () { /* picker when no image, or edit button when image exists */ },
  onClear: () => setState(() => _hasImage = false),
)
```

Key behaviors:
- When `hasImage: false` → shows dashed border zone with icon + hint
- When `hasImage: true` → shows image with edit (bottom-right) and clear (top-right) overlays
- `onTap` is called when tapping the empty zone OR the edit button overlay
- Image is clipped to the shape (circle or rounded square)

For circle shape with small `size` (< 120), keep `hint` short — it renders as a plain icon + small caption text.

---

### NbChip / NbChipGroup

`NbChipVariant`:
- `filter` — selectable chip; shows checkmark icon when `selected: true`
- `input` — shows × remove button; use for tag lists
- `display` — read-only, no interaction

`NbChipGroup<T>` manages selection state externally:
```dart
NbChipGroup<String>(
  options: [NbChipOption(value: 'food', label: 'Food')],
  selectedValues: _selected,
  onChanged: (values) => setState(() => _selected = values),
  multiSelect: true, // false = radio-like single select
)
```

Key params: `spacing` (horizontal gap, default 8), `runSpacing` (row gap, default 8), `activeColor` (fill when selected, default theme primary).

---

### NbNumberStepper

Single bordered container: `[−] | value display | [+]`

```dart
NbNumberStepper(
  value: _qty,
  min: 1,
  max: 99,
  onChanged: (v) => setState(() => _qty = v),
)
```

- `−` button disables (greys out) when `value <= min`
- `+` button disables when `value >= max` (if max set)
- No shadow — follows inner control hierarchy rule

---

### NbCombobox

Opens a bottom sheet with a search bar. Value **must** come from `options` list.

```dart
NbCombobox<String>(
  options: [NbComboboxOption(value: 'jkt', label: 'Jakarta')],
  value: _city,
  onChanged: (v) => setState(() => _city = v),
  clearable: true,
)
```

`NbComboboxOption<T>`: `value`, `label`, `leading` (optional widget), `disabled` (bool).

`sheetTitle` defaults to `label ?? 'Select'`. `searchHint` defaults to `'Search...'`.

**Difference from NbSelect**: Both open a bottom sheet, but `NbCombobox` has a persistent search field at the top of the sheet and uses a generic type `T`.

---

### NbAutocomplete

Inline overlay dropdown as user types. User can type freely OR select from list.

```dart
NbAutocomplete(
  options: _suggestions,  // update this list dynamically for server search
  onChanged: (q) async {
    final r = await api.search(q);
    setState(() => _suggestions = r);
  },
  onSelected: (v) => setState(() => _value = v),
)
```

- Wraps Flutter's built-in `Autocomplete<String>` for proper overlay positioning
- `onChanged` fires on every keystroke; `onSelected` fires only when user picks from dropdown
- When `options` is empty and user types → dropdown hides automatically
- `maxSuggestionsHeight` (default 220) caps dropdown height; list scrolls inside

**Difference from NbCombobox**: Free-form text allowed; inline overlay (not bottom sheet); `options` is `List<String>` not generics.

---

### NbDialog

```dart
NbDialog.show(
  context: context,
  title: 'Confirm',
  content: const Text('Sure?'),
  actions: [
    NbButton.ghost(label: 'Cancel', onPressed: () => Navigator.pop(context)),
    NbButton.danger(label: 'Delete', onPressed: () {}),
  ],
);
```

- `content` widget is wrapped in `DefaultTextStyle` with `typography.body + mutedForeground`
- `showCloseButton: false` hides the × — useful when actions already provide exit
- Dialog has hard 4px shadow — one of the few overlay components that uses shadow

---

### NbTabBar

```dart
NbTabBar(
  tabs: const ['Tab A', 'Tab B', 'Tab C'],
  selectedIndex: _tab,
  onChanged: (i) => setState(() => _tab = i),
)
```

- Selected tab: white surface + border; unselected: transparent on muted background
- `isScrollable: false` (default): all tabs are `Expanded` — equal width
- `isScrollable: true`: tabs are natural width inside a `SingleChildScrollView`
- Use `AnimatedSwitcher` or `IndexedStack` to swap content based on `selectedIndex`

---

### NbAppBar

Implements `PreferredSizeWidget` — pass directly to `Scaffold.appBar`:

```dart
Scaffold(
  appBar: NbAppBar(
    title: 'Page Title',
    actions: [NbAppBarAction(icon: Icons.more_vert_rounded, onTap: () {})],
  ),
)
```

- Auto back button rendered when `Navigator.canPop(context)` is true and `leading` is null
- `showLeading: false` disables auto back button (use on root pages)
- `bottom` accepts any `PreferredSizeWidget` — wrap `NbTabBar` in `PreferredSize` if needed (NbTabBar itself doesn't implement PreferredSizeWidget — use `PreferredSize(preferredSize: Size.fromHeight(44), child: NbTabBar(...))`)
- `NbAppBarAction` has optional `badge` (red dot with count); hidden when `badge == 0`

---

### NbNavBar

```dart
Scaffold(
  bottomNavigationBar: NbNavBar(
    selectedIndex: _tab,
    onChanged: (i) => setState(() => _tab = i),
    items: const [
      NbNavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
      NbNavItem(icon: Icons.search_rounded, label: 'Search', badge: 5),
    ],
  ),
)
```

- Handles `SafeArea` bottom padding internally
- `badge` shown as small red pill on icon; hidden when null or 0
- Selected item: primary-colored pill container; unselected: transparent

---

### NbPopupMenuButton

```dart
NbPopupMenuButton(
  items: [
    NbPopupMenuItem(label: 'Edit', icon: Icons.edit_outlined, onTap: () {}),
    const NbPopupMenuItem.divider(),
    NbPopupMenuItem(label: 'Delete', isDestructive: true, onTap: () {}),
  ],
  child: Icon(Icons.more_vert_rounded),
)
```

- Menu auto-positions below button; flips above when insufficient space below
- Menu right-aligns to the button's right edge by default; clamped to screen bounds
- Dismissed by tapping outside the panel OR by the item's own `onTap` (which calls `Navigator.pop` then the callback)
- `enabled: false` items are greyed out and non-tappable
- `isDestructive: true` renders label + icon in `colors.danger`
- `menuWidth` default is 200px — override for longer labels

---

### NbDrawer

Pass to `Scaffold.drawer` — Flutter handles slide animation, swipe-to-open gesture, and barrier tap automatically.

```dart
Scaffold(
  drawer: NbDrawer(
    header: NbDrawerHeader(title: 'App', subtitle: 'user@email.com', avatar: Icon(Icons.person_rounded)),
    sections: [
      NbDrawerSection(items: [
        NbDrawerItem(icon: Icons.home_rounded, label: 'Home', selected: _tab == 0, onTap: () {
          setState(() => _tab = 0);
          Navigator.pop(context);  // close drawer
        }),
      ]),
      NbDrawerSection(title: 'SETTINGS', items: [
        NbDrawerItem(icon: Icons.settings_rounded, label: 'Preferences', onTap: () {}),
      ]),
    ],
    footer: NbDrawerItem(icon: Icons.logout_rounded, label: 'Log Out', onTap: () {}),
  ),
)
```

Open programmatically: `Scaffold.of(context).openDrawer()`

- Selected item: primary-colored background + border
- `showDivider: false` on a section hides the divider above it
- `trailing` widget on item: icon-themed to `mutedForeground` at 16px

---

### NbDatePicker

```dart
// Bottom sheet
final date = await NbDatePicker.show(context, initialDate: _date);
if (date != null) setState(() => _date = date);

// Inline
NbDatePicker(initialDate: _date, onChanged: (d) => setState(() => _date = d))
```

- 3 scroll columns: Day (1–31) | Month (January–December) | Year (range)
- `diameterRatio: 8` + `perspective: 0.002` = nearly flat wheel (not 3D)
- Top/bottom fade via `ShaderMask`-style gradient overlay
- Center line highlight via `IgnorePointer` border strip
- Day auto-clamps when switching to shorter month (animates to last valid day)
- Year range: `minDate?.year ?? now-100` to `maxDate?.year ?? now+10`

---

### NbProductGridView / NbProductListView

```dart
// Standalone (fills available space)
NbProductGridView(items: _products)
NbProductListView(items: _products)

// Embedded in Column
NbProductGridView(
  items: _products,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
)

// Switch between grid and list
Expanded(
  child: _isGrid
    ? NbProductGridView(items: _products, padding: const EdgeInsets.all(16))
    : NbProductListView(items: _products, padding: const EdgeInsets.all(16)),
)
```

**NbProductItem** key fields: `title` (required), `price` (required), `image` (Widget?),
`badge` (String?), `badgeColor` (Color?), `rating` (double? 0–5), `reviewCount` (int?),
`originalPrice` (String? → strikethrough), `onTap` (VoidCallback?), `onAddToCart` (VoidCallback?).

- Tappable cards (when `onTap != null`): elevated shadow + press-into-shadow animation
- `onAddToCart` shows a `+` button (primary color, press animation, no shadow to avoid clip)
- Badge rendered over image top-left corner
- Rating: filled/half/empty star icons using `Icons.star_rounded` / `Icons.star_half_rounded`
- `IntrinsicHeight` used in list tile to stretch image to content height
- Image clipped via `ClipRRect` (top corners for grid, left corners for list tile)

---

## Common Patterns

### Page scaffold pattern

```dart
Scaffold(
  backgroundColor: context.nbColors.background,
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NbText.headline('Page Title'),
          SizedBox(height: 4),
          NbText.body('Subtitle', color: context.nbColors.mutedForeground),
          SizedBox(height: 28),
          // content...
        ],
      ),
    ),
  ),
)
```

### Form section pattern

```dart
NbCard(
  padding: EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      NbText.labelSmall('SECTION LABEL', color: colors.mutedForeground),
      SizedBox(height: 10),
      // fields...
    ],
  ),
)
```

### Two-button row pattern

Always wrap both buttons in `Expanded` when using `isFullWidth`:

```dart
Row(
  children: [
    Expanded(
      child: NbButton.secondary(label: 'Cancel', onPressed: () {}, isFullWidth: true),
    ),
    SizedBox(width: 12),
    Expanded(
      child: NbButton.primary(label: 'Save', onPressed: _submit, isFullWidth: true),
    ),
  ],
)
```

### Switch row pattern (full-width label + switch)

The built-in `NbSwitch(label:)` uses `mainAxisSize: min`. For a full-width row:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    NbText.body('Enable notifications'),
    NbSwitch(value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
  ],
)
```

### Stat card pattern

```dart
NbCard(
  padding: EdgeInsets.all(14),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.success.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Icon(Icons.trending_up, size: 18, color: colors.success),
      ),
      SizedBox(height: 10),
      NbText.headline('1,284'),
      SizedBox(height: 2),
      NbText.caption('Transactions', color: colors.mutedForeground),
    ],
  ),
)
```

---

## Known Gotchas

| Situation | Problem | Fix |
|---|---|---|
| `NbButton(isFullWidth: true)` inside `Row` | Infinite width error | Wrap button in `Expanded` |
| `NbDrawer` used outside `Scaffold` | `Scaffold.of(context).openDrawer()` throws | Ensure the calling context is a descendant of the `Scaffold` with the drawer |
| `NbDatePicker` inline in a `Column` | Takes `44 × 5 = 220px` fixed height | Wrap in `SizedBox(height: 220)` if the parent is unbounded |
| `NbDatePicker.show()` returns null | User dismissed without tapping confirm (or tapped ×) | Always null-check the return value |
| `NbNavBar` inside a rounded `NbCard` | Top border corners appear disconnected | Wrap `NbNavBar` in `Container` with `clipBehavior: Clip.hardEdge` + same `borderRadius` |
| `NbTabBar` as `NbAppBar.bottom` | `NbTabBar` doesn't implement `PreferredSizeWidget` | Wrap in `PreferredSize(preferredSize: Size.fromHeight(44), child: NbTabBar(...))` |
| `NbPopupMenuButton` reopens on dismiss | Barrier tap propagates to button | Built-in 250ms cooldown handles this automatically |
| `NbAppBar` on root page shows back button | `Navigator.canPop` is true inside nested navigators | Set `showLeading: false` on root-level pages |
| `NbCombobox` vs `NbSelect` | Both open bottom sheets but look different | `NbCombobox` has search icon + search bar; `NbSelect` has chevron icon; use `NbCombobox` for long lists needing search |
| `NbAutocomplete` options not updating | Dropdown shows stale results | `NbAutocomplete` is stateless — call `setState` in `onChanged` to push new `options` list |
| `NbChipGroup` single-select mode | All chips deselectable | Set `multiSelect: false` — but user can still deselect all; manage minimum selection in `onChanged` if needed |
| `NbNumberStepper` inside unbounded width | Stepper takes minimum width | It uses `mainAxisSize: min`; wrap in `SizedBox` or `Expanded` to control width |
| `NbPhotoUpload` with large hint text in circle | Content clips or overflows | Keep hint short (≤2 short words), use `\n` for line break |
| `NbTextarea` vs `NbTextareaField` | `NbTextarea` doesn't expose `minLines`/`maxLines` correctly | Always use `NbTextareaField` |
| `NbSelect` vs dropdown | `NbSelect` opens a bottom sheet, not an inline dropdown | Use `NbSelect` — there is no inline dropdown component |
| `NbAccordionGroup` external state control | Group manages state internally | Use standalone `NbAccordion` + `onExpansionChanged` for external control |
| `NbCard.filled` missing `backgroundColor` | Compile error — it's required | Always pass `backgroundColor` to `NbCard.filled` |
| Shadow on every element | Eye fatigue, no visual hierarchy | Apply shadow only to primary CTA buttons and `NbCard.elevated` |

---

## Color Palette Recommendations

Bold, saturated solid colors only. No gradients, no glassmorphism.

| Color | Hex | Usage |
|---|---|---|
| Yellow | `#FDE047` | Default primary (iconic neo-brutalism) |
| Blue | `#3B82F6` | Secondary, info |
| Pink | `#F472B6` | Accent, highlight |
| Green | `#4ADE80` | Success |
| Orange | `#F97316` | Warning |
| Purple | `#8B5CF6` | Alternative primary |
| Lime | `#A3E635` | Alternative accent |
| Cyan | `#06B6D4` | Alternative accent |

---

## What This Library Does NOT Include

- Charts / graphs
- Data tables
- Snackbar / Toast
- Time picker (date picker exists via `NbDatePicker`)
- Image cropper
- Navigation rail / side rail
- Tooltip
- Inline dropdown for select-only (use `NbAutocomplete` for free-form + suggestions; use `NbCombobox`/`NbSelect` for strict selection via bottom sheet)
- File picker logic (NbFileUpload / NbPhotoUpload are UI-only — wire `onTap` to any file picker package)

For missing components, build them using `NbCard`, `NbText`, and raw Flutter widgets, following the design token rules above.
