# AGENTS.md — Neo Brutalism UI

Reference guide for AI agents working with the `neo_brutalism_ui` Flutter package.

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
- Navigation drawer
- Snackbar / Toast
- Date/time picker
- Image cropper
- Inline dropdown for select-only (use `NbAutocomplete` for free-form + suggestions; use `NbCombobox`/`NbSelect` for strict selection via bottom sheet)
- File picker logic (NbFileUpload / NbPhotoUpload are UI-only)

For missing components, build them using `NbCard`, `NbText`, and raw Flutter widgets, following the design token rules above.
