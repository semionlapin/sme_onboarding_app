import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/wio_theme.dart';

/// Shape of the [RichTile] container.
enum RichTileShape {
  /// Fully round — radius equals half the tile size. Default.
  circle,

  /// Rounded rectangle using [WioTheme.radiusInput] (10 dp).
  rounded,
}

/// Background colour preset for [RichTile], mapped from the Figma
/// "Color" property in the WioPilot xMobile UI Library (node 25264-24088).
///
/// | Enum value    | WioTheme token | Figma "Color" name |
/// |---------------|----------------|--------------------|
/// | [defaultBg]   | sf13 #EEE6FE   | Tertiary           |
/// | [grey]        | sf7  #F5F5F7   | Grey               |
/// | [white]       | sf2  #FFFFFF   | Light              |
/// | [transparent] | no fill + br4  | Border             |
enum RichTileBackground {
  /// Lavender fill — [WioTheme.sf13]. Default.
  defaultBg,

  /// Off-white fill — [WioTheme.sf7].
  grey,

  /// White fill — [WioTheme.sf2].
  white,

  /// No fill; 1 dp [WioTheme.br4] border outline.
  transparent,
}

/// A fixed-size icon tile (avatar / logo / flag / initials) aligned to the
/// Figma "RichTile" component in WioPilot xMobile UI Library.
///
/// ### Supported sizes (dp)
/// 16 · 20 · 28 · 36 · **44** (default) · 64
///
/// ### Content — supply at most one
/// | Property   | Rendering                                       |
/// |------------|-------------------------------------------------|
/// | [iconPath] | SVG via [SvgPicture.asset], tinted to [_contentColor], padded |
/// | [imagePath]| [Image.asset], fills tile, clipped to shape     |
/// | [initials] | ≤ 2 chars in AktivGrotesk Medium, padded        |
/// | [flagPath] | SVG via [SvgPicture.asset], fills tile with no padding, clipped |
///
/// ### Mini-tile badge
/// Pass any [RichTile] to [miniTile]. It renders in the bottom-right corner
/// inside a 2 dp [WioTheme.sf2] white ring that visually "cuts" it from the
/// parent surface. The layout reserves enough space so the badge does not
/// overflow its allocated area.
///
/// ### Flat rendering
/// No elevation or shadow is ever applied — all content is drawn flat.
class RichTile extends StatelessWidget {
  const RichTile({
    super.key,
    this.size = 44.0,
    this.shape = RichTileShape.circle,
    this.background = RichTileBackground.defaultBg,
    this.iconPath,
    this.imagePath,
    this.initials,
    this.flagPath,
    this.miniTile,
  });

  /// Tile diameter / side-length in logical pixels.
  /// Should be one of: 16, 20, 28, 36, 44, 64.
  final double size;

  final RichTileShape shape;
  final RichTileBackground background;

  /// Path to an SVG icon asset rendered via [SvgPicture.asset].
  /// Tinted to match [_contentColor] using [BlendMode.srcIn].
  final String? iconPath;

  /// Path to an image asset. Fills the tile (same clip behaviour as a flag).
  final String? imagePath;

  /// Up to 2 characters shown in AktivGrotesk Medium at a scaled font size.
  final String? initials;

  /// Path to an SVG flag asset rendered via [SvgPicture.asset].
  /// Fills the entire tile with no padding; the tile shape clips it.
  final String? flagPath;

  /// An optional [RichTile] badge positioned in the bottom-right corner,
  /// surrounded by a 2 dp [WioTheme.sf2] white cutout ring.
  final RichTile? miniTile;

  // ─── Sizing ────────────────────────────────────────────────────────────────

  /// Inset padding around non-flag/image content, scaled to [size].
  /// Derived from Figma: 44 dp tile uses p-[10px]; others scaled uniformly.
  double get _padding {
    if (size >= 64) return 16;
    if (size >= 44) return 10;
    if (size >= 36) return 8;
    if (size >= 28) return 6;
    if (size >= 20) return 4;
    return 3;
  }

  /// Side length of the icon / initials content area inside the padding.
  double get _contentSize => size - _padding * 2;

