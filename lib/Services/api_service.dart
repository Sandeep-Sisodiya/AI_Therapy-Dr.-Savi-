import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Controllers/chat_controller.dart';

enum TtsState { playing, stopped, paused, continued }

class ApiService {
  final RxList<Map<String, String>> conversation = <Map<String, String>>[
    {'role': 'system', 'content': ChatController.basePrompt}
  ].obs;

  final String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent";


  static FlutterTts flutterTts = FlutterTts();
  double volume = 0.7;
  double pitch = 1.0;
  double rate = 0.4;
  Map<String, String>? voice;

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  dynamic initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
  }

  Future<void> _speak(String resp) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (resp.isNotEmpty) {
      await flutterTts.speak(resp);
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) print("Default TTS engine: $engine");
  }

  Future<void> _getDefaultVoice() async {
    List<dynamic> voices = await flutterTts.getVoices;
    var selectedVoice = voices.firstWhere(
          (voice) => voice['locale'] == 'en-US',
      orElse: () => null,
    );
    if (selectedVoice != null) {
      voice = {
        'name': selectedVoice['name'],
        'locale': selectedVoice['locale'],
      };
      await flutterTts.setVoice(voice!);
    }
  }

  /// Gemini request
  Future<String?> getChatCompletion({
    required String userPrompt,
    bool speak = true, // <--- control TTS
  }) async {
    conversation.add({'role': 'user', 'content': userPrompt});

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
    if (apiKey.isEmpty) throw Exception("GEMINI_API_KEY missing in .env");

    String fullPrompt = conversation
        .map((msg) =>
    "${msg['role'] == 'user' ? 'User' : 'Assistant'}: ${msg['content']}")
        .join("\n");

    final response = await http.post(
      Uri.parse("$baseUrl?key=$apiKey"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {"parts": [{"text": fullPrompt}]}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data["candidates"] as List?;
      if (candidates == null || candidates.isEmpty)
        return "I couldn’t generate a response.";

      String? reply = candidates[0]?["content"]?["parts"]?[0]?["text"];

      if (reply != null && reply.isNotEmpty) {
        conversation.add({'role': 'assistant', 'content': reply});

        if (speak) await _speak(reply);
        return reply;
      } else {
        return "I couldn’t generate a response.";
      }
    } else {
      throw Exception("Failed Gemini request: ${response.body}");
    }
  }
}
