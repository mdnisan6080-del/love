# Love Calculator (LoveMeter)

A small Flutter app that calculates a "love percentage" between two names and shows a cute animated result.

Features:
- Two-name input
- Cute UI with gradient background
- Lottie heart animation
- Animated percentage display
- Confetti when percentage > 70%
- Simple deterministic formula (sum of codeUnits % 101)

How to run:
1. Ensure Flutter is installed: https://flutter.dev/docs/get-started/install
2. Add the Lottie asset to `assets/heart.json` (see notes below).
3. flutter pub get
4. flutter run

Assets:
- Put a Lottie heart animation at `assets/heart.json`. Example Lottie files can be downloaded from https://lottiefiles.com

Notes:
- Packages used: lottie, animated_text_kit, confetti, shared_preferences (for future history).
- This is a small starting scaffold — you can add share-as-image, history storage, sounds, and dark mode.
