import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../core/services/ai_service.dart';
import '../../core/theme/color.dart';
=======
import '../../core/theme/color.dart';
import '../../core/services/ai_service.dart';
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

class MedicineExplainerScreen extends StatefulWidget {
  const MedicineExplainerScreen({super.key});

  @override
<<<<<<< HEAD
  State<MedicineExplainerScreen> createState() =>
      _MedicineExplainerScreenState();
=======
  State<MedicineExplainerScreen> createState() => _MedicineExplainerScreenState();
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
}

class _MedicineExplainerScreenState extends State<MedicineExplainerScreen> {
  final TextEditingController controller = TextEditingController();
<<<<<<< HEAD

=======
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  final List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> sendMessage() async {
<<<<<<< HEAD
    String text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
=======
    String userMessage = controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      isLoading = true;
    });

    controller.clear();

<<<<<<< HEAD
    final reply = await AIService.getChatResponse(text);

    setState(() {
      messages.add({"role": "bot", "text": reply});
=======
    // Gemini API එකෙන් response එක ගමු
    String botReply = await AIService.getChatResponse(userMessage);

    setState(() {
      messages.add({"role": "bot", "text": botReply});
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: const Text("AI Medicine Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask about medicine...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isLoading ? null : sendMessage,
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
=======
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Medicine Explainer"), // නම වෙනස් කළා
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.medication, size: 60, color: AppColors.primary),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Enter medicine names from your prescription to know what they do.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => buildMessage(messages[index]),
                  ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          _buildInputArea(),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        ],
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter medicine name...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: isLoading ? null : sendMessage,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Map<String, String> msg) {
    bool isUser = msg["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          msg["text"]!,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15),
        ),
      ),
    );
  }
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
}