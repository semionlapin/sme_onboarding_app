import 'package:flutter/material.dart';

/// Flat static design token registry for Wio Bank.
///
/// Generated from `wio_raw_tokens.json`.
///
/// Token taxonomy:
/// - **P**  = Primary / ON colors
/// - **S**  = Secondary ON colors
/// - **SF** = Surface colors (element backgrounds)
/// - **BG** = Background colors (screen backgrounds)
/// - **BR** = Border colors
/// - **OV** = Overlay colors (element backgrounds with transparency)
class WioTheme {
  WioTheme._(); // non-instantiable

  // ─── Colors: Primary (P) ──────────────────────────────────────────────────

  /// Primary or ON color 1 — Wio brand violet #5700FF
  static const Color p1 = Color(0xFF5700FF);

  /// Primary or ON color 2 — White #FFFFFF
  static const Color p2 = Color(0xFFFFFFFF);

  /// Primary or ON color 3 — Deep navy #0F1A38
  static const Color p3 = Color(0xFF0F1A38);

  // ─── Colors: Secondary ON (S) ─────────────────────────────────────────────

  /// Secondary ON color 1 — Deep navy #0F1A38
  static const Color s1 = Color(0xFF0F1A38);

  /// Secondary ON color 2 — White #FFFFFF
  static const Color s2 = Color(0xFFFFFFFF);

  /// Secondary ON color 3 — Blue-grey #5F667A
  static const Color s3 = Color(0xFF5F667A);

  /// Secondary ON color 4 — Slate grey #878C9B
  static const Color s4 = Color(0xFF878C9B);

  /// Secondary ON color 5 — Light grey #B7BAC3
  static const Color s5 = Color(0xFFB7BAC3);

  /// Secondary ON color 6 — Pale grey #E1E2E5
  static const Color s6 = Color(0xFFE1E2E5);

  // ─── Colors: Background (BG) ──────────────────────────────────────────────

  /// Background color 1 (screen background) — Off-white #F5F5F7
  static const Color bg1 = Color(0xFFF5F5F7);

  /// Background color 2 (screen background) — Deep navy #0F1A38
  static const Color bg2 = Color(0xFF0F1A38);

  /// Background color 3 (screen background) — White #FFFFFF
  static const Color bg3 = Color(0xFFFFFFFF);

  /// Background color 4 (screen background) — Brand violet #5700FF
  static const Color bg4 = Color(0xFF5700FF);

  // ─── Colors: Surface (SF) ─────────────────────────────────────────────────

  /// Surface color 1 (element background) — Brand violet #5700FF
  static const Color sf1 = Color(0xFF5700FF);

  /// Surface color 2 (element background) — White #FFFFFF
  static const Color sf2 = Color(0xFFFFFFFF);

  /// Surface color 3 (element background) — Deep navy #0F1A38
  static const Color sf3 = Color(0xFF0F1A38);

  /// Surface color 4 (element background) — Error red #FD0D49
  static const Color sf4 = Color(0xFFFD0D49);

  /// Surface color 5 (element background) — Success green #30CF95
  static const Color sf5 = Color(0xFF30CF95);

  /// Surface color 6 (element background) — Pale grey #E1E2E5
  static const Color sf6 = Color(0xFFE1E2E5);

  /// Surface color 7 (element background) — Off-white #F5F5F7
  static const Color sf7 = Color(0xFFF5F5F7);

  /// Surface color 8 (element background) — Warm red #E35445
  static const Color sf8 = Color(0xFFE35445);

  /// Surface color 9 (element background) — Mint green #B2FFE3
  static const Color sf9 = Color(0xFFB2FFE3);

  /// Surface color 10 (element background) — Pale yellow #FDEEB8
  static const Color sf10 = Color(0xFFFDEEB8);

  /// Surface color 11 (element background) — Blush pink #F7D7D0
  static const Color sf11 = Color(0xFFF7D7D0);

  /// Surface color 12 (element background) — Light violet #BB99FD
  static const Color sf12 = Color(0xFFBB99FD);

