# Neo Brutalism UI

A Flutter component library built on the neo-brutalism design style — bold borders, hard offset shadows, flat solid colors, and heavy typography.

## Install

```yaml
dependencies:
  neo_brutalism_ui:
    git:
      url: https://github.com/viinkepin/flutter-neo-brutalism.git
      ref: main
```

---

## Quick Start

Wrap your app with `NbTheme`, then use components anywhere in the tree:

```dart
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';

NbTheme(
  data: NbThemeData.light(
    colorScheme: NbColorScheme.light(
      primary: Color(0xFFFDE047), // your brand color
    ),
    fontFamily: 'DMSans', // optional custom font
  ),
  child: MaterialApp(home: MyApp()),
)
```

Access the theme from any widget:

```dart
final theme  = context.nbTheme;   // NbThemeData
final colors = context.nbColors;  // NbColorScheme
final type   = context.nbType;    // NbTypography
```

---

## Theme

### NbThemeData

| Parameter | Type | Default | Description |
|---|---|---|---|
| `colorScheme` | `NbColorScheme` | light defaults | Color palette |
| `fontFamily` | `String?` | system font | Custom font family |
| `borderWidth` | `double` | `2.0` | Border width on all components |
| `borderRadius` | `double` | `8.0` | Default corner radius |
| `shadowOffsetX` | `double` | `4.0` | Hard shadow X offset |
| `shadowOffsetY` | `double` | `4.0` | Hard shadow Y offset |
| `pressAnimationDuration` | `Duration` | `80ms` | Press animation speed |

Factories: `NbThemeData.light(...)` and `NbThemeData.dark(...)`.

### NbColorScheme

| Token | Light default | Dark default | Usage |
|---|---|---|---|
| `primary` | `#FDE047` (yellow) | `#FDE047` | Main accent, primary buttons |
| `primaryForeground` | `#000000` | `#000000` | Text on primary |
| `secondary` | `#60A5FA` (blue) | `#60A5FA` | Secondary accent |
| `background` | `#FAFAF9` | `#0F0F0F` | Page/scaffold background |
| `surface` | `#FFFFFF` | `#1A1A1A` | Card/container background |
| `foreground` | `#000000` | `#EBEBEB` | Default text/icon color |
| `border` | `#000000` | `#EBEBEB` | All component borders |
| `shadow` | `#000000` | `#FFFFFF` | Hard offset shadow color |
| `danger` | `#EF4444` | `#EF4444` | Error/destructive |
| `success` | `#22C55E` | `#22C55E` | Positive/confirm |
| `warning` | `#FB923C` | `#FB923C` | Warning/caution |
| `muted` | `#E5E7EB` | `#374151` | Disabled backgrounds |
| `mutedForeground` | `#6B7280` | `#9CA3AF` | Placeholder/helper text |

Override any color via factory parameters or `copyWith`:

```dart
NbColorScheme.light(
  primary: Color(0xFF6366F1), // indigo brand
  secondary: Color(0xFFF472B6),
)
```

---

## Typography — NbText

Nine semantic levels, each a named constructor on `NbText`:

| Constructor | Size | Weight | Use case |
|---|---|---|---|
| `NbText.display` | 36px | w800 | Hero titles, page headers |
| `NbText.headline` | 28px | w800 | Section headings |
| `NbText.title` | 20px | w700 | Card headers, dialog titles |
| `NbText.titleSmall` | 16px | w700 | Sub-section headings |
| `NbText.body` | 14px | w500 | Regular content |
| `NbText.bodySmall` | 12px | w500 | Secondary/supporting content |
| `NbText.label` | 13px | w600 | Form labels, button text |
| `NbText.labelSmall` | 11px | w600 | Badges, small labels |
| `NbText.caption` | 10px | w500 | Metadata, timestamps |

```dart
NbText.headline('Dashboard')
NbText.body('Regular paragraph text')
NbText.caption('Updated 5 min ago', color: colors.mutedForeground)
NbText.label('Price', fontWeight: FontWeight.w800)

// Truncation
NbText.label(product.name, maxLines: 1, overflow: TextOverflow.ellipsis)
```

All constructors accept: `color`, `fontWeight`, `textAlign`, `maxLines`, `overflow`, `softWrap`, `style`.

---

## Components

### NbButton

Physical press animation: on press, the button translates into its shadow and the shadow disappears.

