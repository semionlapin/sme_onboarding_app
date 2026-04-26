import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/wio_theme.dart';

/// Visual style variants matching the Figma "Type" property in the
/// "Button CTA" Component Set (file: Gamechanger, node 25:972).
///
/// Taxonomy:
/// - [primary]          Retail theme — filled violet   (sf1 bg / p2 text)
/// - [primaryDark]      SME theme   — filled navy      (sf3 bg / p2 text)
/// - [destructive]      Warning     — filled red        (sf4 bg / p2 text)
/// - [secondary]        Retail      — outlined violet   (br2 border / p1 text)
/// - [secondaryDark]    SME         — outlined navy     (br1 border / s1 text)
/// - [transparent]      Ghost       — no chrome         (p1 text, AktivGrotesk Medium)
/// - [link]             Inline link — no underline      (p1 text, WioGrotesk Regular)
/// - [linkUnderline]    Inline link — with underline    (p1 text, WioGrotesk Regular)
/// - [inverse]          Dark bg     — filled white      (p2 bg / p3 text)
/// - [secondaryInverse] Dark bg     — outlined white    (p2 border / p2 text)
enum ButtonCTAType {
  primary,
  primaryDark,
  destructive,
  secondary,
  secondaryDark,
  transparent,
  link,
  linkUnderline,

  /// Inverse primary — for dark/coloured backgrounds.
  /// White fill (`WioTheme.p2`), deep-navy text (`WioTheme.p3`), no border.
  /// Used exclusively by [WioResultTemplate] for the mandatory primary CTA.
  inverse,

  /// Inverse secondary — for dark/coloured backgrounds.
  /// White outline (`WioTheme.p2` border), white text (`WioTheme.p2`), no fill.
  /// Pair with [inverse] on dark screens; never use on light backgrounds.
  secondaryInverse,
}

