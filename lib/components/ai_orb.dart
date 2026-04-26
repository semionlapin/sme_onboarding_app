import 'dart:ui';

import 'package:animated_mesh_gradient/animated_mesh_gradient.dart';
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
///   4. [ScaleTransition] — 1.0 → 1.05 over 9 s for the breathing effect.
///
/// Usage:
/// ```dart
/// Hero(tag: 'ai_avatar', child: const AiOrb())
/// ```
class AiOrb extends StatefulWidget {
  const AiOrb({super.key});

  @override
  State<AiOrb> createState() => _AiOrbState();
}

class _AiOrbState extends State<AiOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _scale;

  static const double _kOrbSize = 250.0;

  /// Palette: vibrant purples, soft pinks, bright blue — no dark/navy values
  /// so every pixel of the orb feels illuminated.
  ///
  /// Sourced entirely from WioTheme tokens where possible.
  static const List<Color> _kOrbColors = [
    WioTheme.p1,         // electric violet  #5700FF
    WioTheme.sf12,       // soft lavender    #BB99FD  (pink-adjacent)
    WioTheme.br7,        // medium violet    #9966FB
    Color(0xFF3050FF),   // bright cobalt blue
  ];

  @override
  void initState() {
    super.initState();

    // 9-second full-cycle breathing — calm, not jittery.
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
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
      // ClipOval is the outermost shaping layer so the hard circular boundary
      // sits on top of the blurred content — edges stay razor-sharp.
      child: ClipOval(
        child: SizedBox.square(
          dimension: _kOrbSize,
          // ImageFiltered applies the Gaussian blur to the rendered mesh
          // texture before it is composited. sigma 40 completely dissolves
          // any blob boundaries and produces a smooth liquid feel.
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 40,
              sigmaY: 40,
              tileMode: TileMode.clamp, // clamp prevents dark edge bleed
            ),
            child: AnimatedMeshGradient(
              colors: _kOrbColors,
              options: AnimatedMeshGradientOptions(
                speed: 0.15,      // very slow drift — no restless fast motion
                frequency: 2.0,   // larger colour zones → more to blur into
                amplitude: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
