import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Fill this in with your Gemini API key from Google AI Studio.
const String geminiApiKey = 'AIzaSyCraeB6fpJXxBWfWKHMERNcUN-XGayqsFM';

const String _kSystemInstruction =
    'You are the Wio Business Onboarding AI. Keep your responses very brief, '
    'conversational, and professional. You are guiding a user through setting '
    'up an SME bank account. First, greet them and ask for their name. Then, '
    'ask what their business does. Finally, ask how many signatories the '
    'business has.';

class VoiceAgentService {
  final SpeechToText _stt = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  late final GenerativeModel _model;
  late final ChatSession _chat;

  bool _isAvailable = false;

  bool get isListening => _stt.isListening;

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Initialises STT (+ permissions), TTS, and the Gemini chat session.
  /// Returns true if STT was granted; Gemini is always ready after this call.
  Future<bool> initVoice() async {
    _isAvailable = await _stt.initialize(
      onError: (error) => debugPrint('STT error: ${error.errorMsg}'),
      onStatus: (status) => debugPrint('STT status: $status'),
    );

    // Natural-sounding TTS voice.
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);

    // Gemini — single chat session preserves the full conversation history
    // so the model remembers the user's name, business details, etc.
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: geminiApiKey,
      systemInstruction: Content.system(_kSystemInstruction),
    );
    _chat = _model.startChat();

    return _isAvailable;
  }

  // ── STT ───────────────────────────────────────────────────────────────────

  /// Starts listening to microphone input.
  ///
  /// [onResult] streams partial recognised words back in real time.
  /// [onDone] fires when STT produces a final, non-empty result.
  /// Safe to call when already listening — silently ignored.
  void startListening({
    required void Function(String text) onResult,
    void Function()? onDone,
  }) {
    if (!_isAvailable || _stt.isListening) return;

    _stt.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          onDone?.call();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  /// Stops the active STT session.
  Future<void> stopListening() async {
    if (_stt.isListening) await _stt.stop();
  }

  // ── Gemini + TTS ──────────────────────────────────────────────────────────

  /// Sends [userInput] to Gemini and speaks the reply via TTS.
  ///
  /// [onResponse] is called with the AI text immediately after Gemini replies,
  /// before TTS begins — so the UI can display the text right away.
  ///
  /// The returned [Future] completes only when TTS has *finished* speaking,
  /// letting callers keep the orb active for the entire agent turn.
  Future<void> processAndRespond(
    String userInput, {
    void Function(String response)? onResponse,
  }) async {
    try {
      final result = await _chat.sendMessage(Content.text(userInput));
      final text = result.text?.trim().isNotEmpty == true
          ? result.text!.trim()
          : "I'm sorry, I didn't understand that.";
      onResponse?.call(text);
      await speak(text);
    } catch (e) {
      debugPrint('Gemini error: $e');
      const errMsg = "Sorry, I'm having trouble connecting right now.";
      onResponse?.call(errMsg);
      await speak(errMsg);
    }
  }

  /// Speaks [text] and returns a Future that completes when TTS finishes.
  ///
  /// The Completer is wired to the TTS completion, cancel, and error handlers
  /// so the Future always resolves, even when [stopSpeaking] interrupts it.
  Future<void> speak(String text) async {
    final completer = Completer<void>();
    void finish() {
      if (!completer.isCompleted) completer.complete();
    }

    _tts.setCompletionHandler(finish);
    _tts.setCancelHandler(finish);
    _tts.setErrorHandler((_) => finish());
    await _tts.speak(text);
    return completer.future;
  }

  /// Interrupts any active TTS playback.
  /// Triggers the cancel handler, which unblocks any pending [speak] Future.
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  void dispose() {
    _stt.cancel();
    _tts.stop();
  }
}
