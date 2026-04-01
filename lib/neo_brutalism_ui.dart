/// Neo-Brutalism UI — A professional Flutter component library.
///
/// Bold borders. Hard shadows. Flat colors.
///
/// ## Quick start
///
/// 1. Wrap your app with [NbTheme]:
/// ```dart
/// NbTheme(
///   data: NbThemeData.light(
///     colorScheme: NbColorScheme.light(primary: Color(0xFF6366F1)),
///     fontFamily: 'YourFont',
///   ),
///   child: MaterialApp(...),
/// )
/// ```
///
/// 2. Use components:
/// ```dart
/// NbButton.primary(label: 'Checkout', onPressed: () {})
/// NbCard.elevated(child: NbText.headline('Hello'))
/// NbText.body('Regular content text')
/// ```
///
/// ## Install via pubspec.yaml
/// ```yaml
/// dependencies:
///   neo_brutalism_ui:
///     git:
///       url: https://github.com/viinkepin/flutter-neo-brutalism.git
///       ref: main
/// ```
library;

// ─── Theme ────────────────────────────────────────────────────────────────────
export 'src/theme/nb_color_scheme.dart' show NbColorScheme;
export 'src/theme/nb_theme_data.dart' show NbThemeData;
export 'src/theme/nb_theme.dart' show NbTheme, NbThemeExtension;

// ─── Tokens ───────────────────────────────────────────────────────────────────
export 'src/tokens/nb_typography.dart' show NbTypography;

// ─── Components ───────────────────────────────────────────────────────────────
export 'src/components/nb_text.dart' show NbText, NbTextVariant;
export 'src/components/nb_button.dart' show NbButton, NbButtonVariant, NbButtonSize;
export 'src/components/nb_card.dart' show NbCard, NbCardVariant;
export 'src/components/nb_text_field.dart' show NbTextField, NbTextarea, NbTextareaField;
export 'src/components/nb_switch.dart' show NbSwitch, NbSwitchLabelPosition;
export 'src/components/nb_checkbox.dart' show NbCheckbox;
export 'src/components/nb_radio.dart' show NbRadio, NbRadioGroup, NbRadioOption;
export 'src/components/nb_select.dart' show NbSelect, NbSelectOption;
export 'src/components/nb_accordion.dart' show NbAccordion, NbAccordionGroup, NbAccordionItem;
export 'src/components/nb_upload.dart' show NbFileUpload, NbPhotoUpload, NbPhotoUploadShape;
export 'src/components/nb_chip.dart' show NbChip, NbChipVariant, NbChipGroup, NbChipOption;
export 'src/components/nb_number_stepper.dart' show NbNumberStepper;
export 'src/components/nb_combobox.dart' show NbCombobox, NbComboboxOption;
export 'src/components/nb_autocomplete.dart' show NbAutocomplete;
export 'src/components/nb_dialog.dart' show NbDialog;
export 'src/components/nb_tab.dart' show NbTabBar;
export 'src/components/nb_appbar.dart' show NbAppBar, NbAppBarAction;
export 'src/components/nb_navbar.dart' show NbNavBar, NbNavItem;
export 'src/components/nb_popup_menu.dart' show NbPopupMenuButton, NbPopupMenuItem;
export 'src/components/nb_drawer.dart' show NbDrawer, NbDrawerItem, NbDrawerSection, NbDrawerHeader;
export 'src/components/nb_date_picker.dart' show NbDatePicker;
export 'src/components/nb_product_list.dart'
    show NbProductItem, NbProductGridView, NbProductListView;
