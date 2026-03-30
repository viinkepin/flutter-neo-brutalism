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
library neo_brutalism_ui;

// ─── Theme ────────────────────────────────────────────────────────────────────
export 'src/theme/nb_color_scheme.dart' show NbColorScheme;
export 'src/theme/nb_theme_data.dart'   show NbThemeData;
export 'src/theme/nb_theme.dart'        show NbTheme, NbThemeExtension;

// ─── Tokens ───────────────────────────────────────────────────────────────────
export 'src/tokens/nb_typography.dart' show NbTypography;

// ─── Components ───────────────────────────────────────────────────────────────
export 'src/components/nb_text.dart'   show NbText, NbTextVariant;
export 'src/components/nb_button.dart' show NbButton, NbButtonVariant, NbButtonSize;
export 'src/components/nb_card.dart'   show NbCard, NbCardVariant;
