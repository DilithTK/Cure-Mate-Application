import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  
  static String get apiKey => dotenv.env[''] ?? '';

  static const String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  static Future<String> getChatResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$url?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "You are a helpful assistant for medicine and health queries.\n\nUser: $message"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final reply = data["candidates"][0]["content"]["parts"][0]["text"];
        return reply;
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Something went wrong: $e";
    }
  }
}