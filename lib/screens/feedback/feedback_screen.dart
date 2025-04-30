import 'package:flutter/material.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedEmojiIndex = 3; // Default to "Good"
  final List<String> emojiLabels = ['Angry', 'Bad', 'Okay', 'Good', 'Love'];
  final List<String> emojis = ['😡', '😐', '😕', '😊', '😍'];

  final Map<String, bool?> feedbackOptions = {
    'Delivery time': null,
    'Product quality': null,
    'Customer Service': null,
  };

  final TextEditingController commentController = TextEditingController();

  void _toggleFeedback(String category, bool isPositive) {
    setState(() {
      feedbackOptions[category] = isPositive;
    });
  }

  void _sendFeedback() {
    String emoji = emojis[selectedEmojiIndex];
    Map<String, String> reactions = {};
    feedbackOptions.forEach((key, value) {
      if (value != null) {
        reactions[key] = value ? '👍' : '👎';
      } else {
        reactions[key] = 'N/A';
      }
    });

    String message = '''
    Feedback Summary:
    - Overall Experience: ${emojiLabels[selectedEmojiIndex]} $emoji
    - Delivery time: ${reactions['Delivery time']}
    - Product quality: ${reactions['Product quality']}
    - Customer Service: ${reactions['Customer Service']}
    - Comment: ${commentController.text.trim().isEmpty ? "None" : commentController.text}
    ''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Feedback Sent'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentController.clear();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Widget _buildThumbRow(String title) {
    final isSelected = feedbackOptions[title];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          IconButton(
            icon: Icon(Icons.thumb_up,
                color: isSelected == true ? Colors.blue : Colors.grey),
            onPressed: () => _toggleFeedback(title, true),
          ),
          IconButton(
            icon: Icon(Icons.thumb_down,
                color: isSelected == false ? Colors.red : Colors.grey),
            onPressed: () => _toggleFeedback(title, false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('How would you rate your experience?',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(emojis.length, (index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedEmojiIndex = index;
                        });
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: selectedEmojiIndex == index
                            ? Colors.yellow.shade100
                            : Colors.grey.shade200,
                        child: Text(emojis[index], style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (selectedEmojiIndex == index)
                      Text(
                        emojiLabels[index],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      )
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('Would you tell us a little more about your experience.',
                style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            ...feedbackOptions.keys.map((key) => _buildThumbRow(key)),
            const SizedBox(height: 20),
            const Text('Comment (optional)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Send Feedback', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}