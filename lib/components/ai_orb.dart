import 'dart:ui';

import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:flutter/material.dart';

import '../theme/wio_theme.dart';

/// Animated AI Orb — a fluid, heavily-blurred mesh-gradient sphere with a
/// slow 'breathing' scale pulse.
///
/// Visual pipeline (inside → out):
///   1. [AnimatedMeshGradient] — four vibrant WioTheme colour points, moving
///      very slowly (speed: 0.15) so the orb feels calm and alive.
///   2. [ImageFiltered] (σ 40) — heavy Gaussian blur completely melts the
///      hard colour blobs into a seamless liquid gradient.
///   3. [ClipOval] — razor-sharp circular crop; applied *after* the blur so
///      the orb edges stay hard against the dark background.
///   4. [ScaleTransition] — breathing effect whose speed reacts to [isListening].
///
/// Usage:
/// ```dart
/// Hero(tag: 'ai_avatar', child: AiOrb(isListening: _isListening))
/// ```
class AiOrb extends StatefulWidget {
  const AiOrb({super.key, this.isListening = false});

  /// When true the breathing animation runs at 1 s/cycle (active attention).
  /// When false it runs at 9 s/cycle (calm idle state).
  final bool isListening;

  @override
  State<AiOrb> createState() => _AiOrbState();
}

class _AiOrbState extends State<AiOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _scale;

  static const double _kOrbSize = 250.0;

  static const Duration _kIdleDuration   = Duration(milliseconds: 9000);
  static const Duration _kActiveDuration = Duration(milliseconds: 1000);

  /// Palette: vibrant purples, soft pinks, bright blue — no dark/navy values
  /// so every pixel of the orb feels illuminated.
  static const List<Color> _kOrbColors = [
    WioTheme.p1,         // electric violet  #5700FF
    WioTheme.sf12,       // soft lavender    #BB99FD
    WioTheme.br7,        // medium violet    #9966FB
    Color(0xFF3050FF),   // bright cobalt blue
  ];

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      vsync: this,
      duration: widget.isListening ? _kActiveDuration : _kIdleDuration,
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AiOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isListening != widget.isListening) {
      _breathController.duration =
          widget.isListening ? _kActiveDuration : _kIdleDuration;
      // Restart the repeat so the new duration takes effect immediately.
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: ClipOval(
        child: SizedBox.square(
          dimension: _kOrbSize,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
              tileMode: TileMode.clamp,
            ),
            child: AnimatedMeshGradient(
              colors: _kOrbColors,
              options: AnimatedMeshGradientOptions(
                speed: widget.isListening ? 0.8 : 0.15,
                frequency: 2.0,
                amplitude: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