**Only `primary` variant has a shadow** — use it for the main CTA on each screen.

```dart
NbButton.primary(label: 'Save', onPressed: () {})
NbButton.secondary(label: 'Cancel', onPressed: () {})
NbButton.danger(label: 'Delete', onPressed: () {})
NbButton.ghost(label: 'See all', onPressed: () {})

// With icon
NbButton.primary(
  label: 'Add Item',
  onPressed: () {},
  leading: Icon(Icons.add_rounded),
)

// Sizes
NbButton.primary(label: 'Small', size: NbButtonSize.small, onPressed: () {})
NbButton.primary(label: 'Large', size: NbButtonSize.large, onPressed: () {})

// Loading state
NbButton.primary(label: 'Saving…', onPressed: () {}, isLoading: true)

// Full width inside a Row — must wrap in Expanded
Row(
  children: [
    Expanded(
      child: NbButton.secondary(label: 'Cancel', onPressed: () {}, isFullWidth: true),
    ),
    SizedBox(width: 12),
    Expanded(
      child: NbButton.primary(label: 'Confirm', onPressed: () {}, isFullWidth: true),
    ),
  ],
)

// Disabled
NbButton.primary(label: 'Disabled', onPressed: null)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | — | Button text (required if no `child`) |
| `child` | `Widget?` | — | Custom child widget |
| `onPressed` | `VoidCallback?` | — | `null` = disabled |
| `variant` | `NbButtonVariant` | `primary` | Visual style |
| `size` | `NbButtonSize` | `medium` | `small` / `medium` / `large` |
| `leading` | `Widget?` | — | Left icon |
| `trailing` | `Widget?` | — | Right icon |
| `isLoading` | `bool` | `false` | Shows spinner, disables tap |
| `isFullWidth` | `bool` | `false` | Expand to parent width |

---

### NbCard

Neo-brutalism card container. Shadow only on `elevated` — don't use shadow on every card.

```dart
// Flat (default) — for list items, inner content
NbCard(
  padding: EdgeInsets.all(16),
  child: NbText.body('Content'),
)

// Elevated — for primary content sections (has shadow)
NbCard.elevated(
  padding: EdgeInsets.all(16),
  child: Column(...),
)

// Elevated + tappable (press animation)
NbCard.elevated(
  onTap: () {},
  child: Row(...),
)