/// Wio Bank CTA Button, pixel-faithful to the Figma "Button CTA" Component Set.
///
/// ### Layout (Default size, from Figma)
/// - Height: 48 dp
/// - Horizontal padding: [WioTheme.spaceLg] (16 dp)
/// - Icon ↔ text gap: [WioTheme.spaceSm] (8 dp)
/// - Corner radius: [WioTheme.radiusInput] (10 dp)
/// - Icon size: 20 × 20 dp
///
/// ### Hover
/// [WioTheme.ov3] (rgba 255,255,255,0.20) is blended directly into the fill
/// colour via [Color.alphaBlend], producing a visibly lighter tint on filled
/// buttons. Outlined / ghost buttons reveal [WioTheme.ov2] (rgba 15,26,56,0.04)
/// as a subtle navy fill. Both transitions animate through [AnimatedContainer]'s
/// built-in [DecorationTween] over 200 ms — no separate overlay widget is used.
/// Link variants use an opacity fade to 72% instead.
///
/// ### Press shimmer
/// On [TapDownDetails], a two-layer reflective shimmer plays at the tap
/// co-ordinate:
/// 1. A radial white glow that expands from the touch point outward.
/// 2. A narrow diagonal streak that sweeps from left to right across
///    the surface — evoking light reflecting off glass.
/// Both layers use [BlendMode.screen] so they brighten any fill colour
/// without bleaching. Duration: 650 ms, [Curves.easeOut].
///
/// ### Scale feedback
/// A subtle 2 % scale-down ([AnimatedScale] to 0.98×) on press gives
/// tactile depth. Releases in 100 ms.
///
/// ### Background transitions
/// [AnimatedContainer] interpolates the fill and border colours over
/// 200 ms whenever [onPressed] or [isLoading] changes state.
///
/// ### Disabled state
/// Pass `onPressed: null`. Filled buttons show [WioTheme.sf6] bg;
/// outlined buttons show [WioTheme.br6]; text/icon become [WioTheme.disabledFg].
/// No hover or shimmer fires when disabled.
///
/// ### Loading state
/// [isLoading] replaces content with a [CircularProgressIndicator] in the
/// active text colour, absorbs taps, and retains the active background.
class ButtonCTA extends StatefulWidget {
  const ButtonCTA({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonCTAType.primary,
    this.iconPath,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonCTAType type;

  /// Path to an SVG asset rendered via [SvgPicture.asset].
  /// A [ColorFilter] forces it to match the button's text colour.
  final String? iconPath;

  /// When true, replaces text + icon with a spinner and blocks taps,
  /// while keeping the *active* (non-disabled) background colour.
  final bool isLoading;

  @override
  State<ButtonCTA> createState() => _ButtonCTAState();
}

class _ButtonCTAState extends State<ButtonCTA>
    with SingleTickerProviderStateMixin {
  // ─── Interaction state ─────────────────────────────────────────────────────

  bool _isHovered = false;
  bool _isPressed = false;

  /// Last tap position in local co-ordinates; used as shimmer origin.
  Offset _tapPosition = Offset.zero;

  // ─── Shimmer animation ─────────────────────────────────────────────────────

  late final AnimationController _shimmerController;

  /// Curved progress 0 → 1, driving [_ShimmerPainter].
  late final Animation<double> _shimmerProgress;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _shimmerProgress = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  // ─── Derived state ─────────────────────────────────────────────────────────

  bool get _isDisabled => widget.onPressed == null;

  /// True only when disabled visuals should render.
  /// [widget.isLoading] overrides disabled look — retains active colours.
  bool get _showDisabled => _isDisabled && !widget.isLoading;

  /// Link variants have no container — intrinsic text width.
  bool get _isContained =>
      widget.type != ButtonCTAType.link &&
      widget.type != ButtonCTAType.linkUnderline;

  bool get _isInteractive => !_showDisabled && !widget.isLoading;

  // ─── Colour derivation ─────────────────────────────────────────────────────

  Color get _activeTextColor {
    switch (widget.type) {
      case ButtonCTAType.primary:
      case ButtonCTAType.primaryDark:
      case ButtonCTAType.destructive:
        return WioTheme.p2; // white — on dark fills
      case ButtonCTAType.secondaryDark:
        return WioTheme.s1; // deep navy
      case ButtonCTAType.inverse:
        return WioTheme.p3; // deep navy — on white fill
      case ButtonCTAType.secondaryInverse:
        return WioTheme.p2; // white — on dark backgrounds
      case ButtonCTAType.secondary:
      case ButtonCTAType.transparent:
      case ButtonCTAType.link:
      case ButtonCTAType.linkUnderline:
        return WioTheme.p1; // brand violet
    }
  }

  Color get _textColor =>
      _showDisabled ? WioTheme.disabledFg : _activeTextColor;

  Color? get _backgroundColor {
    if (_showDisabled) {
      switch (widget.type) {
        case ButtonCTAType.primary:
        case ButtonCTAType.primaryDark:
        case ButtonCTAType.destructive:
        case ButtonCTAType.inverse:
          return WioTheme.sf6; // pale grey
        default:
          return null;
      }
    }

    // Resolve the base fill for this variant.
    Color? base;
    switch (widget.type) {
      case ButtonCTAType.primary:
        base = WioTheme.sf1; // brand violet
      case ButtonCTAType.primaryDark:
        base = WioTheme.sf3; // deep navy
      case ButtonCTAType.destructive:
        base = WioTheme.sf4; // error red
      case ButtonCTAType.inverse:
        base = WioTheme.p2; // white
      default:
        base = null; // outlined / ghost — no fill
    }

    // Hover tint — baked directly into the color so AnimatedContainer's
    // DecorationTween lerps between base and hovered seamlessly.
    // No separate overlay widget needed (and avoids the DecoratedBox sizing edge-case).
    if (_isHovered && _isInteractive) {
      if (base != null) {
        if (widget.type == ButtonCTAType.inverse) {
          // White fill: blend a subtle dark tint (ov3 is white-on-white = no change).
          return Color.alphaBlend(const Color.fromRGBO(15, 26, 56, 0.08), base);
        }
        // Filled buttons: blend WioTheme.ov3 (rgba 255,255,255,0.20) over the fill.
        // e.g. violet #5700FF → #7833FF — clearly visible lightening.
        return Color.alphaBlend(WioTheme.ov3, base);
      } else {
        if (widget.type == ButtonCTAType.secondaryInverse) {
          // White outline on dark bg: reveal a subtle white tint on hover.
          return const Color.fromRGBO(255, 255, 255, 0.10);
        }
        // Outlined / ghost on light bg: reveal WioTheme.ov2 (rgba 15,26,56,0.04)
        // as a subtle navy tint so the button area responds without jarring colour change.
        return WioTheme.ov2;
      }
    }

    return base;
  }

  Color? get _borderColor {
    if (_showDisabled) {
      switch (widget.type) {
        case ButtonCTAType.secondary:
        case ButtonCTAType.secondaryDark:
        case ButtonCTAType.secondaryInverse:
          return WioTheme.br6; // pale grey border
        default:
          return null;
      }
    }
    switch (widget.type) {
      case ButtonCTAType.secondary:
        return WioTheme.br2; // violet border
      case ButtonCTAType.secondaryDark:
        return WioTheme.br1; // navy border
      case ButtonCTAType.secondaryInverse:
        return WioTheme.p2; // white border — for dark backgrounds
      default:
        return null;
    }
  }

  // ─── Text style ────────────────────────────────────────────────────────────

  TextStyle get _textStyle {
    final base = (widget.type == ButtonCTAType.transparent
            ? WioTheme.b3Medium
            : WioTheme.b3Regular)
        .copyWith(color: _textColor);

    if (widget.type == ButtonCTAType.linkUnderline) {
      return base.copyWith(
        decoration: TextDecoration.underline,
        decorationColor: _textColor,
        letterSpacing: -0.14,
      );
    }
    return base;
  }

  // ─── Interaction handlers ──────────────────────────────────────────────────

  void _onTapDown(TapDownDetails d) {
    setState(() {
      _tapPosition = d.localPosition;
      _isPressed = true;
    });
    _shimmerController.forward(from: 0);
  }

  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final effectiveTap =
        (widget.isLoading || _isDisabled) ? null : widget.onPressed;

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: WioTheme.maxFormWidth),
        child: _isContained
            ? _buildContainedButton(effectiveTap)
            : _buildLinkButton(effectiveTap),
      ),
    );
  }

  // ─── Contained button (all types except link / linkUnderline) ──────────────

  Widget _buildContainedButton(VoidCallback? effectiveTap) {
    return MouseRegion(
      cursor:
          _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (_isInteractive) setState(() => _isHovered = true);
      },
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: _isInteractive ? _onTapDown : null,
        onTapUp: _isInteractive ? _onTapUp : null,
        onTapCancel: _isInteractive ? _onTapCancel : null,
        onTap: effectiveTap,
        child: AnimatedScale(
          scale: (_isPressed && _isInteractive) ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: 48,
            // antiAlias clips ALL stack children (hover overlay + shimmer)
            // to the decoration's borderRadius — no bleed outside the pill.
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: _backgroundColor,
              border: _borderColor != null
                  ? Border.all(color: _borderColor!, width: 1)
                  : null,
              borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            ),
            child: Stack(
              children: [
                // ── 1. Main content ─────────────────────────────────────────
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: WioTheme.spaceLg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildRowChildren(),
                    ),
                  ),
                ),

                // ── 2. Press shimmer ────────────────────────────────────────
                // Isolated in a RepaintBoundary so frame-by-frame painting
                // does not trigger a full button repaint.
                Positioned.fill(
                  child: IgnorePointer(
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _shimmerProgress,
                        builder: (context2, child2) => CustomPaint(
                          painter: _ShimmerPainter(
                            tapPosition: _tapPosition,
                            progress: _shimmerProgress.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Link button (link / linkUnderline) ────────────────────────────────────

  Widget _buildLinkButton(VoidCallback? effectiveTap) {
    return MouseRegion(
      cursor:
          _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (_isInteractive) setState(() => _isHovered = true);
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: effectiveTap,
        child: AnimatedOpacity(
          opacity: (_isHovered && _isInteractive) ? 0.72 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _activeTextColor,
                  ),
                )
              : Text(widget.text, style: _textStyle),
        ),
      ),
    );
  }

  // ─── Row content ───────────────────────────────────────────────────────────

  List<Widget> _buildRowChildren() {
    if (widget.isLoading) {
      return [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: _activeTextColor,
          ),
        ),
      ];
    }

    return [
      if (widget.iconPath != null) ...[
        SvgPicture.asset(
          widget.iconPath!,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(_textColor, BlendMode.srcIn),
        ),
        const SizedBox(width: WioTheme.spaceSm),
      ],
      Text(widget.text, style: _textStyle),
    ];
  }
}

