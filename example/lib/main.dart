import 'package:flutter/material.dart';
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';

void main() {
  runApp(const NbShowcaseApp());
}

class NbShowcaseApp extends StatelessWidget {
  const NbShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NbTheme(
      data: NbThemeData.light(
        colorScheme: NbColorScheme.light(
          primary: const Color(0xFFFDE047), // bold yellow — change to your brand color
        ),
      ),
      child: MaterialApp(
        title: 'Neo Brutalism UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAFAF9),
        ),
        home: const _HomePage(),
      ),
    );
  }
}

// ─── Navigation Shell ─────────────────────────────────────────────────────────

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _tab = 0;

  static const _pages = [
    _DashboardPage(),
    _ComponentsPage(),
    _TypographyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: _pages[_tab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border, width: 2)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                _NavItem(
                  icon: Icons.widgets_rounded,
                  label: 'Components',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
                _NavItem(
                  icon: Icons.text_fields_rounded,
                  label: 'Typography',
                  selected: _tab == 2,
                  onTap: () => setState(() => _tab = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: selected ? Border.all(color: colors.border, width: 2) : null,
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? colors.primaryForeground : colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 2),
            NbText.caption(
              label,
              color: selected ? colors.foreground : colors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dashboard Page ───────────────────────────────────────────────────────────

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

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
              // ── Header ────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NbText.caption('Monday, 30 March 2026',
                            color: colors.mutedForeground),
                        const SizedBox(height: 2),
                        NbText.headline('Good Morning 👋'),
                      ],
                    ),
                  ),
                  NbCard(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.notifications_outlined,
                        size: 22, color: colors.foreground),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Hero Banner ───────────────────────────────────────────
              NbCard.filled(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NbText.titleSmall('Total Revenue',
                              color: colors.primaryForeground),
                          const SizedBox(height: 4),
                          NbText.display('Rp 48.2M',
                              color: colors.primaryForeground),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.arrow_upward_rounded,
                                  size: 14, color: colors.primaryForeground),
                              const SizedBox(width: 4),
                              NbText.bodySmall('+12.4% from last month',
                                  color: colors.primaryForeground),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.primaryForeground.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colors.primaryForeground.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.trending_up_rounded,
                          size: 32, color: colors.primaryForeground),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Stats Row ─────────────────────────────────────────────
              NbText.title('Summary'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Transactions',
                      value: '1,284',
                      icon: Icons.receipt_long_rounded,
                      iconColor: colors.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Products Sold',
                      value: '3,921',
                      icon: Icons.inventory_2_rounded,
                      iconColor: colors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'New Customers',
                      value: '87',
                      icon: Icons.people_rounded,
                      iconColor: colors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Refunds',
                      value: '12',
                      icon: Icons.refresh_rounded,
                      iconColor: colors.danger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Recent Transactions ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NbText.title('Recent Transactions'),
                  NbButton.ghost(
                    label: 'See all',
                    size: NbButtonSize.small,
                    onPressed: () {},
                    trailing: const Icon(Icons.arrow_forward_rounded, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._transactions.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TransactionItem(transaction: t),
                ),
              ),
              const SizedBox(height: 24),

              // ── Top Products ───────────────────────────────────────────
              NbText.title('Top 5 Products'),
              const SizedBox(height: 10),
              NbCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: _topProducts.asMap().entries.map((e) {
                    return _TopProductItem(
                      rank: e.key + 1,
                      product: e.value,
                      isLast: e.key == _topProducts.length - 1,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // ── Quick Actions ──────────────────────────────────────────
              NbText.title('Quick Actions'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: NbButton.primary(
                      label: 'New Sale',
                      isFullWidth: true,
                      onPressed: () {},
                      leading: const Icon(Icons.add_shopping_cart_rounded),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NbButton.secondary(
                      label: 'Export',
                      isFullWidth: true,
                      onPressed: () {},
                      leading: const Icon(Icons.file_download_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dashboard sub-widgets ─────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return NbCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: iconColor.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          NbText.headline(value),
          const SizedBox(height: 2),
          NbText.caption(label, color: colors.mutedForeground),
        ],
      ),
    );
  }
}

class _Transaction {
  const _Transaction({
    required this.name,
    required this.amount,
    required this.time,
    required this.isCredit,
  });

  final String name;
  final String amount;
  final String time;
  final bool isCredit;
}

const _transactions = [
  _Transaction(name: 'Ayam Geprek Combo', amount: 'Rp 45,000', time: '10:24 AM', isCredit: true),
  _Transaction(name: 'Es Teh Manis x3', amount: 'Rp 18,000', time: '10:18 AM', isCredit: true),
  _Transaction(name: 'Refund — Nasi Goreng', amount: 'Rp 35,000', time: '09:52 AM', isCredit: false),
  _Transaction(name: 'Paket Hemat A', amount: 'Rp 62,000', time: '09:30 AM', isCredit: true),
];

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.transaction});

  final _Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    final color = transaction.isCredit ? colors.success : colors.danger;
    return NbCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Icon(
              transaction.isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NbText.label(transaction.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                NbText.caption(transaction.time, color: colors.mutedForeground),
              ],
            ),
          ),
          NbText.label(
            transaction.isCredit
                ? '+${transaction.amount}'
                : '-${transaction.amount}',
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _Product {
  const _Product({required this.name, required this.qty});

  final String name;
  final int qty;
}

const _topProducts = [
  _Product(name: 'Ayam Geprek Combo', qty: 284),
  _Product(name: 'Es Teh Manis', qty: 219),
  _Product(name: 'Nasi Goreng Special', qty: 196),
  _Product(name: 'Paket Hemat A', qty: 153),
  _Product(name: 'Bakso Kuah', qty: 134),
];

class _TopProductItem extends StatelessWidget {
  const _TopProductItem({
    required this.rank,
    required this.product,
    required this.isLast,
  });

  final int rank;
  final _Product product;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.muted, width: 1.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank == 1 ? colors.primary : colors.muted,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.border, width: 1.5),
            ),
            child: Center(
              child: NbText.labelSmall(
                '$rank',
                color: rank == 1
                    ? colors.primaryForeground
                    : colors.mutedForeground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: NbText.label(product.name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          NbText.label('${product.qty} sold', color: colors.mutedForeground),
        ],
      ),
    );
  }
}