// Filled — colored background
NbCard.filled(
  backgroundColor: colors.primary,
  padding: EdgeInsets.all(20),
  child: NbText.title('Total', color: colors.primaryForeground),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Card content |
| `variant` | `NbCardVariant` | `flat` | `flat` / `elevated` / `filled` |
| `backgroundColor` | `Color?` | `colors.surface` | Background color |
| `borderColor` | `Color?` | `colors.border` | Border color |
| `padding` | `EdgeInsets?` | none | Inner padding |
| `margin` | `EdgeInsets?` | none | Outer margin |
| `borderRadius` | `double?` | theme default | Corner radius |
| `onTap` | `VoidCallback?` | — | Makes card tappable |
| `width` / `height` | `double?` | — | Fixed dimensions |

---

### NbTextField

Label always renders above the field. Border changes color on focus (primary) and error (danger).

```dart
// Basic
NbTextField(
  controller: _nameCtrl,
  label: 'Full Name',
  hint: 'e.g. John Doe',
  required: true,
)

// With icon
NbTextField(
  label: 'Search',
  leading: Icon(Icons.search_rounded),
  trailing: Icon(Icons.close_rounded),
  onTrailingTap: () => _ctrl.clear(),
)

// Currency prefix / suffix text
NbTextField(
  label: 'Price',
  leadingText: 'Rp',
  trailingText: '.00',
  keyboardType: TextInputType.number,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
)

// Password toggle
NbTextField(
  label: 'Password',
  obscureText: _hidden,
  trailing: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
  onTrailingTap: () => setState(() => _hidden = !_hidden),
)

// Validation
NbTextField(
  label: 'Email',
  errorText: _emailError,
  helperText: 'you@example.com',
  onChanged: _validateEmail,
)
```

| Parameter | Type | Description |
|---|---|---|
| `controller` | `TextEditingController?` | Text controller |
| `label` | `String?` | Label above field |
| `hint` | `String?` | Placeholder text |
| `helperText` | `String?` | Helper below field |
| `errorText` | `String?` | Error (overrides helper, shows red border) |
| `leading` | `Widget?` | Left icon |
| `trailing` | `Widget?` | Right icon |
| `leadingText` | `String?` | Left text prefix (e.g. `"Rp"`) |
| `trailingText` | `String?` | Right text suffix (e.g. `"kg"`) |
| `onTrailingTap` | `VoidCallback?` | Trailing icon tap handler |
| `obscureText` | `bool` | Password masking |
| `required` | `bool` | Appends red `*` to label |
| `enabled` | `bool` | `false` = grayed out |
| `readOnly` | `bool` | Focusable but not editable |
| `maxLength` | `int?` | Character limit |
| `inputFormatters` | `List<TextInputFormatter>?` | Input formatting |

---

### NbTextareaField

Multi-line input. Use `NbTextareaField` (not `NbTextarea`) for full `minLines`/`maxLines` control.

```dart
NbTextareaField(
  controller: _descCtrl,
  label: 'Description',
  hint: 'Describe your product...',
  minLines: 4,
  maxLines: 8,
)

NbTextareaField(
  label: 'Bio',
  minLines: 3,
  maxLines: 5,
  maxLength: 200,
)
```

| Parameter | Type | Default |
|---|---|---|
| `minLines` | `int` | `4` |
| `maxLines` | `int?` | `8` |
| `maxLength` | `int?` | — |

All other parameters same as `NbTextField`.

---

### NbSwitch

Rectangular track (not pill-shaped) to match the neo-brutalism aesthetic.

```dart
NbSwitch(value: _enabled, onChanged: (v) => setState(() => _enabled = v))

NbSwitch(
  value: _enabled,
  label: 'Enable notifications',
  labelPosition: NbSwitchLabelPosition.right,
  onChanged: (v) => setState(() => _enabled = v),
)

NbSwitch(value: true, onChanged: null) // disabled
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | required | Current state |
| `onChanged` | `ValueChanged<bool>?` | — | `null` = disabled |
| `label` | `String?` | — | Optional label |
| `labelPosition` | `NbSwitchLabelPosition` | `right` | `left` or `right` |
| `activeColor` | `Color?` | `colors.primary` | Track color when on |

---

### NbCheckbox

Square checkbox. Supports tristate for "select all" patterns.

```dart
NbCheckbox(
  value: _checked,
  label: 'Accept terms',
  onChanged: (v) => setState(() => _checked = v ?? false),
)

// Tristate
NbCheckbox(
  value: _selectAll,   // null = indeterminate dash
  tristate: true,
  label: 'Select All',
  onChanged: (v) {
    setState(() {
      _selectAll = v;
      _opt1 = v == true;
      _opt2 = v == true;
    });
  },
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool?` | required | `true` / `false` / `null` (indeterminate) |
| `onChanged` | `ValueChanged<bool?>?` | — | `null` = disabled |
| `label` | `String?` | — | Optional label |
| `tristate` | `bool` | `false` | Allow null/indeterminate state |
| `activeColor` | `Color?` | `colors.primary` | Fill color when checked |
| `size` | `double` | `22` | Box size in pixels |

---

### NbRadio / NbRadioGroup

Use `NbRadioGroup` for managed state. Use standalone `NbRadio` only when you need custom layout.

```dart
NbRadioGroup<String>(
  label: 'Payment Method',
  groupValue: _payment,
  onChanged: (v) => setState(() => _payment = v),
  options: [
    NbRadioOption(value: 'cash', label: 'Cash'),
    NbRadioOption(value: 'card', label: 'Credit Card'),
    NbRadioOption(value: 'crypto', label: 'Crypto', disabled: true),
  ],
)

// Horizontal
NbRadioGroup<String>(
  label: 'Size',
  groupValue: _size,
  onChanged: (v) => setState(() => _size = v),
  direction: Axis.horizontal,
  options: [
    NbRadioOption(value: 'sm', label: 'S'),
    NbRadioOption(value: 'md', label: 'M'),
    NbRadioOption(value: 'lg', label: 'L'),
  ],
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<NbRadioOption<T>>` | required | Option list |
| `groupValue` | `T?` | required | Currently selected value |
| `onChanged` | `ValueChanged<T?>?` | — | Selection callback |
| `label` | `String?` | — | Group label |
| `direction` | `Axis` | `vertical` | Layout direction |
| `spacing` | `double` | `12` | Gap between options |

`NbRadioOption` fields: `value`, `label`, `disabled`.

---

### NbSelect

Renders like a text field but opens a bottom sheet with options on tap.

```dart
NbSelect<String>(
  label: 'Category',
  hint: 'Select a category',
  required: true,
  value: _category,
  onChanged: (v) => setState(() => _category = v),
  options: [
    NbSelectOption(value: 'food', label: 'Food & Beverage'),
    NbSelectOption(value: 'retail', label: 'Retail'),
  ],
)

// With icons + clearable
NbSelect<String>(
  label: 'Country',
  value: _country,
  clearable: true,
  onChanged: (v) => setState(() => _country = v),
  options: [
    NbSelectOption(value: 'id', label: '🇮🇩 Indonesia', leading: Icon(Icons.flag_rounded)),
    NbSelectOption(value: 'sg', label: '🇸🇬 Singapore', leading: Icon(Icons.flag_rounded)),
  ],
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<NbSelectOption<T>>` | required | Option list |
| `value` | `T?` | — | Selected value |
| `onChanged` | `ValueChanged<T?>?` | — | Selection callback |
| `label` | `String?` | — | Label above field |
| `hint` | `String?` | — | Placeholder text |
| `helperText` | `String?` | — | Helper below field |
| `errorText` | `String?` | — | Error text |
| `required` | `bool` | `false` | Red `*` on label |
| `enabled` | `bool` | `true` | Interactive state |
| `clearable` | `bool` | `false` | Show `×` to clear selection |
| `sheetTitle` | `String?` | label value | Bottom sheet header title |

`NbSelectOption` fields: `value`, `label`, `leading` (Widget?), `disabled`.

---

### NbAccordion / NbAccordionGroup

Collapsible section with animated expand/collapse.

```dart
// Standalone
NbAccordion(
  title: 'FAQ Title',
  leading: Icon(Icons.help_outline_rounded, size: 18),
  initiallyExpanded: true,
  child: NbText.body('Answer content here'),
)

// Group — only one open at a time
NbAccordionGroup(
  gap: 8,
  items: [
    NbAccordionItem(
      title: 'Shipping',
      leading: Icon(Icons.local_shipping_outlined, size: 18),
      initiallyExpanded: true,
      child: NbText.body('2-5 business days'),
    ),
    NbAccordionItem(
      title: 'Returns',
      child: NbText.body('30-day return policy'),
    ),
  ],
)
```

`NbAccordion` parameters:

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | Header text |
| `child` | `Widget` | required | Body content |
| `initiallyExpanded` | `bool` | `false` | Start expanded |
| `leading` | `Widget?` | — | Icon left of title |
| `trailing` | `Widget?` | — | Extra widget right of title |
| `padding` | `EdgeInsets?` | `all(14)` | Header and body padding |
| `onExpansionChanged` | `ValueChanged<bool>?` | — | Open/close callback |

`NbAccordionGroup`: `items` (List<NbAccordionItem>), `gap` (double, default `8`).

`NbAccordionItem` fields: `title`, `child`, `leading`, `initiallyExpanded`.

---

### NbFileUpload

UI-only file upload zone. Wire up `onTap` to your file picker.

```dart
NbFileUpload(
  label: 'Document',
  required: true,
  hint: 'Tap to upload file',
  acceptedTypes: 'PDF · DOC · XLSX',
  maxSizeLabel: 'Max 10 MB',
  fileName: _uploadedFile,
  onTap: () async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => _uploadedFile = result.files.single.name);
    }
  },
  onClear: () => setState(() => _uploadedFile = null),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | — | Label above zone |
| `fileName` | `String?` | — | Selected file name; when set, shows file preview row |
| `onTap` | `VoidCallback?` | — | Called when zone is tapped |
| `onClear` | `VoidCallback?` | — | Called when × is tapped |
| `hint` | `String` | `'Tap to select a file'` | Placeholder text |
| `acceptedTypes` | `String?` | — | e.g. `'PDF · DOC'` |
| `maxSizeLabel` | `String?` | — | e.g. `'Max 10 MB'` |
| `helperText` | `String?` | — | Helper below zone |
| `errorText` | `String?` | — | Error text (red dashed border) |
| `required` | `bool` | `false` | Red `*` on label |
| `enabled` | `bool` | `true` | Interactive state |

---

### NbPhotoUpload

Fixed-size photo upload zone. Supports square and circle shapes.

```dart
// Square
NbPhotoUpload(
  label: 'Product Photo',
  size: 120,
  hasImage: _imageBytes != null,
  imageChild: _imageBytes != null
      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
      : null,
  onTap: () async { /* trigger image picker */ },
  onClear: () => setState(() => _imageBytes = null),
)

// Circle (avatar)
NbPhotoUpload(
  label: 'Profile Photo',
  size: 100,
  shape: NbPhotoUploadShape.circle,
  hasImage: _hasImage,
  imageChild: _hasImage ? Image.memory(_bytes!, fit: BoxFit.cover) : null,
  hint: 'Add\nPhoto',
  helperText: 'Square image recommended',
  onTap: () {},
  onClear: () => setState(() => _hasImage = false),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | — | Label above zone |
| `hasImage` | `bool` | `false` | When `true`, renders image + overlays |
| `imageChild` | `Widget?` | — | Image widget (`Image.memory(bytes, fit: BoxFit.cover)`) |
| `onTap` | `VoidCallback?` | — | Zone tap (no image) or edit button |
| `onClear` | `VoidCallback?` | — | × overlay tap |
| `hint` | `String` | `'Tap to add photo'` | Placeholder text |
| `size` | `double` | `120` | Width and height in logical pixels |
| `shape` | `NbPhotoUploadShape` | `square` | `square` or `circle` |
| `helperText` | `String?` | — | Helper below zone |
| `errorText` | `String?` | — | Error text (red dashed border) |
| `required` | `bool` | `false` | Red `*` on label |
| `enabled` | `bool` | `true` | Interactive state |

---

## NbChip / NbChipGroup

A single chip or a managed group of selectable/removable chips.

### NbChip

```dart
// Filter chip (selectable)
NbChip(
  label: 'Flutter',
  selected: true,
  onTap: () {},
)

// Input chip (removable)
NbChip(
  label: 'flutter',
  variant: NbChipVariant.input,
  onRemove: () {},
)

// Display chip (read-only)
NbChip(
  label: 'New',
  variant: NbChipVariant.display,
  leading: Icon(Icons.star_rounded),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Chip text |
| `variant` | `NbChipVariant` | `filter` | `filter`, `input`, or `display` |
| `selected` | `bool` | `false` | Active state (filter variant) |
| `onTap` | `VoidCallback?` | — | Tap handler |
| `onRemove` | `VoidCallback?` | — | × button tap (input variant) |
| `leading` | `Widget?` | — | Icon before label |
| `disabled` | `bool` | `false` | Greyed-out, non-interactive |
| `activeColor` | `Color?` | theme primary | Fill color when selected |

### NbChipGroup

```dart
NbChipGroup<String>(
  label: 'Categories',
  options: [
    NbChipOption(value: 'food', label: 'Food'),
    NbChipOption(value: 'tech', label: 'Tech'),
    NbChipOption(value: 'travel', label: 'Travel', disabled: true),
  ],
  selectedValues: _selected,
  onChanged: (values) => setState(() => _selected = values),
  multiSelect: true,
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<NbChipOption<T>>` | required | Chip options |
| `selectedValues` | `List<T>` | required | Currently selected values |
| `onChanged` | `ValueChanged<List<T>>?` | — | Called when selection changes |
| `multiSelect` | `bool` | `true` | Allow multiple selections |
| `label` | `String?` | — | Label above group |
| `spacing` | `double` | `8` | Horizontal spacing between chips |
| `runSpacing` | `double` | `8` | Vertical spacing between rows |
| `activeColor` | `Color?` | theme primary | Fill color for selected chips |

---

## NbNumberStepper

An increment/decrement control rendered as a single bordered row: `[−] | value | [+]`.

```dart
NbNumberStepper(
  value: _qty,
  onChanged: (v) => setState(() => _qty = v),
)

// With constraints and label
NbNumberStepper(
  label: 'Quantity',
  value: _qty,
  min: 1,
  max: 99,
  step: 1,
  helperText: 'Max 99 items',
  onChanged: (v) => setState(() => _qty = v),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `int` | required | Current value |
| `onChanged` | `ValueChanged<int>?` | — | Called on increment/decrement |
| `min` | `int` | `0` | Minimum value (− button disables at bound) |
| `max` | `int?` | `null` | Maximum value (+ button disables at bound) |
| `step` | `int` | `1` | Amount per increment/decrement |
| `enabled` | `bool` | `true` | Interactive state |
| `label` | `String?` | — | Label above stepper |
| `helperText` | `String?` | — | Helper below stepper |
| `errorText` | `String?` | — | Error (red border) |
| `required` | `bool` | `false` | Red `*` on label |

---

## NbCombobox

A searchable select that opens a bottom sheet. The selected value must come from the options list.

For free-form text with suggestions, use `NbAutocomplete` instead.

```dart
NbCombobox<String>(
  label: 'City',
  hint: 'Search and select...',
  value: _city,
  onChanged: (v) => setState(() => _city = v),
  clearable: true,
  options: [
    NbComboboxOption(value: 'jakarta', label: 'Jakarta'),
    NbComboboxOption(value: 'bandung', label: 'Bandung'),
    NbComboboxOption(value: 'surabaya', label: 'Surabaya'),
  ],
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<NbComboboxOption<T>>` | required | Available options |
| `value` | `T?` | — | Currently selected value |
| `onChanged` | `ValueChanged<T?>?` | — | Called when selection changes |
| `label` | `String?` | — | Label above field |
| `hint` | `String?` | — | Placeholder when no value selected |
| `helperText` | `String?` | — | Helper below field |
| `errorText` | `String?` | — | Error text (red border) |
| `enabled` | `bool` | `true` | Interactive state |
| `required` | `bool` | `false` | Red `*` on label |
| `clearable` | `bool` | `false` | Show × button to clear selection |
| `sheetTitle` | `String?` | label or `'Select'` | Bottom sheet header title |
| `searchHint` | `String` | `'Search...'` | Search field placeholder |

### NbComboboxOption

```dart
NbComboboxOption<T>(
  value: myValue,
  label: 'Display Label',
  leading: Icon(Icons.flag),  // optional
  disabled: false,            // optional
)
```

---

## NbAutocomplete

A text field with inline dropdown suggestions. User can type freely OR select from suggestions.

For a select-only dropdown (value must come from list), use `NbCombobox` instead.

```dart
// Static options
NbAutocomplete(
  label: 'City',
  hint: 'Type to search...',
  options: ['Jakarta', 'Bandung', 'Surabaya', 'Medan'],
  onSelected: (value) => setState(() => _city = value),
  onChanged: (value) => setState(() => _city = value),
)

// Dynamic options (from API)
NbAutocomplete(
  label: 'Product',
  options: _searchResults,
  onChanged: (q) async {
    final results = await api.search(q);
    setState(() => _searchResults = results);
  },
  onSelected: (value) => setState(() => _product = value),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<String>` | required | Suggestions shown in dropdown |
| `onSelected` | `ValueChanged<String>?` | — | Called when user picks from list |
| `onChanged` | `ValueChanged<String>?` | — | Called on every keystroke |
| `label` | `String?` | — | Label above field |
| `hint` | `String?` | — | Placeholder text |
| `helperText` | `String?` | — | Helper below field |
| `errorText` | `String?` | — | Error text (red border) |
| `required` | `bool` | `false` | Red `*` on label |
| `enabled` | `bool` | `true` | Interactive state |
| `initialValue` | `String?` | — | Pre-fill text |
| `leading` | `Widget?` | — | Leading icon inside field |
| `maxSuggestionsHeight` | `double` | `220` | Max dropdown height |

---

## Design Principles

### Shadow Hierarchy

Shadow is a **hierarchy tool**, not decoration applied to everything.

| Element | Shadow | Border |
|---|---|---|
| Primary CTA button | ✅ 4px hard | ✅ 2px |
| `NbCard.elevated` | ✅ 4px hard | ✅ 2px |
| Regular list item / inner card | ❌ | ✅ 2px |
| Form fields, chips, tags | ❌ | ✅ 2px |
| Bottom nav bar | ❌ | ✅ border-top only |

Applying shadow to every element creates visual noise and removes hierarchy.

### Colors

Bold, saturated, solid colors only. No gradients, no glassmorphism.

Popular accents: Yellow `#FDE047`, Blue `#3B82F6`, Pink `#F472B6`, Green `#4ADE80`, Purple `#8B5CF6`, Orange `#F97316`

### Typography

Headings w700–w800, body w500. Never lighter than w400.

---

## Example App

See `example/` for a full interactive showcase:

```
example/lib/
  main.dart           # Dashboard, Components, Typography tabs
  pages/
    inputs_page.dart  # All form components — interactive & stateful
```