  /// Surface color 13 (element background) — Lavender #EEE6FE
  static const Color sf13 = Color(0xFFEEE6FE);

  /// Surface color 14 (element background) — Soft violet #CCB3FD
  static const Color sf14 = Color(0xFFCCB3FD);

  /// Surface color 16 (element background) — Warm off-white #F2F1ED
  static const Color sf16 = Color(0xFFF2F1ED);

  /// Surface color 17 (element background) — Light blush #FFE0E8
  static const Color sf17 = Color(0xFFFFE0E8);

  // ─── Colors: Border (BR) ──────────────────────────────────────────────────

  /// Border color 1 — Deep navy #0F1A38
  static const Color br1 = Color(0xFF0F1A38);

  /// Border color 2 — Brand violet #5700FF
  static const Color br2 = Color(0xFF5700FF);

  /// Border color 3 — Slate grey #878C9B
  static const Color br3 = Color(0xFF878C9B);

  /// Border color 4 — Light grey #B7BAC3
  static const Color br4 = Color(0xFFB7BAC3);

  /// Border color 5 — Off-white #F5F5F7
  static const Color br5 = Color(0xFFF5F5F7);

  /// Border color 6 — Pale grey #E1E2E5
  static const Color br6 = Color(0xFFE1E2E5);

  /// Border color 7 — Medium violet #9966FB
  static const Color br7 = Color(0xFF9966FB);

  // ─── Colors: Overlay (OV) — non-const (Color.fromRGBO is a factory) ───────

  /// Overlay color 1 (element background with transparency) — rgba(0, 0, 0, 0.60)
  // ignore: prefer_const_declarations
  static final Color ov1 = const Color.fromRGBO(0, 0, 0, 0.6);

  /// Overlay color 2 (element background with transparency) — rgba(15, 26, 56, 0.04)
  // ignore: prefer_const_declarations
  static final Color ov2 = const Color.fromRGBO(15, 26, 56, 0.04);

  /// Overlay color 3 (element background with transparency) — rgba(255, 255, 255, 0.20)
  // ignore: prefer_const_declarations
  static final Color ov3 = const Color.fromRGBO(255, 255, 255, 0.2);

  // ─── Typography ───────────────────────────────────────────────────────────
  //
  // Font family mapping (from JSON → pubspec asset):
  //   "Wio Grotesk App"    →  WioGrotesk_A_Rg   (Regular weight file)
  //   "Aktiv Grotesk App"  →  AktivGrotesk_A_Md (Medium weight file)
  //
  // fontWeight mapping:
  //   "Regular" → FontWeight.w400
  //   "Medium"  → FontWeight.w500
  //   "Bold"    → FontWeight.w700

