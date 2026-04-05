import 'package:flutter/material.dart';
import 'package:neo_brutalism_ui/neo_brutalism_ui.dart';

// ─── Sample data ──────────────────────────────────────────────────────────────

final _sampleProducts = [
  NbProductItem(
    title: 'Wireless Noise-Cancelling Headphones',
    price: '\$79.99',
    originalPrice: '\$129.99',
    badge: 'Sale',
    rating: 4.5,
    reviewCount: 128,
    image: Container(color: const Color(0xFF6366F1)),
    onTap: () {},
    onAddToCart: () {},
  ),
  NbProductItem(
    title: 'Mechanical Keyboard RGB',
    price: '\$149.00',
    badge: 'New',
    badgeColor: const Color(0xFF4ADE80),
    rating: 4.0,
    reviewCount: 54,
    image: Container(color: const Color(0xFFFBBF24)),
    onTap: () {},
    onAddToCart: () {},
  ),
  NbProductItem(
    title: 'Ergonomic Mouse',
    price: '\$39.99',
    rating: 3.5,
    reviewCount: 210,
    image: Container(color: const Color(0xFFF472B6)),
    onTap: () {},
    onAddToCart: () {},
  ),
  NbProductItem(
    title: 'USB-C Hub 7-in-1',
    price: '\$49.99',
    originalPrice: '\$64.99',
    badge: 'Sale',
    image: Container(color: const Color(0xFF22D3EE)),
    onTap: () {},
    onAddToCart: () {},
  ),
  NbProductItem(
    title: 'Portable SSD 1TB',
    price: '\$89.00',
    rating: 5.0,
    reviewCount: 347,
    image: Container(color: const Color(0xFFA78BFA)),
    onTap: () {},
    onAddToCart: () {},
  ),
  NbProductItem(
    title: 'Webcam 4K Auto-Focus',
    price: '\$119.99',
    originalPrice: '\$159.99',
    badge: 'Sale',
    rating: 4.5,
    reviewCount: 92,
    image: Container(color: const Color(0xFFFB923C)),
    onTap: () {},
    onAddToCart: () {},
  ),
];

// ─── Page ─────────────────────────────────────────────────────────────────────

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  bool _isGrid = true;
  bool _showProducts = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.nbColors;
    final theme = context.nbTheme;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // ── Header ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NbText.headline('Product Listing'),
              const SizedBox(height: 4),
              NbText.body(
                '${_sampleProducts.length} items',
                color: colors.mutedForeground,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: NbText.labelSmall(
                      _isGrid ? 'GRID VIEW' : 'LIST VIEW',
                      color: colors.mutedForeground,
                    ),
                  ),
                  _ViewToggle(
                    isGrid: _isGrid,
                    onToggle: (v) => setState(() => _isGrid = v),
                    colors: colors,
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Product list ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle empty state
                Row(
                  children: [
                    NbText.labelSmall('PRODUCTS', color: colors.mutedForeground),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _showProducts = !_showProducts),
                      child: NbText.labelSmall(
                        _showProducts ? 'Show Empty State' : 'Show Products',
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Products or Empty State
                if (_showProducts)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isGrid
                        ? NbProductGridView(
                            key: const ValueKey('grid'),
                            items: _sampleProducts,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          )
                        : NbProductListView(
                            key: const ValueKey('list'),
                            items: _sampleProducts,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                  )
                else
                  NbEmptyState(
                    icon: const Icon(Icons.inventory_2_outlined),
                    title: 'Belum ada produk',
                    subtitle: 'Tambah produk pertamamu untuk mulai berjualan.',
                    action: NbButton.primary(
                      label: 'Tambah Produk',
                      leading: const Icon(Icons.add_rounded),
                      onPressed: () => setState(() => _showProducts = true),
                    ),
                  ),

                const SizedBox(height: 32),

                // ── Skeleton ─────────────────────────────────────────────
                NbText.labelSmall('SKELETON LOADING', color: colors.mutedForeground),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NbSkeleton.avatar(size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NbSkeleton(width: double.infinity, height: 14),
                              const SizedBox(height: 8),
                              NbSkeleton(width: 120, height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NbSkeleton.text(lines: 3),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Table ────────────────────────────────────────────────
                NbText.labelSmall('TABLE', color: colors.mutedForeground),
                const SizedBox(height: 12),
                NbTable(
                  columns: const [
                    NbTableColumn(label: 'Produk', flex: 2),
                    NbTableColumn(label: 'Harga', width: 110),
                    NbTableColumn(label: 'Stok', width: 70),
                    NbTableColumn(label: 'Status', width: 90),
                  ],
                  rows: [
                    [Text('Kopi Arabika'), Text('Rp 25.000'), Text('42'), Text('Aktif')],
                    [Text('Teh Hijau'), Text('Rp 15.000'), Text('18'), Text('Aktif')],
                    [Text('Jus Jeruk'), Text('Rp 18.000'), Text('0'), Text('Habis')],
                    [Text('Es Krim Coklat'), Text('Rp 20.000'), Text('7'), Text('Aktif')],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}

// ─── View toggle ──────────────────────────────────────────────────────────────

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.isGrid,
    required this.onToggle,
    required this.colors,
    required this.theme,
  });

  final bool isGrid;
  final ValueChanged<bool> onToggle;
  final NbColorScheme colors;
  final NbThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(color: colors.border, width: theme.borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleBtn(
            icon: Icons.grid_view_rounded,
            active: isGrid,
            onTap: () => onToggle(true),
            isFirst: true,
            colors: colors,
            theme: theme,
          ),
          Container(
            width: theme.borderWidth,
            height: 36,
            color: colors.border,
          ),
          _ToggleBtn(
            icon: Icons.view_list_rounded,
            active: !isGrid,
            onTap: () => onToggle(false),
            isFirst: false,
            colors: colors,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.icon,
    required this.active,
    required this.onTap,
    required this.isFirst,
    required this.colors,
    required this.theme,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final bool isFirst;
  final NbColorScheme colors;
  final NbThemeData theme;

  @override
  Widget build(BuildContext context) {
    final innerRadius = theme.borderRadius - theme.borderWidth;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? innerRadius : 0),
            bottomLeft: Radius.circular(isFirst ? innerRadius : 0),
            topRight: Radius.circular(isFirst ? 0 : innerRadius),
            bottomRight: Radius.circular(isFirst ? 0 : innerRadius),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? colors.primaryForeground : colors.mutedForeground,
        ),
      ),
    );
  }
}
