import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
   
  static const String _apiKey = "AIzaSyCoAJlm9pJw_Dc9T7eu5WxviVT7FkaGLLE";

  static Future<String> getChatResponse(String userMessage) async {
    try {
      final model = GenerativeModel(
        
        model: 'gemini-pro', 
        apiKey: _apiKey,
      );

      final content = [
        
        Content.text("User instruction: You are a medical expert. Only answer about medicines. User question: $userMessage")
      ];
      
      final response = await model.generateContent(content);
      return response.text ?? "Sorry, I couldn't understand that.";
    } catch (e) {
      return "Error: $e";
    }
  }
}