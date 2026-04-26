import 'package:flutter/material.dart';

import '../components/ai_orb.dart';
import '../services/voice_agent_service.dart';
import '../theme/wio_theme.dart';

/// Conversation / AI Avatar screen — Phase 3 complete.
///
/// State machine:
///   idle       → user taps orb → listening
///   listening  → silence / tap → [Gemini thinking → TTS speaking] → idle
///   processing → user taps orb → TTS interrupted → idle
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final VoiceAgentService _voiceService = VoiceAgentService();

  bool _isListening  = false;
  bool _isProcessing = false; // true while Gemini is thinking or TTS is speaking
  bool _isAvailable  = false;
  String _displayText = '';

  /// Orb is active (fast breathing) during both listening AND processing phases.
  bool get _isOrbActive => _isListening || _isProcessing;

  @override
  void initState() {
    super.initState();
    _voiceService.initVoice().then((available) {
      if (mounted) setState(() => _isAvailable = available);
    });
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  // ── State machine ──────────────────────────────────────────────────────────

  /// Called when we have a complete user utterance (from tap or silence).
  /// Locks _isListening = false before awaiting, preventing re-entry from a
  /// concurrent tap.
  Future<void> _handleFinalInput(String transcript) async {
    if (transcript.trim().isEmpty) return;
    if (!mounted) return;

    setState(() => _isProcessing = true);

    await _voiceService.processAndRespond(
      transcript,
      onResponse: (response) {
        // Gemini has replied — show the text while TTS begins speaking.
        if (mounted) setState(() => _displayText = response);
      },
    );

    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _toggleListening() async {
    if (!_isAvailable) return;

    // ── While processing: a tap interrupts TTS and returns to idle.
    // _isProcessing is cleared by _handleFinalInput once processAndRespond
    // returns (the Completer in speak() completes on cancel).
    if (_isProcessing) {
      await _voiceService.stopSpeaking();
      return;
    }

    // ── While listening: a tap captures the partial transcript and submits it.
    if (_isListening) {
      final captured = _displayText;
      setState(() => _isListening = false); // lock immediately before any await
      await _voiceService.stopListening();
      await _handleFinalInput(captured);
      return;
    }

    // ── Idle: start a new listening session.
    setState(() {
      _isListening = true;
      _displayText = '';
    });
    _voiceService.startListening(
      onResult: (text) {
        if (mounted) setState(() => _displayText = text);
      },
      onDone: () {
        if (!mounted) return;
        final captured = _displayText;
        setState(() => _isListening = false); // lock before async work
        _handleFinalInput(captured);          // intentionally not awaited
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String get _hintLabel {
    if (!_isAvailable)  return 'Microphone unavailable';
    if (_isListening)   return 'Listening...';
    if (_isProcessing)  return 'Speaking...';
    return 'Tap to speak';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: WioTheme.bg2,
      body: Stack(
        children: [
          // ── Ambient glow ───────────────────────────────────────────────────
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
                    WioTheme.p1.withValues(alpha: 0.28),
                    WioTheme.bg2.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // ── Orb + text — centred column ────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hero preserves the shared-element transition from WelcomeScreen.
                GestureDetector(
                  onTap: _toggleListening,
                  child: Hero(
                    tag: 'ai_avatar',
                    child: AiOrb(isListening: _isOrbActive),
                  ),
                ),

                const SizedBox(height: 40),

                // Transcript / AI response — fades in when text is available.
                AnimatedOpacity(
                  opacity: _displayText.isEmpty ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _displayText.isEmpty ? ' ' : _displayText,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: WioTheme.s2.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Status label — always visible, content reflects current state.
                Text(
                  _hintLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: WioTheme.s2.withValues(alpha: 0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Close button ───────────────────────────────────────────────────
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

          // ── iOS home indicator ─────────────────────────────────────────────
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