// ─── Components Page ──────────────────────────────────────────────────────────

class _ComponentsPage extends StatelessWidget {
  const _ComponentsPage();

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
              NbText.headline('Components'),
              const SizedBox(height: 4),
              NbText.body('All components respect the active NbTheme.',
                  color: colors.mutedForeground),
              const SizedBox(height: 28),

              // ── Buttons ────────────────────────────────────────────────
              NbText.title('Buttons'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('VARIANTS', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        NbButton.primary(label: 'Primary', onPressed: () {}),
                        NbButton.secondary(label: 'Secondary', onPressed: () {}),
                        NbButton.danger(label: 'Danger', onPressed: () {}),
                        NbButton(
                          label: 'Success',
                          variant: NbButtonVariant.success,
                          onPressed: () {},
                        ),
                        NbButton.ghost(label: 'Ghost', onPressed: () {}),
                        NbButton.primary(label: 'Disabled', onPressed: null),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('SIZES', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        NbButton.primary(
                            label: 'Small',
                            size: NbButtonSize.small,
                            onPressed: () {}),
                        NbButton.primary(
                            label: 'Medium',
                            size: NbButtonSize.medium,
                            onPressed: () {}),
                        NbButton.primary(
                            label: 'Large',
                            size: NbButtonSize.large,
                            onPressed: () {}),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('WITH ICONS', color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        NbButton.primary(
                          label: 'Add Item',
                          onPressed: () {},
                          leading: const Icon(Icons.add_rounded),
                        ),
                        NbButton.secondary(
                          label: 'Download',
                          onPressed: () {},
                          leading: const Icon(Icons.file_download_outlined),
                        ),
                        NbButton.danger(
                          label: 'Delete',
                          onPressed: () {},
                          leading: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('LOADING & FULL WIDTH',
                        color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    NbButton.primary(
                        label: 'Loading…', onPressed: () {}, isLoading: true),
                    const SizedBox(height: 8),
                    NbButton.primary(
                      label: 'Full Width Primary',
                      onPressed: () {},
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 8),
                    NbButton.secondary(
                      label: 'Full Width Secondary',
                      onPressed: () {},
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Cards ──────────────────────────────────────────────────
              NbText.title('Cards'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NbText.labelSmall('FLAT (default)',
                        color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbCard(
                      padding: const EdgeInsets.all(14),
                      child: NbText.body(
                          'Flat — border only, no shadow. Use for list items and inner content.'),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('ELEVATED (hard shadow)',
                        color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbCard.elevated(
                      padding: const EdgeInsets.all(14),
                      child: NbText.body(
                          'Elevated — hard 4px offset shadow. Use for primary content sections.'),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('FILLED', color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbCard.filled(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.all(14),
                      child: NbText.body('Filled — bold background color.',
                          color: colors.primaryForeground),
                    ),
                    const SizedBox(height: 8),
                    NbCard.filled(
                      backgroundColor: colors.success,
                      padding: const EdgeInsets.all(14),
                      child: NbText.body('Success filled.',
                          color: colors.successForeground),
                    ),
                    const SizedBox(height: 16),
                    NbText.labelSmall('TAPPABLE (press animation)',
                        color: colors.mutedForeground),
                    const SizedBox(height: 10),
                    NbCard.elevated(
                      padding: const EdgeInsets.all(14),
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.touch_app_rounded,
                              size: 20, color: colors.primary),
                          const SizedBox(width: 10),
                          NbText.body('Tap me — press into the shadow!'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Typography Page ──────────────────────────────────────────────────────────

class _TypographyPage extends StatelessWidget {
  const _TypographyPage();

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
              NbText.headline('Typography'),
              const SizedBox(height: 4),
              NbText.body(
                'The NbTypography scale — bold, tight, commanding.',
                color: colors.mutedForeground,
              ),
              const SizedBox(height: 24),

              NbCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TypeRow('display', '36 · w800', NbText.display('Display')),
                    _TypeDivider(),
                    _TypeRow('headline', '28 · w800', NbText.headline('Headline')),
                    _TypeDivider(),
                    _TypeRow('title', '20 · w700', NbText.title('Title')),
                    _TypeDivider(),
                    _TypeRow('titleSmall', '16 · w700', NbText.titleSmall('Title Small')),
                    _TypeDivider(),
                    _TypeRow('body', '14 · w500', NbText.body('Body — regular content.')),
                    _TypeDivider(),
                    _TypeRow('bodySmall', '12 · w500', NbText.bodySmall('Body Small — secondary.')),
                    _TypeDivider(),
                    _TypeRow('label', '13 · w600', NbText.label('Label — buttons, form fields.')),
                    _TypeDivider(),
                    _TypeRow('labelSmall', '11 · w600', NbText.labelSmall('Label Small — badges.')),
                    _TypeDivider(),
                    _TypeRow('caption', '10 · w500', NbText.caption('Caption — metadata.')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              NbText.title('Color Palette'),
              const SizedBox(height: 12),
              NbCard(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ColorSwatch('primary', colors.primary, colors.primaryForeground),
                    _ColorSwatch('secondary', colors.secondary, colors.secondaryForeground),
                    _ColorSwatch('success', colors.success, colors.successForeground),
                    _ColorSwatch('danger', colors.danger, colors.dangerForeground),
                    _ColorSwatch('warning', colors.warning, colors.warningForeground),
                    _ColorSwatch('muted', colors.muted, colors.mutedForeground),
                    _ColorSwatch('surface', colors.surface, colors.foreground),
                    _ColorSwatch('foreground', colors.foreground, colors.surface),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow(this.name, this.spec, this.example);

  final String name;
  final String spec;
  final Widget example;

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NbText.labelSmall(name),
                NbText.caption(spec, color: colors.mutedForeground),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: example),
        ],
      ),
    );
  }
}

class _TypeDivider extends StatelessWidget {
  const _TypeDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: context.nbColors.muted, thickness: 1, height: 1);
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.name, this.color, this.fg);

  final String name;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: NbText.caption(name, color: fg, fontWeight: FontWeight.w700),
    );
  }
}
