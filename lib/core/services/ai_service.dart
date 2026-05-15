import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIService {
  static String get apiKey {
    final key = dotenv.env['GEMINI_API_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception("GEMINI_API_KEY not found in .env file");
    }

    return key.trim();
  }

  static String get model {
    final configuredModel = dotenv.env['GEMINI_MODEL']?.trim();
    return configuredModel?.isNotEmpty == true
        ? configuredModel!
        : "gemini-2.5-flash";
  }

  static const String _fallbackModel = "gemini-2.5-flash-lite";
  static const int _maxAttemptsPerModel = 3;

  static final List<Map<String, dynamic>> _chatHistory = [];

  static void newChat() {
    _chatHistory.clear();
  }

  static void debugKey() {
    debugPrint("Gemini API key is configured");
  }

  static Future<String> getChatResponse(String message) async {
    final userEntry = {
      "role": "user",
      "parts": [
        {"text": message},
      ],
    };
    _chatHistory.add(userEntry);

    try {
      final reply = await _generateWithRetry();

      _chatHistory.add({
        "role": "model",
        "parts": [
          {"text": reply},
        ],
      });

      return reply;
    } catch (e) {
      _chatHistory.remove(userEntry);
      debugPrint("AI chat error: $e");
      return _friendlyErrorMessage(e);
    }
  }

  static Future<String> _generateWithRetry() async {
    final models = model == _fallbackModel ? [model] : [model, _fallbackModel];
    Object? lastError;

    for (final currentModel in models) {
      for (var attempt = 1; attempt <= _maxAttemptsPerModel; attempt++) {
        try {
          final response = await _postToGemini(currentModel);

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body) as Map<String, dynamic>;
            final candidates = data["candidates"] as List<dynamic>?;
            final firstCandidate = _firstOrNull(candidates);
            final content = firstCandidate?["content"] as Map<String, dynamic>?;
            final parts = content?["parts"] as List<dynamic>?;
            final firstPart = _firstOrNull(parts);
            final text = firstPart?["text"] as String?;

            if (text == null || text.trim().isEmpty) {
              throw Exception("Gemini returned an empty response.");
            }

            return text.trim();
          }

          final error = _GeminiApiException.fromResponse(response);
          lastError = error;

          if (!_shouldRetry(response.statusCode) ||
              attempt == _maxAttemptsPerModel) {
            break;
          }

          await Future.delayed(Duration(milliseconds: 600 * attempt));
        } catch (e) {
          lastError = e;

          if (attempt == _maxAttemptsPerModel) {
            break;
          }

          await Future.delayed(Duration(milliseconds: 600 * attempt));
        }
      }
    }

    throw lastError ?? Exception("Unable to get a chat response.");
  }

  static Future<http.Response> _postToGemini(String currentModel) {
    final baseUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/$currentModel:generateContent";

    return http.post(
      Uri.parse("$baseUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"contents": _chatHistory}),
    );
  }

  static bool _shouldRetry(int statusCode) {
    return statusCode == 429 || statusCode == 500 || statusCode == 503;
  }

  static Map<String, dynamic>? _firstOrNull(List<dynamic>? items) {
    if (items == null || items.isEmpty) return null;
    return items.first as Map<String, dynamic>?;
  }

  static String _friendlyErrorMessage(Object error) {
    if (error is _GeminiApiException) {
      if (error.statusCode == 503) {
        return "The AI model is busy right now. I tried again, but it is still unavailable. Please try again in a few minutes.";
      }

      if (error.statusCode == 429) {
        return "The AI request limit has been reached. Please wait a moment and try again.";
      }

      if (error.statusCode == 400 || error.statusCode == 403) {
        return "The AI service is not configured correctly. Please check your Gemini API key and model name.";
      }
    }

    return "I couldn't reach the AI service right now. Please check your connection and try again.";
  }

  static List<Map<String, dynamic>> get history => _chatHistory;
}

class _GeminiApiException implements Exception {
  final int statusCode;
  final String message;
  final String status;

  _GeminiApiException({
    required this.statusCode,
    required this.message,
    required this.status,
  });

  factory _GeminiApiException.fromResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final error = body["error"] as Map<String, dynamic>?;

      return _GeminiApiException(
        statusCode: response.statusCode,
        message: error?["message"]?.toString() ?? response.body,
        status: error?["status"]?.toString() ?? "UNKNOWN",
      );
    } catch (_) {
      return _GeminiApiException(
        statusCode: response.statusCode,
        message: response.body,
        status: "UNKNOWN",
      );
    }
  }

  @override
  String toString() => "Gemini API $statusCode $status: $message";
}
