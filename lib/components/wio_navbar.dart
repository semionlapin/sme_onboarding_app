import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/wio_theme.dart';

// ─── Layout constants (from Figma 52:1338 mobile / 52:1447 web) ───────────────

const double _kNavRowHeight = 42.0;
const double _kNavHPad = 24.0; // horizontal padding for row content
const double _kIconSlot = 28.0; // icon container size (Figma spec)
// ignore: unused_element
const double _kTouchTarget = 40.0; // accessible minimum hit area
const double _kProgressH = 4.0; // stepper bar height
const double _kWebVPad = 12.0; // vertical padding added on web only
const double _kDesktopMax = 1200.0; // max content width on web

// ─── WioNavbar ────────────────────────────────────────────────────────────────

/// Wio Bank top navigation bar (Figma 52:1338 mobile / 52:1447 web).
///
/// Switches automatically between [_MobileNavbar] (≤600 dp) and [_WebNavbar]
/// (>600 dp) via [LayoutBuilder].  Background is always [WioTheme.bg1].
///
/// On web the navbar background is full-width while its content (actions,
/// title, stepper) is centre-constrained to [_kDesktopMax] (1200 dp).
///
/// ### Properties
/// - [leftAction] / [rightAction]: any widget; typically a [WioNavAction].
/// - [title]: optional centred label text rendered in [WioTheme.b2Medium].
/// - [progress]: optional `0.0–1.0` stepper value.  When non-null a 4 dp
///   progress bar is painted at the very bottom of the navbar.
///
/// ### Usage
/// ```dart
/// WioNavbar(
///   leftAction: WioNavAction(
///     svgAssetPath: 'assets/icons/Left.svg',
///     onPressed: () => Navigator.of(context).pop(),
///   ),
///   rightAction: WioNavAction(
///     svgAssetPath: 'assets/icons/Help.svg',
///     onPressed: _showHelp,
///   ),
///   title: 'Your details',
///   progress: 0.4,
/// )
/// ```
class WioNavbar extends StatelessWidget {
  const WioNavbar({
    super.key,
    this.leftAction,
    this.rightAction,
    this.title,
    this.progress,
  });

  /// Widget shown on the left side (back / close action slot).
  final Widget? leftAction;

  /// Widget shown on the right side (help / overflow action slot).
  final Widget? rightAction;

  /// Optional centred title.  Rendered in [WioTheme.b2Medium] / [WioTheme.s1].
  final String? title;

  /// Optional stepper value `0.0–1.0`.  Renders a 4 dp progress bar at the
  /// very bottom of the navbar when non-null.  Values are clamped internally.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth > 600) {
          return _WebNavbar(
            leftAction: leftAction,
            rightAction: rightAction,
            title: title,
            progress: progress,
          );
        }
        return _MobileNavbar(
          leftAction: leftAction,
          rightAction: rightAction,
          title: title,
          progress: progress,
        );
      },
    );
  }
}

// ─── Mobile layout ────────────────────────────────────────────────────────────

class _MobileNavbar extends StatelessWidget {
  const _MobileNavbar({
    this.leftAction,
    this.rightAction,
    this.title,
    this.progress,
  });

  final Widget? leftAction;
  final Widget? rightAction;
  final String? title;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: WioTheme.bg1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NavRow(
            leftAction: leftAction,
            rightAction: rightAction,
            title: title,
          ),
          if (progress != null) _ProgressBar(progress: progress!),
        ],
      ),
    );
  }
}

// ─── Web layout ───────────────────────────────────────────────────────────────

class _WebNavbar extends StatelessWidget {
  const _WebNavbar({
    this.leftAction,
    this.rightAction,
    this.title,
    this.progress,
  });

  final Widget? leftAction;
  final Widget? rightAction;
  final String? title;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    // Full-width background; constrained content centred at 1200 dp.
    return ColoredBox(
      color: WioTheme.bg1,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kDesktopMax),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: _kWebVPad),
                child: _NavRow(
                  leftAction: leftAction,
                  rightAction: rightAction,
                  title: title,
                ),
              ),
              if (progress != null) _ProgressBar(progress: progress!),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared nav row ───────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.leftAction,
    required this.rightAction,
    required this.title,
  });

  final Widget? leftAction;
  final Widget? rightAction;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kNavRowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kNavHPad),
        child: Row(
          children: [
            // Left slot — fixed 28 dp slot; content centred within it.
            SizedBox(
              width: _kIconSlot,
              child: Center(
                child: leftAction != null
                    ? OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: leftAction,
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // Middle slot — flexible; shows optional title.
            Expanded(
              child: title != null
                  ? Center(
                      child: Text(
                        title!,
                        style: WioTheme.b2Medium.copyWith(color: WioTheme.s1),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Right slot — fixed 28 dp slot; content centred within it.
            SizedBox(
              width: _kIconSlot,
              child: Center(
                child: rightAction != null
                    ? OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: rightAction,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Progress / stepper bar ───────────────────────────────────────────────────

/// 4 dp pill-shaped progress bar (Figma node 32918:14574).
/// Track: [WioTheme.s6] (#E1E2E5).  Fill: [WioTheme.s1] (#0F1A38).
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(_kNavHPad, 0, _kNavHPad, 4),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final fillWidth = constraints.maxWidth * clamped;
          return Container(
            height: _kProgressH,
            decoration: BoxDecoration(
              color: WioTheme.s6,
              borderRadius: BorderRadius.circular(WioTheme.radiusXXxl),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: fillWidth,
                decoration: BoxDecoration(
                  color: WioTheme.s1,
                  borderRadius: BorderRadius.circular(WioTheme.radiusXXxl),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── WioNavAction ─────────────────────────────────────────────────────────────

/// Standard interactive icon button for [WioNavbar] left/right slots.
///
/// Renders a [_kTouchTarget] (40 dp) accessible hit area around a
/// [_kIconSlot] (28 dp) SVG icon.
///
/// **Hover** — [WioTheme.ov2] (4 % navy tint) fades in over 150 ms.
/// **Press** — deepens to 8 % navy tint via [AnimatedContainer].
/// **Cursor** — [SystemMouseCursors.click] on desktop.
class WioNavAction extends StatefulWidget {
  const WioNavAction({
    super.key,
    required this.svgAssetPath,
    required this.onPressed,
    this.iconColor = WioTheme.s1,
  });

  /// Path to an SVG file inside `assets/icons/`, e.g. `'assets/icons/Left.svg'`.
  final String svgAssetPath;

  /// Tap callback.
  final VoidCallback onPressed;

  /// Tint applied to the SVG via [BlendMode.srcIn]. Defaults to [WioTheme.s1].
  final Color iconColor;

  @override
  State<WioNavAction> createState() => _WioNavActionState();
}

class _WioNavActionState extends State<WioNavAction> {
  bool _hovered = false;
  bool _pressed = false;

  // 4 % navy on hover, 8 % on press — matches button_cta hover/press rhythm.
  Color get _bg {
    if (_pressed) return const Color.fromRGBO(15, 26, 56, 0.08);
    if (_hovered) return WioTheme.ov2; // rgba(15,26,56,0.04)
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _kIconSlot + 16,
          height: _kIconSlot + 16,
          decoration: BoxDecoration(color: _bg, shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              widget.svgAssetPath,
              width: _kIconSlot,
              height: _kIconSlot,
              colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