  /// Font size for initials text, proportional to [_contentSize].
  double get _initialsSize {
    if (size >= 64) return 20;
    if (size >= 44) return 14;
    if (size >= 36) return 12;
    if (size >= 28) return 10;
    if (size >= 20) return 8;
    return 7;
  }

  // ─── Colours ───────────────────────────────────────────────────────────────

  /// Fill colour. Returns null for [RichTileBackground.transparent].
  Color? get _bgColor {
    switch (background) {
      case RichTileBackground.defaultBg:    return WioTheme.sf13;
      case RichTileBackground.grey:         return WioTheme.sf7;
      case RichTileBackground.white:        return WioTheme.sf2;
      case RichTileBackground.transparent:  return null;
    }
  }

  /// Foreground tint applied to icons and initials.
  ///
  /// - Lavender (defaultBg) → [WioTheme.p1] (brand violet)
  /// - Everything else      → [WioTheme.s1] (deep navy)
  Color get _contentColor =>
      background == RichTileBackground.defaultBg ? WioTheme.p1 : WioTheme.s1;

  // ─── Shape ─────────────────────────────────────────────────────────────────

  BoxDecoration _buildDecoration() {
    final border = background == RichTileBackground.transparent
        ? Border.all(color: WioTheme.br4, width: 1)
        : null;

    if (shape == RichTileShape.circle) {
      // BoxShape.circle is the cleanest fully-round approach; works with border.
      return BoxDecoration(
        color: _bgColor,
        shape: BoxShape.circle,
        border: border,
      );
    }
    return BoxDecoration(
      color: _bgColor,
      borderRadius: BorderRadius.circular(WioTheme.radiusInput),
      border: border,
    );
  }

  // ─── Mini-tile badge layout ─────────────────────────────────────────────────

  /// Mini-tile size: 40 % of the parent tile's diameter.
  double get _miniSize => size * 0.4;

  /// Extra layout space so the −2 dp bleed does not trigger paint overflow.
  double get _miniExtraSpace => miniTile == null ? 0 : 2.0;

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: _buildDecoration(),
      child: _buildContent(),
    );

    if (miniTile == null) return tile;

    // Reserve 2 dp extra so the −2 dp bleed does not trigger layout overflow.
    return SizedBox(
      width:  size + _miniExtraSpace,
      height: size + _miniExtraSpace,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Parent tile — anchored to the top-left of the SizedBox.
          tile,

          // Mini badge: flat, no white ring, hangs 2 dp off the corner.
          Positioned(
            right: -2,
            bottom: -2,
            child: RichTile(
              size: _miniSize,
              shape: miniTile!.shape,
              background: miniTile!.background,
              iconPath: miniTile!.iconPath,
              imagePath: miniTile!.imagePath,
              initials: miniTile!.initials,
              flagPath: miniTile!.flagPath,
              // no nested mini-tile
            ),
          ),
        ],
      ),
    );
  }

  // ─── Content widget ────────────────────────────────────────────────────────

  Widget _buildContent() {
    // ── Flag / Image: fill the full tile, clipped by Container's decoration ──
    if (flagPath != null) {
      return SvgPicture.asset(
        flagPath!,
        fit: BoxFit.cover,
        // No explicit width/height — the Container provides tight constraints.
      );
    }

    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
      );
    }

    // ── Icon / Initials: centred inside padding ───────────────────────────────
    Widget? inner;

    if (iconPath != null) {
      inner = SvgPicture.asset(
        iconPath!,
        width: _contentSize,
        height: _contentSize,
        colorFilter: ColorFilter.mode(_contentColor, BlendMode.srcIn),
      );
    } else if (initials != null) {
      final label = initials!.length >= 2
          ? initials!.substring(0, 2).toUpperCase()
          : initials!.toUpperCase();
      inner = Text(
        label,
        style: WioTheme.b3Medium.copyWith(
          fontSize: _initialsSize,
          color: _contentColor,
          height: 1.0,
        ),
      );
    }

    if (inner == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Center(child: inner),
    );
  }
}
