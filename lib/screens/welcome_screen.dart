import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../theme/wio_theme.dart';
import 'conversation_screen.dart';

/// Welcome / Splash screen — Phase 1 Hero source.
///
/// Layout (matches Figma node 182:26591 "Splash"):
/// - Flat [WioTheme.bg2] background (dark navy).
/// - Looping, muted video masked into a vertical pill [ClipRRect],
///   wrapped in a [Hero] tagged `'ai_avatar'`.
/// - Brand tagline + CTA buttons float in the lower portion.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Reel.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WioTheme.bg2,
      body: Stack(
        children: [
          // ── Video pill (Hero source) ─────────────────────────────────────
          // Centered horizontally, pinned to top:75 per Figma.
          Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: Center(
              child: Hero(
                tag: 'ai_avatar',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: SizedBox(
                    width: 301,
                    height: 548,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Video (or dark placeholder while loading)
                        _controller.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _controller.value.size.width,
                                  height: _controller.value.size.height,
                                  child: VideoPlayer(_controller),
                                ),
                              )
                            : const ColoredBox(color: WioTheme.sf3),
                        // Bottom-to-top gradient scrim for text contrast
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 120,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  WioTheme.bg2,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Brand text (overlaps pill bottom, Figma y:521) ───────────────
          Positioned(
            top: 521,
            left: WioTheme.spaceXl,
            right: WioTheme.spaceXl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Wio logo — replaces 'Wio Business' text
                SvgPicture.asset(
                  'assets/Loghetto.svg',
                  height: 18,
                ),
                const SizedBox(height: WioTheme.spaceSm),
                // Display headline — Typography/display-base from Figma
                Text(
                  'BORN TO \nBACK YOU',
                  style: TextStyle(
                    fontFamily: 'WioGrotesk_A_Rg',
                    fontWeight: FontWeight.w400,
                    fontSize: 56,
                    height: 58 / 56,
                    letterSpacing: -2,
                    color: const Color(0xFFEFEEE8),
                  ),
                ),
              ],
            ),
          ),

          // ── CTA buttons — SafeArea + 24 dp bottom padding ───────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  WioTheme.spaceXl,
                  0,
                  WioTheme.spaceXl,
                  WioTheme.spaceMd, // 12 dp bottom margin
                ),
                child: Row(
                  children: [
                    // Log in — secondary inverse outline
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WioTheme.s6,
                            side: const BorderSide(color: WioTheme.br4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                WioTheme.radiusInput,
                              ),
                            ),
                          ),
                          child: Text(
                            'Log in',
                            style: WioTheme.b3Regular
                                .copyWith(color: WioTheme.s6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: WioTheme.spaceMd),
                    // Open account — inverse primary (white bg, navy text)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ConversationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WioTheme.p2,
                            foregroundColor: WioTheme.p3,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                WioTheme.radiusInput,
                              ),
                            ),
                          ),
                          child: Text(
                            'Open account',
                            style: WioTheme.b3Regular
                                .copyWith(color: WioTheme.p3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
