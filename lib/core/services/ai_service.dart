import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  /// ✅ SAFE API KEY (NO silent fallback)
  static String get apiKey {
    final key = dotenv.env['GEMINI_API_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception("❌ GEMINI_API_KEY not found in .env file");
    }

    return key.trim();
  }

  /// ✅ MODEL (working stable model)
  static const String model = "gemini-2.5-flash";

  static final String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent";

  /// ✅ CHAT MEMORY
  static final List<Map<String, dynamic>> _chatHistory = [];

  /// 🔥 RESET CHAT
  static void newChat() {
    _chatHistory.clear();
  }

  /// 🔥 DEBUG KEY
  static void debugKey() {
    print("🔥 GEMINI KEY => $apiKey");
  }

  /// 🔥 MAIN CHAT FUNCTION
  static Future<String> getChatResponse(String message) async {
    try {
      // add user message
      _chatHistory.add({
        "role": "user",
        "parts": [
          {"text": message}
        ]
      });

      final response = await http.post(
        Uri.parse("$baseUrl?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": _chatHistory,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final reply =
            data["candidates"][0]["content"]["parts"][0]["text"];

        // add model response
        _chatHistory.add({
          "role": "model",
          "parts": [
            {"text": reply}
          ]
        });

        return reply;
      } else {
        return "API Error: ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  /// 📌 GET HISTORY
  static List<Map<String, dynamic>> get history => _chatHistory;
}