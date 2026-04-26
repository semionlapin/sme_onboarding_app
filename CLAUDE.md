# Project Context: SME Banking Onboarding Prototype

## 🎯 Objective
Build a functional Flutter prototype for an SME banking onboarding flow. The core feature is a conversational, voice-driven AI interface (Voice-In, Text/Voice-Out) acting as a virtual onboarding agent.

## 🛠️ Tech Stack & Packages
- **Framework:** Flutter (Dart)
- **AI Engine:** Google Generative AI (`google_generative_ai`) using Gemini 1.5 Flash.
- **Voice:** `speech_to_text` (native dictation) and `flutter_tts` (text-to-speech).
- **Vision:** `image_picker` (for mock document scanning).

## 🎨 Design System Strict Rules
- **DO NOT** hardcode colors, padding, or fonts.
- Always use the design tokens defined in `lib/theme/wio_theme.dart` and the `ThemeData` from `lib/theme/app_theme.dart`.
- The brand is premium, modern, and trustworthy. Use the gradients defined in `WioTheme` for major hero sections.
- For icons and flags, use `flutter_svg` and source them from `assets/icons/` and `assets/flags/`.

## 🏗️ Architecture & File Structure
- `lib/components/`: Only pure, reusable UI widgets (buttons, inputs, cards). No business logic here.
- `lib/screens/`: High-level views/pages.
- `lib/services/`: All API calls, Gemini logic, and Speech-to-Text/TTS logic goes here. Keep screens clean.
- `lib/theme/`: Contains the core design system.

## 🚀 The Flow
1. Welcome Screen (Open Account / Login).
2. AI Name Collection (Voice).
3. AI Business Details Collection (Voice).
4. Signatory Type Selection (Voice/UI).
5. Trade License Upload (Camera to Gemini Vision).
6. Wrap-up / To-Do List Dashboard.

## 🤖 AI Agent Instructions
When writing code for this project:
1. Prioritize clean, modern UI/UX matching the `WioTheme`.
2. Keep state management simple (setState is fine for this prototype unless otherwise specified).
3. Always handle microphone/camera permissions gracefully.