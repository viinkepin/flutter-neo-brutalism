# New Components Design — flutter-neo-brutalism

**Date:** 2026-04-05  
**Status:** Approved  
**Scope:** Add 12 new components to the library

---

## Background

The library currently has 23 components. This spec adds 12 more across 4 categories: Feedback & Notifikasi, Data Display, Input Tambahan, and Identity & Status. All components target general-purpose Flutter use.

---

## Decisions

- **Structure:** Flat — all files added to `lib/src/components/`, no subfolder reorganization.
- **NbToast pattern:** Widget overlay (`NbToastOverlay` + `context.showNbToast()`), not a service/DI pattern.
- **NbTable complexity:** Simple display only — header + rows, horizontal scroll if overflow. No sorting/filtering.
- **API consistency:** All components follow existing patterns (static `show()` for pickers, typed generics `<T>` for option lists, `onChanged: ValueChanged<T>`, `activeColor: Color?`, `enabled: bool`).

---

## File Structure

New files added to `lib/src/components/`:

```
nb_alert.dart
nb_avatar.dart
nb_badge.dart
nb_empty_state.dart
nb_multi_select.dart
nb_progress_bar.dart
nb_rating.dart
nb_skeleton.dart
nb_slider.dart
nb_table.dart
nb_time_picker.dart
nb_toast.dart          # includes NbToastOverlay + showNbToast extension
```

All 12 exported from `lib/neo_brutalism_ui.dart`.

---

## Example App Pages

| Page | New components added |
|---|---|
| `example/lib/pages/inputs_page.dart` (existing) | NbTimePicker, NbSlider, NbMultiSelect |
| `example/lib/pages/list_view_page.dart` (existing) | NbEmptyState, NbSkeleton, NbTable |
| `_ComponentsPage` in `example/lib/main.dart` (existing) | NbToast, NbBadge, NbAlert, NbAvatar, NbProgressBar, NbRating |

---

## Component APIs

### NbToast + NbToastOverlay

```dart
// Setup — wrap MaterialApp
NbToastOverlay(child: MaterialApp(...))

// Usage from anywhere in the tree
context.showNbToast('Tersimpan!', variant: NbToastVariant.success)
context.showNbToast('Gagal', variant: NbToastVariant.error, duration: Duration(seconds: 4))
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `message` | `String` | required | Toast text |
| `variant` | `NbToastVariant` | `info` | `success` / `error` / `warning` / `info` |
| `duration` | `Duration` | `3s` | Auto-dismiss duration |

`NbToastVariant`: `success`, `error`, `warning`, `info`.

---

### NbBadge

```dart
NbBadge(count: 3, child: Icon(Icons.notifications))
NbBadge(count: 120, maxCount: 99, child: Icon(Icons.shopping_cart)) // shows "99+"
NbBadge(count: 0, child: Icon(...)) // hidden when count == 0
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to wrap |
| `count` | `int` | required | Badge count — hidden when 0 |
| `maxCount` | `int` | `99` | Cap value — shows `"99+"` when exceeded |
| `color` | `Color?` | `colors.danger` | Badge background |
| `foregroundColor` | `Color?` | white | Badge text color |

---

### NbAlert