// ─── Shimmer Painter ──────────────────────────────────────────────────────────

/// Draws a two-layer reflective shimmer at [tapPosition].
///
/// Layer 1 — Radial glow
///   A white radial gradient expands from [tapPosition] to the farthest
///   corner of the button. Fades out as it expands.
///
/// Layer 2 — Diagonal streak (starts at 15 % of the animation)
///   A narrow white band sweeps from left to right across the full width.
///   Shaped like a specular highlight on a convex glass surface — bright
///   centre, soft edges, slight asymmetry.
///
/// Both layers use [BlendMode.screen]: on dark fills this produces a bright
/// visible glint; on outlined/transparent buttons it remains subtle.
class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({
    required this.tapPosition,
    required this.progress,
  });

  final Offset tapPosition;

  /// Curved progress value in [0, 1] from [_ButtonCTAState._shimmerProgress].
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final fade = 1.0 - progress;
    final rect = Offset.zero & size;

    // ── Layer 1: Radial glow expanding from tap point ────────────────────────

    // Compute the maximum radius needed to fill the farthest corner.
    final maxRadius = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((c) => (c - tapPosition).distance).reduce(math.max);

    final currentRadius = maxRadius * progress;
    final glowAlpha = (fade * 0.30 * 255).round().clamp(0, 255);

    if (glowAlpha > 0) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = RadialGradient(
            center: Alignment(
              (tapPosition.dx / size.width) * 2 - 1,
              (tapPosition.dy / size.height) * 2 - 1,
            ),
            // Normalise radius so it spans the whole button at progress = 1.
            radius: currentRadius / (size.longestSide * 0.5),
            colors: [
              Colors.white.withAlpha(glowAlpha),
              Colors.white.withAlpha(0),
            ],
          ).createShader(rect)
          ..blendMode = BlendMode.screen,
      );
    }

    // ── Layer 2: Diagonal streak sweeping left → right ───────────────────────

    // Delay streak start until 15 % into animation so the glow leads.
    final streakT = ((progress - 0.15) / 0.85).clamp(0.0, 1.0);
    if (streakT <= 0.0) return;

    final streakAlpha = ((1.0 - streakT) * 0.22 * 255).round().clamp(0, 255);
    if (streakAlpha == 0) return;

    // Streak centre travels from off-left to off-right across the full width.
    const halfW = 48.0;
    final streakX = (-halfW) + (size.width + halfW * 2) * streakT;
    final streakRect = Rect.fromLTRB(
        streakX - halfW, 0, streakX + halfW, size.height);

    canvas.drawRect(
      streakRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // Asymmetric stops: sharp leading edge, soft trailing tail
          colors: [
            Colors.white.withAlpha(0),
            Colors.white.withAlpha(streakAlpha),
            Colors.white.withAlpha((streakAlpha * 0.45).round()),
            Colors.white.withAlpha(0),
          ],
          stops: const [0.0, 0.38, 0.62, 1.0],
        ).createShader(streakRect)
        ..blendMode = BlendMode.screen,
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) =>
      progress != old.progress || tapPosition != old.tapPosition;
}
