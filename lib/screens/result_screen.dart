import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

class ResultScreen extends StatefulWidget {
  final String name1;
  final String name2;

  const ResultScreen({super.key, required this.name1, required this.name2});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final int _percentage;
  late final String _message;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _percentage = calculateLovePercentage(widget.name1, widget.name2);
    _message = messageForPercentage(_percentage);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    if (_percentage > 70) {
      // small delay to let page render
      Future.delayed(const Duration(milliseconds: 300), () {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  static int calculateLovePercentage(String name1, String name2) {
    // Simple deterministic formula as suggested:
    final sum = name1.codeUnits.fold<int>(0, (a, b) => a + b) +
        name2.codeUnits.fold<int>(0, (a, b) => a + b);
    return sum % 101; // 0..100
  }

  static String messageForPercentage(int pct) {
    if (pct <= 30) return '🥶 Just friends… maybe distant ones.';
    if (pct <= 60) return '💐 You two have potential!';
    if (pct <= 85) return '💞 Strong connection detected!';
    return '💘 A match made in heaven!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              children: [
                LottieBuilder.asset(
                  'assets/heart.json',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                  repeat: true,
                  // If you don't have a local asset, replace with a network Lottie url or an Icon.
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.name1}  &  ${widget.name2}',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _percentage.toDouble()),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    final int shown = value.round();
                    return Column(
                      children: [
                        Text(
                          '$shown%',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _message,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    // placeholder for share feature
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share not implemented yet')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              maxBlastForce: 20,
              minBlastForce: 5,
              emissionFrequency: 0.02,
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}