```dart
NbAlert(message: 'Stok hampir habis', variant: NbAlertVariant.warning)
NbAlert(
  title: 'Berhasil',
  message: 'Data tersimpan',
  variant: NbAlertVariant.success,
  onDismiss: () {},
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `message` | `String` | required | Alert body text |
| `variant` | `NbAlertVariant` | `info` | `info` / `success` / `warning` / `danger` |
| `title` | `String?` | — | Optional bold title |
| `onDismiss` | `VoidCallback?` | — | Shows × button when provided |
| `leading` | `Widget?` | auto icon | Override leading icon |

`NbAlertVariant`: `info`, `success`, `warning`, `danger`.

---

### NbTable

```dart
NbTable(
  columns: [
    NbTableColumn(label: 'Produk', flex: 2),
    NbTableColumn(label: 'Harga', width: 100),
    NbTableColumn(label: 'Stok', width: 80),
  ],
  rows: [
    [Text('Kopi'), Text('Rp 15.000'), Text('42')],
    [Text('Teh'), Text('Rp 10.000'), Text('18')],
  ],
)
```

**NbTableColumn:**

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Column header text |
| `flex` | `int?` | — | Flex factor (use flex OR width) |
| `width` | `double?` | — | Fixed column width |
| `alignment` | `Alignment` | `centerLeft` | Cell content alignment |

**NbTable:**

| Parameter | Type | Default | Description |
|---|---|---|---|
| `columns` | `List<NbTableColumn>` | required | Column definitions |
| `rows` | `List<List<Widget>>` | required | Cell widgets, row by row |

Horizontal scroll automatically applied when content overflows.

---

### NbEmptyState

```dart
NbEmptyState(title: 'Belum ada produk')
NbEmptyState(
  icon: Icon(Icons.inventory_2_outlined, size: 48),
  title: 'Belum ada produk',
  subtitle: 'Tambah produk pertamamu',
  action: NbButton.primary(label: 'Tambah', onPressed: () {}),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | Primary message |
| `subtitle` | `String?` | — | Secondary message |
| `icon` | `Widget?` | — | Illustration/icon |
| `action` | `Widget?` | — | CTA button or any widget |

---

### NbSkeleton

```dart
NbSkeleton(width: 200, height: 16)
NbSkeleton.text(lines: 3)
NbSkeleton.avatar(size: 40)
NbSkeleton(isLoading: _loading, width: 200, height: 16, child: Text('Data'))
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `width` | `double?` | `double.infinity` | Skeleton width |
| `height` | `double` | required (default ctor) | Skeleton height |
| `borderRadius` | `double?` | theme default | Corner radius |
| `isLoading` | `bool` | `true` | When false, renders `child` instead |
| `child` | `Widget?` | — | Widget to show when not loading |

Named constructors: `NbSkeleton.text({lines, lineHeight, spacing})`, `NbSkeleton.avatar({size})`.

---

### NbTimePicker

Same wheel-scroll pattern as `NbDatePicker` — two columns: Hour | Minute.

```dart
final time = await NbTimePicker.show(context, initialTime: TimeOfDay.now())
NbTimePicker(initialTime: _time, onChanged: (t) => setState(() => _time = t))
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `initialTime` | `TimeOfDay?` | `TimeOfDay.now()` | Starting value |
| `use24Hour` | `bool` | `true` | 24h vs AM/PM |
| `onChanged` | `ValueChanged<TimeOfDay>?` | — | Called on scroll |
| `title` | `String` | `'Select Time'` | Bottom sheet title (show only) |
| `confirmLabel` | `String` | `'Select'` | Confirm button label (show only) |

---

### NbSlider

```dart
NbSlider(value: _val, min: 0, max: 100, onChanged: (v) => setState(() => _val = v))
NbSlider(value: _val, min: 0, max: 100, divisions: 10, label: '${_val.round()}', onChanged: (v) {})
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | Current value |
| `min` | `double` | `0` | Minimum |
| `max` | `double` | `1` | Maximum |
| `onChanged` | `ValueChanged<double>?` | — | `null` = disabled |
| `divisions` | `int?` | — | Snap points |
| `label` | `String?` | — | Tooltip shown while dragging |
| `activeColor` | `Color?` | `colors.primary` | Track fill color |
| `enabled` | `bool` | `true` | Interactive state |

---

### NbMultiSelect\<T\>

Same bottom-sheet pattern as `NbSelect`, multi-value. Reuses `NbSelectOption<T>`.

```dart
NbMultiSelect<String>(
  label: 'Kategori',
  hint: 'Pilih kategori',
  values: _selected,
  onChanged: (v) => setState(() => _selected = v),
  options: [
    NbSelectOption(value: 'food', label: 'Makanan'),
    NbSelectOption(value: 'drink', label: 'Minuman'),
  ],
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<NbSelectOption<T>>` | required | Option list |
| `values` | `List<T>` | required | Selected values |
| `onChanged` | `ValueChanged<List<T>>?` | — | Selection callback |
| `label` | `String?` | — | Label above field |
| `hint` | `String?` | — | Placeholder text |
| `helperText` | `String?` | — | Helper below field |
| `errorText` | `String?` | — | Error text |
| `required` | `bool` | `false` | Red `*` on label |
| `enabled` | `bool` | `true` | Interactive state |
| `clearable` | `bool` | `false` | Show × to clear all |
| `sheetTitle` | `String?` | label value | Bottom sheet header title |

---

### NbAvatar

```dart
NbAvatar(initials: 'KH', size: 40)
NbAvatar(imageUrl: 'https://...', size: 48)
NbAvatar(initials: 'AB', size: 40, backgroundColor: colors.primary)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `initials` | `String?` | — | 1–2 chars shown as fallback |
| `imageUrl` | `String?` | — | Network image URL |
| `size` | `double` | `40` | Diameter in pixels |
| `backgroundColor` | `Color?` | `colors.muted` | Background when no image |
| `foregroundColor` | `Color?` | `colors.foreground` | Initials text color |

If both `imageUrl` and `initials` are provided, image is shown with initials as fallback on load error.

---

### NbProgressBar

```dart
NbProgressBar(value: 0.65)
NbProgressBar(value: 0.65, label: '65%')
NbProgressBar.circular(value: 0.4, size: 48)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | Progress `0.0–1.0` |
| `color` | `Color?` | `colors.primary` | Fill color |
| `backgroundColor` | `Color?` | `colors.muted` | Track color |
| `label` | `String?` | — | Text shown below (linear) or center (circular) |
| `size` | `double?` | `8` (linear height) / `48` (circular diameter) | Thickness/size |

Named constructors: `NbProgressBar(...)` = linear, `NbProgressBar.circular(...)` = circular.

---

### NbRating

```dart
NbRating(value: 4, onChanged: (v) => setState(() => _rating = v))
NbRating(value: 3.5, maxValue: 5) // read-only (no onChanged)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | Current rating |
| `maxValue` | `int` | `5` | Number of stars |
| `onChanged` | `ValueChanged<double>?` | — | `null` = read-only |
| `size` | `double` | `24` | Star size |
| `activeColor` | `Color?` | `colors.primary` | Filled star color |

---

## README & AGENTS.md

Both files updated with:
- New component entries in the component table
- Usage examples for each of the 12 components
- Parameter tables

---

## Out of Scope

- NbSegmentedControl, NbPagination, NbDivider (kategori D — not selected)
- NbTable sorting/filtering
- NbToast service-based pattern
