import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';

class VoiceRecorderSheet extends StatefulWidget {
  const VoiceRecorderSheet({super.key});

  @override
  State<VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<VoiceRecorderSheet> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking...';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) {
        if (mounted) {
           if (val == 'done' || val == 'notListening') {
             setState(() => _isListening = false);
           }
        }
      },
      onError: (val) {
         if (mounted) {
            setState(() {
              _isListening = false;
              _text = 'Error: ${val.errorMsg}';
            });
         }
      },
    );
     // Auto start
    if (available) {
       _listen();
    } else {
       if (mounted) setState(() => _text = 'Speech recognition not available');
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.spaceBlack,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppConstants.sithRed, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isListening ? 'Listening...' : 'Tap to Record',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _listen,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? AppConstants.sithRed : Colors.grey[800],
                boxShadow: [
                  if (_isListening)
                    BoxShadow(
                      color: AppConstants.sithRed.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 40,
              ),
            ),
          ).animate(target: _isListening ? 1 : 0).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
            duration: 500.ms,
            curve: Curves.easeInOut,
          ).then().scale(
            begin: const Offset(1.1, 1.1),
            end: const Offset(1, 1),
            duration: 500.ms,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.sithRed,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                   // If text is valid, return it
                   if (_text.isNotEmpty && !_text.startsWith('Press') && !_text.startsWith('Speech') && !_text.startsWith('Error')) {
                     Navigator.pop(context, _text);
                   } else {
                     Navigator.pop(context);
                   }
                },
                icon: const Icon(Icons.check),
                label: const Text('Insert'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
