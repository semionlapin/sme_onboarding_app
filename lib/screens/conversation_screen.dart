import 'package:flutter/material.dart';

import '../components/ai_orb.dart';
import '../theme/wio_theme.dart';

/// Conversation / AI Avatar screen — Phase 1 Hero destination.
///
/// Layout (matches Figma node 182:26696 "Conversation"):
/// - Flat [WioTheme.bg2] background (dark navy).
/// - Soft radial glow behind the avatar (matches Figma's Ellipse 1644).
/// - Gradient circle wrapped in a [Hero] tagged `'ai_avatar'` — receives the
///   shared-element morph transition from [WelcomeScreen]'s video pill.
/// - Close button (top-left) and iOS home indicator.
class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WioTheme.bg2,
      body: Stack(
        children: [
          // ── Ambient glow (Figma: Ellipse 1644, 392×392 at left:0, top:228) ──
          Positioned(
            left: 0,
            top: 228,
            child: Container(
              width: 392,
              height: 392,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    WioTheme.p1.withOpacity(0.28),
                    WioTheme.bg2.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // ── AI Avatar orb (Hero destination) ────────────────────────────
          // AiOrb is a self-contained 250×250 animated mesh-gradient sphere.
          // The Hero tag 'ai_avatar' must be preserved — it drives the
          // shared-element morph from WelcomeScreen's video pill.
          const Center(
            child: Hero(
              tag: 'ai_avatar',
              child: AiOrb(),
            ),
          ),

          // ── Close button — top-left corner ──────────────────────────────
          // No `right` constraint so the Positioned layer is only as wide as
          // the button itself; SafeArea accounts for the notch/Dynamic Island.
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(Icons.close, color: WioTheme.s2, size: 20),
                  ),
                ),
              ),
            ),
          ),

          // ── iOS home indicator ───────────────────────────────────────────
          const Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 134,
                height: 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: WioTheme.s2,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