  /// H1 Regular — WioGrotesk_A_Rg / 40sp / w400
  static const TextStyle h1Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 40,
  );

  /// H2 Medium — AktivGrotesk_A_Md / 34sp / w500
  static const TextStyle h2Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 34,
  );

  /// H2 Regular — WioGrotesk_A_Rg / 34sp / w400
  static const TextStyle h2Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 34,
  );

  /// H3 Medium — AktivGrotesk_A_Md / 24sp / w500
  static const TextStyle h3Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 24,
  );

  /// H3 Regular — WioGrotesk_A_Rg / 24sp / w400
  static const TextStyle h3Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 24,
  );

  /// H4 Medium — AktivGrotesk_A_Md / 20sp / w500
  static const TextStyle h4Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  /// H4 Regular — WioGrotesk_A_Rg / 20sp / w400
  static const TextStyle h4Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  /// B1 Regular — WioGrotesk_A_Rg / 18sp / w400
  static const TextStyle b1Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );

  /// B2 Medium — AktivGrotesk_A_Md / 16sp / w500
  static const TextStyle b2Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  /// B2 Regular — WioGrotesk_A_Rg / 16sp / w400
  static const TextStyle b2Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  /// B3 Medium — AktivGrotesk_A_Md / 14sp / w500
  static const TextStyle b3Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  /// B3 Regular — WioGrotesk_A_Rg / 14sp / w400
  static const TextStyle b3Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  /// B4 Medium — AktivGrotesk_A_Md / 12sp / w500
  static const TextStyle b4Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  /// B4 Regular — WioGrotesk_A_Rg / 12sp / w400
  static const TextStyle b4Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  /// B5 Medium — AktivGrotesk_A_Md / 10sp / w500
  static const TextStyle b5Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  /// B5 Regular — WioGrotesk_A_Rg / 10sp / w400
  static const TextStyle b5Regular = TextStyle(
    fontFamily: 'WioGrotesk_A_Rg',
    fontWeight: FontWeight.w400,
    fontSize: 10,
  );

  /// B6 Medium — AktivGrotesk_A_Md / 8sp / w500
  static const TextStyle b6Medium = TextStyle(
    fontFamily: 'AktivGrotesk_A_Md',
    fontWeight: FontWeight.w500,
    fontSize: 8,
  );

  // ─── Spacing (4-point grid) ───────────────────────────────────────────────

  static const double spaceXs   = 4.0;
  static const double spaceSm   = 8.0;
  static const double spaceMd   = 12.0;
  static const double spaceLg   = 16.0;
  static const double spaceXl   = 24.0;
  static const double spaceXxl  = 32.0;
  static const double spaceXXxl = 36.0;

  // ─── Colors: Disabled Foreground ──────────────────────────────────────────

  /// Disabled foreground (text / icon) — rgba(15, 26, 56, 0.52)
  /// Used on all disabled button variants regardless of type.
  // ignore: prefer_const_declarations
  static final Color disabledFg = const Color.fromRGBO(15, 26, 56, 0.52);

  // ─── Border Radii ─────────────────────────────────────────────────────────

  static const double radiusSm    = 8.0;
  /// Corner radius for interactive form elements (buttons, inputs) — 10dp
  static const double radiusInput = 10.0;
  static const double radiusMd    = 16.0;
  static const double radiusXXxl  = 100.0;

  /// Maximum width for form elements (buttons, inputs) on desktop
static const double maxFormWidth = 550.0;

  // ─── Gradients ────────────────────────────────────────────────────────────

  /// Midnight — dark purple → deep navy (radial in Figma, approximated as
  /// linear). Gradient radiates from bottom-centre (violet #411F7C) upward to
  /// deep navy #0F1A38. Figma node 130-29419.
  static const LinearGradient midnightGradient = LinearGradient(
    begin: Alignment(-0.1, 1.0),
    end: Alignment(0.1, -1.0),
    colors: [Color(0xFF411F7C), Color(0xFF281D5A), Color(0xFF0F1A38)],
    stops: [0.106, 0.460, 0.814],
  );

  /// Peach — blush pink #F7D7D0 → soft lavender #DDCCFE at 167.5°
  /// (mostly top-left → bottom-right). Figma node 130-29420.
  static const LinearGradient peachGradient = LinearGradient(
    begin: Alignment(-0.22, -0.98),
    end: Alignment(0.22, 0.98),
    colors: [Color(0xFFF7D7D0), Color(0xFFDDCCFE)],
    stops: [0.215, 1.0],
  );

  /// Indigo — brand violet #5700FF → medium violet #7422F2 at 170.4°
  /// (almost straight top → bottom, slight right lean). Figma node 130-29427.
  static const LinearGradient indigoGradient = LinearGradient(
    begin: Alignment(-0.17, -0.99),
    end: Alignment(0.17, 0.99),
    colors: [Color(0xFF5700FF), Color(0xFF7422F2)],
    stops: [0.152, 0.891],
  );

  /// Hero — brand violet → deep navy (radial in Figma, approximated as
  /// linear). Gradient radiates from top-right (#5700FF) to bottom-left
  /// (#0F1A38) through 6 stops. Figma node 130-29434.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment(0.57, -1.0),
    end: Alignment(-0.57, 1.0),
    colors: [
      Color(0xFF5700FF),
      Color(0xFF5209DF),
      Color(0xFF410DB5),
      Color(0xFF31128C),
      Color(0xFF201662),
      Color(0xFF0F1A38),
    ],
    stops: [0.0, 0.05, 0.2875, 0.525, 0.7625, 1.0],
  );
}


