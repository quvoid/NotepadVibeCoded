import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_vader_notes/src/core/services/tts_service.dart';

class TtsControls extends ConsumerStatefulWidget {
  final String text;
  
  const TtsControls({super.key, required this.text});

  @override
  ConsumerState<TtsControls> createState() => _TtsControlsState();
}

class _TtsControlsState extends ConsumerState<TtsControls> {
  bool _isPlaying = false;
  double _speechRate = 0.5;

  @override
  Widget build(BuildContext context) {
    final ttsService = ref.watch(ttsServiceProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  iconSize: 32,
                  onPressed: () async {
                    if (_isPlaying) {
                      await ttsService.stop();
                      setState(() => _isPlaying = false);
                    } else {
                      await ttsService.speak(widget.text);
                      setState(() => _isPlaying = true);
                    }
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 32,
                  onPressed: _isPlaying
                      ? () async {
                          await ttsService.pause();
                          setState(() => _isPlaying = false);
                        }
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.speed, size: 20),
                Expanded(
                  child: Slider(
                    value: _speechRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(_speechRate * 100).round()}%',
                    onChanged: (value) async {
                      setState(() => _speechRate = value);
                      await ttsService.setRate(value);
                    },
                  ),
                ),
                Text('${(_speechRate * 100).round()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
