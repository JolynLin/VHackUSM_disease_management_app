import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;
  bool _processingText = false;
  bool _isEmulator = false;

  // Add highlighting words
  final Map<String, HighlightedWord> _highlights = {
    'headache': HighlightedWord(
      onTap: () => print('headache'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'fever': HighlightedWord(
      onTap: () => print('fever'),
      textStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    ),
    'pain': HighlightedWord(
      onTap: () => print('pain'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'tired': HighlightedWord(
      onTap: () => print('tired'),
      textStyle: const TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
      ),
    ),
    'cough': HighlightedWord(
      onTap: () => print('cough'),
      textStyle: const TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkIfEmulator();
  }

  Future<void> _checkIfEmulator() async {
    setState(() {
      _isEmulator = true;
    });
  }

  void _simulateVoiceInput() {
    setState(() {
      _isListening = true;
      _processingText = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _text = 'This is a simulated voice input for testing purposes. '
            'I have a headache and fever since yesterday. '
            'My temperature is 38.5°C and I feel tired.';
        _confidence = 0.85;
        _isListening = false;
        _processingText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Voice Assistant',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Instructions Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 32, color: Colors.blue.shade700),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Press the microphone button below',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  '2. Describe your symptoms clearly',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  '3. Press the button again to stop',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ],
            ),
          ),

          // Status indicator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: _isListening ? Colors.green.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _isListening ? Colors.green : Colors.grey,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isListening ? Icons.mic : Icons.mic_off,
                  color: _isListening ? Colors.green : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  _isListening ? 'Listening...' : 'Not listening',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isListening ? Colors.green : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Text result area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields,
                          size: 28, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      const Text(
                        'Your Speech',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: SizedBox(
                        width: double.infinity,
                        child: _text.isEmpty
                            ? Center(
                                child: Text(
                                  _processingText
                                      ? 'Processing your speech...'
                                      : 'Your speech will appear here',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : TextHighlight(
                                text: _text,
                                words: _highlights,
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confidence level indicator
          if (_text.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Text(
                    'Recognition Accuracy: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _confidence,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _confidence > 0.7
                            ? Colors.green
                            : _confidence > 0.4
                                ? Colors.orange
                                : Colors.red,
                      ),
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(_confidence * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          backgroundColor:
              _isListening ? Colors.red : Theme.of(context).primaryColor,
          elevation: 8,
          highlightElevation: 12,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            size: 36,
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      setState(() {
        _processingText = true;
      });

      if (_isEmulator) {
        _simulateVoiceInput();
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (status) {
          print('onStatus: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
              _processingText = false;
            });
          }
        },
        onError: (errorNotification) {
          print('onError: $errorNotification');
          setState(() {
            _isListening = false;
            _processingText = false;
          });

          // Show more user-friendly error message based on error type
          String errorMessage = 'An error occurred with speech recognition';

          // Handle timeout errors specifically
          if (errorNotification.errorMsg.contains('timeout') ||
              errorNotification.errorMsg == 'error_speech_timeout') {
            errorMessage =
                'No speech detected. Please try again and speak clearly into your microphone.';
          } else if (errorNotification.errorMsg.contains('network')) {
            errorMessage =
                'Network error. Please check your internet connection.';
          } else if (errorNotification.errorMsg.contains('permission')) {
            errorMessage =
                'Microphone permission denied. Please enable microphone access.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: const TextStyle(fontSize: 18),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Try Again',
                textColor: Colors.white,
                onPressed: () {
                  _listen();
                },
              ),
            ),
          );
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
            _processingText = false;
            if (result.hasConfidenceRating && result.confidence > 0) {
              _confidence = result.confidence;
            }
          }),
          listenFor: const Duration(seconds: 30), // Reduced from 60 seconds
          pauseFor: const Duration(seconds: 3), // Reduced from 5 seconds
          partialResults: true,
          localeId: 'en_US',
          cancelOnError:
              false, // Changed to false to avoid immediate cancellation
        );
      } else {
        setState(() => _processingText = false);

        // Show error message if speech recognition is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Speech recognition not available on this device. Please check your microphone settings.',
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
