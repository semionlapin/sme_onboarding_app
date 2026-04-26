import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/wio_theme.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

/// Size variant for [CompanyLabel], mapped from the Figma "Size" property.
///
/// | Enum      | Figma name | Height (boxed) | Text      |
/// |-----------|------------|----------------|-----------|
/// | [small]   | Small      | 18 dp          | 10 sp b5  |
/// | [regular] | Regular    | 24 dp          | 12 sp b4  |
/// | [large]   | Large      | 38 dp          | 16 sp b2  |
enum CompanyLabelSize { small, regular, large }

/// Colour status for [CompanyLabel], mapped from the Figma "Status" property.
///
/// | Enum        | Fill                              | Content     |
/// |-------------|-----------------------------------|-------------|
/// | [primary]   | [WioTheme.sf1]  violet #5700FF    | white       |
/// | [secondary] | [WioTheme.sf3]  navy   #0F1A38    | white       |
/// | [tertiary]  | [WioTheme.sf13] lavender #EEE6FE  | s1 navy     |
/// | [positive]  | #82EDC6 (surface/success-mild)    | s1 navy     |
/// | [partial]   | [WioTheme.sf10] yellow #FDEEB8    | s1 navy     |
/// | [negative]  | [WioTheme.sf11] pink   #F7D7D0    | s1 navy     |
/// | [muted]     | [WioTheme.sf6]  grey   #E1E2E5    | s4 slate    |
/// | [ghost]     | transparent + 1 dp [WioTheme.br3] | s3 blue-grey|
enum CompanyLabelStatus {
  primary,
  secondary,
  tertiary,
  positive,
  partial,
  negative,
  muted,
  ghost,
}

// ─── Widget ───────────────────────────────────────────────────────────────────

/// A pill-shaped label / tag component aligned to the Figma "CompanyLabel"
/// component set in WioPilot xMobile UI Library (node 19417-30955,
/// file egjfzEW9I2FegV8Hh06t3J).
///
/// ### Configurations (supply at least one of [label] / [iconPath])
/// | Props                      | Result            |
/// |----------------------------|-------------------|
/// | `label` only               | Text pill         |
/// | `iconPath` only            | Icon-only pill    |
/// | `label` + `iconPath`       | Icon + text pill  |
///
/// ### Boxed vs. Unboxed
/// `boxed: true` (default) wraps content in a pill container.
/// `boxed: false` renders bare text / icon coloured to match [status].
///
/// ### Flat rendering
/// No elevation is ever applied.
class CompanyLabel extends StatelessWidget {
  const CompanyLabel({
    super.key,
    this.label,
    this.iconPath,
    this.size    = CompanyLabelSize.regular,
    this.status  = CompanyLabelStatus.tertiary,
    this.boxed   = true,
  }) : assert(
          label != null || iconPath != null,
          'CompanyLabel: provide at least one of label or iconPath.',
        );

  /// Text rendered inside the label. Optional when [iconPath] is set.
  final String? label;

  /// SVG asset path for a leading icon. Optional when [label] is set.
  final String? iconPath;

  final CompanyLabelSize size;
  final CompanyLabelStatus status;

  /// When true (default) content is wrapped in a pill container with a fill or
  /// border. When false only the text / icon is rendered with [status] colour.
  final bool boxed;

  // ─── Figma dimensions ─────────────────────────────────────────────────────

  EdgeInsets get _padding => switch (size) {
        CompanyLabelSize.small   => const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        CompanyLabelSize.regular => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        CompanyLabelSize.large   => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      };

  /// Inner horizontal padding around the text span.
  double get _textPad => switch (size) {
        CompanyLabelSize.small   => 2,
        CompanyLabelSize.regular => 4,
        CompanyLabelSize.large   => 6,
      };

  double get _iconSize => switch (size) {
        CompanyLabelSize.small   => 12,
        CompanyLabelSize.regular => 16,
        CompanyLabelSize.large   => 20,
      };

  TextStyle get _textStyle => switch (size) {
        CompanyLabelSize.small => WioTheme.b5Regular.copyWith(
            color: _contentColor,
            height: 14 / 10,
            letterSpacing: 0.2,
          ),
        CompanyLabelSize.regular => WioTheme.b4Regular.copyWith(
            color: _contentColor,
            height: 16 / 12,
          ),
        CompanyLabelSize.large => WioTheme.b2Regular.copyWith(
            color: _contentColor,
            height: 22 / 16,
          ),
      };

  // ─── Figma colour tokens ──────────────────────────────────────────────────

  /// Figma token: surface/success-mild #82EDC6.
  /// Not yet present in WioTheme; defined locally to stay token-faithful.
  static const Color _successMild = Color(0xFF82EDC6);

  /// Background fill. Null for ghost (border-only) or unboxed.
  Color? get _bgColor => switch (status) {
        CompanyLabelStatus.primary   => WioTheme.sf1,
        CompanyLabelStatus.secondary => WioTheme.sf3,
        CompanyLabelStatus.tertiary  => WioTheme.sf13,
        CompanyLabelStatus.positive  => _successMild,
        CompanyLabelStatus.partial   => WioTheme.sf10,
        CompanyLabelStatus.negative  => WioTheme.sf11,
        CompanyLabelStatus.muted     => WioTheme.sf6,
        CompanyLabelStatus.ghost     => null,
      };

  /// Foreground tint for icons and text.
  /// Boxed: contrast against fill. Unboxed: status brand colour.
  Color get _contentColor {
    if (boxed) {
      return switch (status) {
        CompanyLabelStatus.primary ||
        CompanyLabelStatus.secondary => WioTheme.p2,  // white on dark fills
        CompanyLabelStatus.muted     => WioTheme.s4,  // slate on light grey
        CompanyLabelStatus.ghost     => WioTheme.s3,  // blue-grey on transparent
        _                            => WioTheme.s1,  // navy on all other fills
      };
    }
    // Unboxed: text takes the status brand colour
    return switch (status) {
      CompanyLabelStatus.primary ||
      CompanyLabelStatus.tertiary  => WioTheme.p1,   // violet
      CompanyLabelStatus.secondary => WioTheme.s1,   // navy
      CompanyLabelStatus.positive  => WioTheme.sf5,  // success green
      CompanyLabelStatus.negative  => WioTheme.sf4,  // error red
      CompanyLabelStatus.muted     => WioTheme.s4,   // slate grey
      CompanyLabelStatus.ghost ||
      CompanyLabelStatus.partial   => WioTheme.s3,   // blue-grey
    };
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();
    if (!boxed) return content;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(99),
        border: status == CompanyLabelStatus.ghost
            ? Border.all(color: WioTheme.br3, width: 1)
            : null,
      ),
      child: content,
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconPath != null)
          SvgPicture.asset(
            iconPath!,
            width: _iconSize,
            height: _iconSize,
            colorFilter: ColorFilter.mode(_contentColor, BlendMode.srcIn),
          ),
        if (label != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _textPad),
            child: Text(
              label!,
              style: _textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
