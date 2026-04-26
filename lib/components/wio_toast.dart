import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/wio_theme.dart';

/// Visual variant for [WioToast].
enum WioToastType {
  /// Mint-green card. Confirms a successful action.
  success,

  /// Coral-red card. Signals a failure or error.
  error,
}

/// Top-anchored, auto-dismissing toast notification.
///
/// **Usage rule:** Use to confirm actions (Success) or display failures/errors
/// (Error). Never use Flutter's default bottom SnackBar in Wio flows.
///
/// ### Invocation
/// ```dart
/// WioToast.show(
///   context,
///   message: 'Signatory information saved',
///   type: WioToastType.success,
/// );
/// ```
///
/// ### Behaviour
/// - Anchored to the top of the screen (respects safe area).
/// - Slides down + fades in on entry; reverses on exit.
/// - Auto-dismisses after **3.5 seconds**.
/// - The `×` button dismisses immediately and safely cancels the timer.
///
/// ### Design tokens (Figma node 114-7797)
/// | Property        | Success                  | Error                    |
/// |-----------------|--------------------------|--------------------------|
/// | Background      | `WioTheme.sf9` (#B2FFE3) | `#FF817A` (risk-mild)    |
/// | Text / icons    | `WioTheme.s1` (navy)     | `WioTheme.p2` (white)    |
/// | Type icon       | `Success.svg` 40 dp      | `Unhappy.svg` 40 dp      |
/// | Close icon      | `Close.svg` 28 dp        | `Close.svg` 28 dp        |
class WioToast {
  WioToast._();

  /// Shows a [WioToast] above all other content using Flutter's [Overlay].
  static void show(
    BuildContext context, {
    required String message,
    WioToastType type = WioToastType.success,
  }) {
    final overlay = Overlay.of(context);
    bool removed = false;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _WioToastOverlay(
        message: message,
        type: type,
        onDismiss: () {
          if (!removed) {
            removed = true;
            entry.remove();
          }
        },
      ),
    );
    overlay.insert(entry);
  }
}

// ─── Private overlay widget ───────────────────────────────────────────────────

class _WioToastOverlay extends StatefulWidget {
  const _WioToastOverlay({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  final String message;
  final WioToastType type;
  final VoidCallback onDismiss;

  @override
  State<_WioToastOverlay> createState() => _WioToastOverlayState();
}

class _WioToastOverlayState extends State<_WioToastOverlay>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;
  bool _isDismissing = false;

  // ── Timing ─────────────────────────────────────────────────────────────────

  static const Duration _kAutoDismiss   = Duration(milliseconds: 3500);
  static const Duration _kEntryDuration = Duration(milliseconds: 320);
  static const Duration _kExitDuration  = Duration(milliseconds: 220);

  // ── Design tokens ──────────────────────────────────────────────────────────

  // `surface/risk-mild` (#FF817A) is not yet in WioTheme; defined locally.
  static const Color _errorBg = Color(0xFFFF817A);

  Color get _bgColor =>
      widget.type == WioToastType.success ? WioTheme.sf9 : _errorBg;

  Color get _contentColor =>
      widget.type == WioToastType.success ? WioTheme.s1 : WioTheme.p2;

  String get _typeIconPath =>
      widget.type == WioToastType.success
          ? 'assets/icons/Circle success.svg'
          : 'assets/icons/Unhappy.svg';

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: _kEntryDuration,
      reverseDuration: _kExitDuration,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
    _timer = Timer(_kAutoDismiss, _dismiss);
  }

  /// Triggers the exit animation then removes the overlay entry.
  /// Guard prevents double-invocation from concurrent auto/manual triggers.
  void _dismiss() {
    if (_isDismissing) return;
    _isDismissing = true;
    _timer?.cancel();
    _timer = null;
    _ctrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Positioned without `bottom` — intrinsic height only, so taps below the
    // toast pass through to the rest of the UI unblocked.
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: _buildCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    // Material wrapper ensures correct text directionality and ink splash
    // context inside the Overlay.
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(WioTheme.radiusInput),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Type icon — 40 × 40 dp (Figma: "Company icon" left slot)
            SvgPicture.asset(
              _typeIconPath,
              width: 40,
              height: 40,
              colorFilter:
                  ColorFilter.mode(_contentColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 12),
            // Message text
            Expanded(
              child: Text(
                widget.message,
                style: WioTheme.b3Regular.copyWith(
                  color: _contentColor,
                  height: 20 / 14, // Figma lineHeight: 20
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Close button — 28 × 28 dp (Figma: "Company icon" right slot)
            GestureDetector(
              onTap: _dismiss,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 28,
                height: 28,
                child: SvgPicture.asset(
                  'assets/icons/Close.svg',
                  colorFilter:
                      ColorFilter.mode(_contentColor, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
