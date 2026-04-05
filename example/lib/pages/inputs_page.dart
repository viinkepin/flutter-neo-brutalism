import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  // ── TextField state ────────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _priceController = TextEditingController();
  final _searchController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;

  // ── Textarea state ─────────────────────────────────────────────────────────
  final _descController = TextEditingController();

  // ── Switch state ───────────────────────────────────────────────────────────
  bool _notifEnabled = true;
  bool _darkMode = false;
  bool _autoSave = true;

  // ── Checkbox state ─────────────────────────────────────────────────────────
  bool _terms = false;
  bool _newsletter = true;
  bool? _selectAll; // tristate
  bool _opt1 = true;
  bool _opt2 = false;
  bool _opt3 = true;

  // ── Radio state ────────────────────────────────────────────────────────────
  String? _payment = 'cash';
  String? _size = 'md';

  // ── Select state ───────────────────────────────────────────────────────────
  String? _category;
  String? _country;
  String? _categoryError;

  // ── File upload state ──────────────────────────────────────────────────────
  String? _uploadedFile;
  bool _hasPhoto = false;

  // ── Chip state ─────────────────────────────────────────────────────────────
  List<String> _selectedCategories = ['food'];
  final List<String> _tags = ['flutter', 'dart', 'mobile'];

  // ── Number Stepper state ───────────────────────────────────────────────────
  int _qty = 1;
  int _adults = 2;
  int _children = 0;

  // ── Combobox state ─────────────────────────────────────────────────────────
  String? _comboCity;
  String? _comboProduct;

  // ── TimePicker state ───────────────────────────────────────────────────────
  TimeOfDay _pickedTime = TimeOfDay.now();
  TimeOfDay _inlineTime = TimeOfDay.now();

  // ── Slider state ───────────────────────────────────────────────────────────
  double _sliderVal = 40;
  double _sliderDivisions = 5;

  // ── MultiSelect state ──────────────────────────────────────────────────────
  List<String> _multiSelected = [];

  // ── Autocomplete state ─────────────────────────────────────────────────────
  static const _allCities = [
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Yogyakarta',
    'Bali',
    'Manado',
  ];
  List<String> _acSuggestions = _allCities;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _priceController.dispose();
    _searchController.dispose();
    _passwordController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _validateEmail(String val) {
    setState(() {
      _emailError = val.isNotEmpty && !val.contains('@') ? 'Enter a valid email address' : null;
    });
  }

  void _syncSelectAll() {
    final all = [_opt1, _opt2, _opt3];
    final checkedCount = all.where((v) => v).length;
    setState(() {
      if (checkedCount == 0) {
        _selectAll = false;
      } else if (checkedCount == all.length) {
        _selectAll = true;
      } else {
        _selectAll = null; // indeterminate
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NbText.headline('Inputs'),
              const SizedBox(height: 4),
              NbText.body('All form components — interactive & stateful.', color: colors.mutedForeground),
              const SizedBox(height: 28),

              // ── TEXT FIELD ─────────────────────────────────────────────────
              _SectionLabel('TextField'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic
                    NbText.labelSmall('BASIC', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'e.g. John Doe',
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    // With leading icon
                    NbText.labelSmall('WITH ICON', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextField(
                      controller: _searchController,
                      label: 'Search',
                      hint: 'Search products...',
                      leading: const Icon(Icons.search_rounded),
                      trailing: _searchController.text.isNotEmpty ? const Icon(Icons.close_rounded) : null,
                      onTrailingTap: () => setState(() => _searchController.clear()),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // With prefix / suffix text
                    NbText.labelSmall('PREFIX & SUFFIX TEXT', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: '0',
                      leadingText: 'Rp ',
                      trailingText: '.00',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),

                    // Password with toggle
                    NbText.labelSmall('PASSWORD', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      leading: const Icon(Icons.lock_outline_rounded),
                      trailing: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onTrailingTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      helperText: 'Minimum 8 characters',
                    ),
                    const SizedBox(height: 16),

                    // Email with validation
                    NbText.labelSmall('WITH VALIDATION', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      leading: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _validateEmail,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 16),

                    // Disabled
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    const NbTextField(
                      label: 'Read-only field',
                      hint: 'This field is disabled',
                      enabled: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── TEXTAREA ───────────────────────────────────────────────────
              _SectionLabel('Textarea'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('MULTI-LINE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextareaField(
                      controller: _descController,
                      label: 'Product Description',
                      hint: 'Describe your product in detail...',
                      helperText: 'Supports multiple lines. Press Enter for new line.',
                      minLines: 4,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITH MAX LENGTH', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextareaField(
                      label: 'Short Bio',
                      hint: 'Tell us about yourself...',
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 200,
                      helperText: 'Max 200 characters',
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('ERROR STATE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbTextareaField(
                      label: 'Notes',
                      hint: 'Enter notes...',
                      minLines: 3,
                      maxLines: 4,
                      errorText: 'This field is required',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── SWITCH ─────────────────────────────────────────────────────
              _SectionLabel('Switch'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('WITH LABEL', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    _SwitchRow(
                      label: 'Enable Notifications',
                      value: _notifEnabled,
                      onChanged: (v) => setState(() => _notifEnabled = v),
                    ),
                    const SizedBox(height: 12),
                    _SwitchRow(
                      label: 'Dark Mode',
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                    ),
                    const SizedBox(height: 12),
                    _SwitchRow(
                      label: 'Auto Save',
                      value: _autoSave,
                      onChanged: (v) => setState(() => _autoSave = v),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    _SwitchRow(label: 'Premium Feature', value: true, onChanged: null),
                    const SizedBox(height: 12),
                    _SwitchRow(label: 'Locked Option', value: false, onChanged: null),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITHOUT LABEL', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        NbSwitch(value: true, onChanged: (_) {}),
                        NbSwitch(value: false, onChanged: (_) {}),
                        NbSwitch(value: true, onChanged: null),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── CHECKBOX ───────────────────────────────────────────────────
              _SectionLabel('Checkbox'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('WITH LABEL', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    NbCheckbox(
                      value: _terms,
                      label: 'I agree to the Terms and Conditions',
                      onChanged: (v) => setState(() => _terms = v ?? false),
                    ),
                    const SizedBox(height: 10),
                    NbCheckbox(
                      value: _newsletter,
                      label: 'Subscribe to newsletter',
                      onChanged: (v) => setState(() => _newsletter = v ?? false),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('TRISTATE (SELECT ALL)', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    NbCheckbox(
                      value: _selectAll,
                      tristate: true,
                      label: 'Select All',
                      onChanged: (v) {
                        setState(() {
                          _selectAll = v;
                          final checked = v == true;
                          _opt1 = checked;
                          _opt2 = checked;
                          _opt3 = checked;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NbCheckbox(
                            value: _opt1,
                            label: 'Option A',
                            onChanged: (v) {
                              setState(() => _opt1 = v ?? false);
                              _syncSelectAll();
                            },
                          ),
                          const SizedBox(height: 8),
                          NbCheckbox(
                            value: _opt2,
                            label: 'Option B',
                            onChanged: (v) {
                              setState(() => _opt2 = v ?? false);
                              _syncSelectAll();
                            },
                          ),
                          const SizedBox(height: 8),
                          NbCheckbox(
                            value: _opt3,
                            label: 'Option C',
                            onChanged: (v) {
                              setState(() => _opt3 = v ?? false);
                              _syncSelectAll();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    const NbCheckbox(value: true, label: 'Checked & disabled', onChanged: null),
                    const SizedBox(height: 8),
                    const NbCheckbox(value: false, label: 'Unchecked & disabled', onChanged: null),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── RADIO ──────────────────────────────────────────────────────
              _SectionLabel('Radio'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('VERTICAL GROUP', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    NbRadioGroup<String>(
                      label: 'Payment Method',
                      groupValue: _payment,
                      onChanged: (v) => setState(() => _payment = v),
                      options: const [
                        NbRadioOption(value: 'cash', label: 'Cash'),
                        NbRadioOption(value: 'card', label: 'Credit / Debit Card'),
                        NbRadioOption(value: 'qris', label: 'QRIS'),
                        NbRadioOption(value: 'transfer', label: 'Bank Transfer'),
                        NbRadioOption(value: 'crypto', label: 'Crypto', disabled: true),
                      ],
                    ),
                    const SizedBox(height: 20),
                    NbText.labelSmall('HORIZONTAL GROUP', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    NbRadioGroup<String>(
                      label: 'Size',
                      groupValue: _size,
                      onChanged: (v) => setState(() => _size = v),
                      direction: Axis.horizontal,
                      options: const [
                        NbRadioOption(value: 'sm', label: 'S'),
                        NbRadioOption(value: 'md', label: 'M'),
                        NbRadioOption(value: 'lg', label: 'L'),
                        NbRadioOption(value: 'xl', label: 'XL'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── SELECT ─────────────────────────────────────────────────────
              _SectionLabel('Select'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('BASIC', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbSelect<String>(
                      label: 'Category',
                      hint: 'Select a category',
                      required: true,
                      value: _category,
                      onChanged: (v) => setState(() {
                        _category = v;
                        _categoryError = v == null ? 'Please select a category' : null;
                      }),
                      errorText: _categoryError,
                      options: const [
                        NbSelectOption(value: 'food', label: 'Food & Beverage'),
                        NbSelectOption(value: 'retail', label: 'Retail'),
                        NbSelectOption(value: 'service', label: 'Service'),
                        NbSelectOption(value: 'digital', label: 'Digital Product'),
                        NbSelectOption(value: 'fashion', label: 'Fashion'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITH ICONS', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbSelect<String>(
                      label: 'Country',
                      hint: 'Choose your country',
                      value: _country,
                      clearable: true,
                      onChanged: (v) => setState(() => _country = v),
                      helperText: 'Tap × to clear selection',
                      options: [
                        NbSelectOption(
                          value: 'id',
                          label: '🇮🇩  Indonesia',
                          leading: const Icon(Icons.flag_rounded),
                        ),
                        NbSelectOption(
                          value: 'sg',
                          label: '🇸🇬  Singapore',
                          leading: const Icon(Icons.flag_rounded),
                        ),
                        NbSelectOption(
                          value: 'my',
                          label: '🇲🇾  Malaysia',
                          leading: const Icon(Icons.flag_rounded),
                        ),
                        NbSelectOption(
                          value: 'th',
                          label: '🇹🇭  Thailand',
                          leading: const Icon(Icons.flag_rounded),
                        ),
                        NbSelectOption(
                          value: 'vn',
                          label: '🇻🇳  Vietnam',
                          leading: const Icon(Icons.flag_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    const NbSelect<String>(
                      label: 'Outlet',
                      hint: 'No outlets available',
                      enabled: false,
                      options: [],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── ACCORDION ──────────────────────────────────────────────────
              _SectionLabel('Accordion'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('STANDALONE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbAccordion(
                      title: 'What is Neo-Brutalism?',
                      leading: const Icon(Icons.help_outline_rounded, size: 18),
                      child: NbText.body(
                        'Neo-Brutalism combines the raw, unapologetic aesthetics of brutalism with modern UI principles. '
                        'Think bold borders, hard offset shadows, flat solid colors, and heavy typography — '
                        'all intentionally "unpolished" to stand out.',
                      ),
                    ),
                    const SizedBox(height: 8),
                    NbAccordion(
                      title: 'How to install this package?',
                      initiallyExpanded: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NbText.body('Add to your pubspec.yaml:'),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.foreground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: NbText.bodySmall(
                              'neo_brutalism_ui:\n  git:\n    url: https://github.com/viinkepin/flutter-neo-brutalism.git\n    ref: main',
                              color: colors.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    NbText.labelSmall('GROUP (one open at a time)', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbAccordionGroup(
                      items: [
                        NbAccordionItem(
                          title: 'Shipping Information',
                          leading: const Icon(Icons.local_shipping_outlined, size: 18),
                          initiallyExpanded: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              NbText.body('Estimated delivery: 2–5 business days'),
                              SizedBox(height: 4),
                              NbText.body('Free shipping on orders above Rp 200.000'),
                            ],
                          ),
                        ),
                        NbAccordionItem(
                          title: 'Return Policy',
                          leading: const Icon(Icons.assignment_return_outlined, size: 18),
                          child: const NbText.body(
                            '30-day return policy. Items must be unused and in original packaging.',
                          ),
                        ),
                        NbAccordionItem(
                          title: 'Payment Methods',
                          leading: const Icon(Icons.payment_rounded, size: 18),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Cash', 'Credit Card', 'QRIS', 'Transfer']
                                .map(
                                  (m) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: colors.muted,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: colors.border, width: 1.5),
                                    ),
                                    child: NbText.labelSmall(m),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── FILE UPLOAD ────────────────────────────────────────────────
              _SectionLabel('File Upload'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('BASIC', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbFileUpload(
                      label: 'Document',
                      required: true,
                      hint: 'Tap to upload file',
                      acceptedTypes: 'PDF · DOC · XLS',
                      maxSizeLabel: 'Max 10 MB',
                      fileName: _uploadedFile,
                      onTap: () {
                        // In real app: trigger FilePicker.platform.pickFiles()
                        setState(() => _uploadedFile = 'laporan_penjualan_maret_2026.pdf');
                      },
                      onClear: () => setState(() => _uploadedFile = null),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('ERROR STATE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    const NbFileUpload(
                      label: 'Required Document',
                      hint: 'Tap to upload file',
                      errorText: 'Please upload the required document',
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    const NbFileUpload(
                      label: 'Attachment',
                      hint: 'File upload unavailable',
                      enabled: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── PHOTO UPLOAD ───────────────────────────────────────────────
              _SectionLabel('Photo Upload'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('SQUARE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NbPhotoUpload(
                          label: 'Product Photo',
                          size: 120,
                          hasImage: _hasPhoto,
                          imageChild: _hasPhoto ? Container(color: const Color(0xFF60A5FA)) : null,
                          hint: 'Add Photo',
                          onTap: () => setState(() => _hasPhoto = true),
                          onClear: () => setState(() => _hasPhoto = false),
                        ),
                        const SizedBox(width: 16),
                        NbPhotoUpload(
                          label: 'Banner',
                          size: 120,
                          hasImage: false,
                          hint: 'Add Photo',
                          helperText: 'Recommended 16:9',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    NbText.labelSmall('CIRCLE (avatar)', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbPhotoUpload(
                      label: 'Profile Photo',
                      size: 100,
                      shape: NbPhotoUploadShape.circle,
                      hasImage: false,
                      hint: 'Add\nPhoto',
                      helperText: 'Square image recommended',
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('ERROR STATE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    const NbPhotoUpload(
                      size: 100,
                      hasImage: false,
                      hint: 'Add Photo',
                      errorText: 'Photo is required',
                    ),
                  ],
                ),
              ),

              // ── CHIPS ──────────────────────────────────────────────────
              const SizedBox(height: 24),
              _SectionLabel('Chips'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('FILTER CHIPS (multi-select)', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbChipGroup<String>(
                      label: 'Category',
                      selectedValues: _selectedCategories,
                      onChanged: (v) => setState(() => _selectedCategories = v),
                      options: const [
                        NbChipOption(value: 'food', label: 'Food'),
                        NbChipOption(value: 'drink', label: 'Drink'),
                        NbChipOption(value: 'dessert', label: 'Dessert'),
                        NbChipOption(value: 'snack', label: 'Snack'),
                        NbChipOption(value: 'combo', label: 'Combo', disabled: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('SINGLE SELECT', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbChipGroup<String>(
                      multiSelect: false,
                      selectedValues: _selectedCategories.isNotEmpty ? [_selectedCategories.last] : [],
                      onChanged: (v) => setState(() => _selectedCategories = v),
                      options: const [
                        NbChipOption(value: 'sm', label: 'Small'),
                        NbChipOption(value: 'md', label: 'Medium'),
                        NbChipOption(value: 'lg', label: 'Large'),
                        NbChipOption(value: 'xl', label: 'XL'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('INPUT CHIPS (deletable tags)', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._tags.map((tag) => NbChip(
                              label: tag,
                              variant: NbChipVariant.input,
                              onDeleted: () => setState(() => _tags.remove(tag)),
                            )),
                        NbChip(
                          label: 'Add tag',
                          variant: NbChipVariant.display,
                          leading: const Icon(Icons.add_rounded),
                          onTap: () => setState(() => _tags.add('new')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISPLAY CHIPS (read-only)', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        NbChip(label: 'New', variant: NbChipVariant.display, leading: const Icon(Icons.fiber_new_rounded)),
                        NbChip(label: 'In Stock', variant: NbChipVariant.display, activeColor: colors.success, selected: true),
                        NbChip(label: 'Sale', variant: NbChipVariant.display, activeColor: colors.danger, selected: true),
                        NbChip(label: 'Disabled', variant: NbChipVariant.display, enabled: false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── NUMBER STEPPER ─────────────────────────────────────────
              _SectionLabel('Number Stepper'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('BASIC', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbNumberStepper(
                      label: 'Quantity',
                      value: _qty,
                      min: 1,
                      max: 99,
                      onChanged: (v) => setState(() => _qty = v),
                      helperText: 'Min 1, Max 99',
                    ),
                    const SizedBox(height: 20),
                    NbText.labelSmall('MULTIPLE STEPPERS', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: NbNumberStepper(
                            label: 'Adults',
                            value: _adults,
                            min: 1,
                            max: 10,
                            onChanged: (v) => setState(() => _adults = v),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NbNumberStepper(
                            label: 'Children',
                            value: _children,
                            min: 0,
                            max: 10,
                            onChanged: (v) => setState(() => _children = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbNumberStepper(
                      label: 'Stock',
                      value: 5,
                      enabled: false,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── COMBOBOX ───────────────────────────────────────────────
              _SectionLabel('Combobox'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('SEARCHABLE SELECT', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbCombobox<String>(
                      label: 'City',
                      hint: 'Search city...',
                      required: true,
                      value: _comboCity,
                      onChanged: (v) => setState(() => _comboCity = v),
                      helperText: 'Opens a searchable bottom sheet',
                      options: const [
                        NbComboboxOption(value: 'jkt', label: 'Jakarta'),
                        NbComboboxOption(value: 'bdg', label: 'Bandung'),
                        NbComboboxOption(value: 'sby', label: 'Surabaya'),
                        NbComboboxOption(value: 'mdn', label: 'Medan'),
                        NbComboboxOption(value: 'smg', label: 'Semarang'),
                        NbComboboxOption(value: 'mkr', label: 'Makassar'),
                        NbComboboxOption(value: 'plg', label: 'Palembang'),
                        NbComboboxOption(value: 'ygy', label: 'Yogyakarta'),
                        NbComboboxOption(value: 'bli', label: 'Bali'),
                        NbComboboxOption(value: 'mnd', label: 'Manado'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITH ICONS + CLEARABLE', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbCombobox<String>(
                      label: 'Product',
                      hint: 'Search product...',
                      value: _comboProduct,
                      clearable: true,
                      onChanged: (v) => setState(() => _comboProduct = v),
                      options: [
                        NbComboboxOption(value: 'p1', label: 'Ayam Geprek Combo', leading: const Icon(Icons.lunch_dining_rounded)),
                        NbComboboxOption(value: 'p2', label: 'Es Teh Manis', leading: const Icon(Icons.local_cafe_rounded)),
                        NbComboboxOption(value: 'p3', label: 'Nasi Goreng Special', leading: const Icon(Icons.rice_bowl_rounded)),
                        NbComboboxOption(value: 'p4', label: 'Paket Hemat A', leading: const Icon(Icons.set_meal_rounded)),
                        NbComboboxOption(value: 'p5', label: 'Bakso Kuah', leading: const Icon(Icons.soup_kitchen_rounded)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── AUTOCOMPLETE ───────────────────────────────────────────
              _SectionLabel('Autocomplete'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('INLINE SUGGESTIONS', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbAutocomplete(
                      label: 'City',
                      hint: 'Type to search...',
                      options: _acSuggestions,
                      leading: const Icon(Icons.location_on_outlined),
                      helperText: 'You can type freely or pick from suggestions',
                      onChanged: (q) {
                        setState(() {
                          _acSuggestions = _allCities.where((c) => c.toLowerCase().contains(q.toLowerCase())).toList();
                        });
                      },
                      onSelected: (v) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITH REQUIRED + ERROR', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbAutocomplete(
                      label: 'Product Name',
                      hint: 'Search or type new...',
                      required: true,
                      errorText: 'Product name is required',
                      options: const [
                        'Ayam Geprek',
                        'Ayam Bakar',
                        'Nasi Goreng',
                        'Mie Goreng',
                        'Bakso',
                        'Soto Ayam',
                      ],
                      onSelected: (v) {},
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISABLED', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    const NbAutocomplete(
                      label: 'Location',
                      hint: 'Autocomplete disabled',
                      options: [],
                      enabled: false,
                    ),
                  ],
                ),
              ),

              // ── TIME PICKER ────────────────────────────────────────────────
              const SizedBox(height: 24),
              _SectionLabel('TimePicker'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('BOTTOM SHEET', color: context.nbColors.mutedForeground),
                    const SizedBox(height: 12),
                    NbButton.secondary(
                      label: 'Pilih Waktu — ${_formatTime(_pickedTime)}',
                      leading: const Icon(Icons.schedule_rounded),
                      onPressed: () async {
                        final t = await NbTimePicker.show(context, initialTime: _pickedTime);
                        if (t != null) setState(() => _pickedTime = t);
                      },
                    ),
                    const SizedBox(height: 20),
                    NbText.labelSmall('INLINE', color: context.nbColors.mutedForeground),
                    const SizedBox(height: 12),
                    NbTimePicker(
                      initialTime: _inlineTime,
                      onChanged: (t) => setState(() => _inlineTime = t),
                    ),
                    const SizedBox(height: 8),
                    NbText.caption('Selected: ${_formatTime(_inlineTime)}', color: context.nbColors.mutedForeground),
                  ],
                ),
              ),

              // ── SLIDER ────────────────────────────────────────────────────
              const SizedBox(height: 24),
              _SectionLabel('Slider'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('CONTINUOUS', color: context.nbColors.mutedForeground),
                    const SizedBox(height: 8),
                    NbSlider(
                      value: _sliderVal,
                      min: 0,
                      max: 100,
                      label: '${_sliderVal.round()}',
                      onChanged: (v) => setState(() => _sliderVal = v),
                    ),
                    NbText.caption('Value: ${_sliderVal.round()}', color: context.nbColors.mutedForeground),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITH DIVISIONS', color: context.nbColors.mutedForeground),
                    const SizedBox(height: 8),
                    NbSlider(
                      value: _sliderDivisions,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: '${_sliderDivisions.round()}',
                      activeColor: context.nbColors.secondary,
                      onChanged: (v) => setState(() => _sliderDivisions = v),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('DISABLED', color: context.nbColors.mutedForeground),
                    const SizedBox(height: 8),
                    NbSlider(value: 0.6, min: 0, max: 1, onChanged: null),
                  ],
                ),
              ),

              // ── MULTI SELECT ──────────────────────────────────────────────
              const SizedBox(height: 24),
              _SectionLabel('MultiSelect'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbMultiSelect<String>(
                      label: 'Kategori Produk',
                      hint: 'Pilih satu atau lebih',
                      required: true,
                      values: _multiSelected,
                      clearable: true,
                      onChanged: (v) => setState(() => _multiSelected = v),
                      options: const [
                        NbSelectOption(value: 'food', label: 'Makanan & Minuman'),
                        NbSelectOption(value: 'electronics', label: 'Elektronik'),
                        NbSelectOption(value: 'fashion', label: 'Fashion'),
                        NbSelectOption(value: 'beauty', label: 'Kecantikan'),
                        NbSelectOption(value: 'home', label: 'Rumah Tangga'),
                        NbSelectOption(value: 'sports', label: 'Olahraga', disabled: true),
                      ],
                    ),
                    if (_multiSelected.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      NbText.caption('Dipilih: ${_multiSelected.join(', ')}', color: context.nbColors.mutedForeground),
                    ],
                  ],
                ),
              ),

              // ── COMPLETE FORM EXAMPLE ──────────────────────────────────────
              const SizedBox(height: 24),
              _SectionLabel('Complete Form Example'),
              const SizedBox(height: 12),
              _CompleteFormExample(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => NbText.title(text);
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NbText.body(label),
        NbSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

// ─── Complete form example ────────────────────────────────────────────────────

class _CompleteFormExample extends StatefulWidget {
  @override
  State<_CompleteFormExample> createState() => _CompleteFormExampleState();
}

class _CompleteFormExampleState extends State<_CompleteFormExample> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _category;
  bool _isFavorite = false;
  bool _isActive = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return NbCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NbText.titleSmall('Add New Product'),
          const SizedBox(height: 4),
          NbText.bodySmall('Fill in the details below', color: colors.mutedForeground),
          const SizedBox(height: 20),
          NbPhotoUpload(
            label: 'Product Photo',
            size: 100,
            hasImage: false,
            hint: 'Add\nPhoto',
          ),
          const SizedBox(height: 16),
          NbTextField(
            controller: _nameCtrl,
            label: 'Product Name',
            hint: 'e.g. Ayam Geprek Combo',
            required: true,
          ),
          const SizedBox(height: 14),
          NbTextField(
            controller: _priceCtrl,
            label: 'Selling Price',
            hint: '0',
            leadingText: 'Rp',
            required: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 14),
          NbSelect<String>(
            label: 'Category',
            hint: 'Select category',
            required: true,
            value: _category,
            onChanged: (v) => setState(() => _category = v),
            options: const [
              NbSelectOption(value: 'food', label: 'Food & Beverage'),
              NbSelectOption(value: 'retail', label: 'Retail'),
              NbSelectOption(value: 'service', label: 'Service'),
            ],
          ),
          const SizedBox(height: 14),
          NbTextareaField(
            controller: _descCtrl,
            label: 'Description',
            hint: 'Describe this product...',
            minLines: 3,
            maxLines: 6,
          ),
          const SizedBox(height: 14),
          _SwitchRow(
            label: 'Mark as Favorite',
            value: _isFavorite,
            onChanged: (v) => setState(() => _isFavorite = v),
          ),
          const SizedBox(height: 12),
          _SwitchRow(
            label: 'Active (visible in POS)',
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
          ),
          const SizedBox(height: 16),
          NbCheckbox(
            value: _acceptTerms,
            label: 'Product data is accurate and ready to sell',
            onChanged: (v) => setState(() => _acceptTerms = v ?? false),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: NbButton.secondary(
                  label: 'Cancel',
                  onPressed: () {},
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NbButton.primary(
                  label: 'Save',
                  onPressed: _acceptTerms ? _submit : null,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  leading: const Icon(Icons.save_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
