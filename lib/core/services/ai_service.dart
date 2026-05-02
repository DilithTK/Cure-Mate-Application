import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {

  // Replace with your NEW OpenAI API key
  static const String apiKey = "api";

  /// Get a chat response (user message → AI reply)
  static Future<String> getChatResponse(String message) async {

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    try {

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {"role": "system", "content": "You are a helpful health assistant."},
            {"role": "user", "content": message} // <-- use user input
          ],
          "max_tokens": 100
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"].toString().trim();
      } else {
        print("API Error: ${response.body}");
        return "Unable to fetch health tip.";
      }

    } catch (e) {
      print("Error: $e");
      return "Network error. Please try again.";
    }

  }

  /// Optional: Generate multiple tips (reuses getChatResponse)
  static Future<List<String>> getMultipleTips(int count) async {
    List<String> tips = [];
    for (int i = 0; i < count; i++) {
      final tip = await getChatResponse(
          "Give one short health tip in 1-2 sentences.");
      tips.add(tip);
    }
    return tips;
  }

}