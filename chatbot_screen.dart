import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _faq = [
    {
      'question': 'What is this app?',
      'answer': 'This app is a library management system that allows users to track books, borrow and return books, and manage library resources.'
    },
    {
      'question': 'How can I borrow books?',
      'answer': 'To borrow books, navigate to the Borrow section, select the book you want, and click on the Borrow button. You can then view your borrowed books in the My Books section.'
    },
    {
      'question': 'How do I return books?',
      'answer': 'To return books, go to the My Books section, select the book you wish to return, and click on the Return button.'
    },
    {
      'question': 'What happens if I overdue a book?',
      'answer': 'If you overdue a book, you may incur late fees. Please make sure to return your books on time to avoid any penalties.'
    },
    {
      'question': 'Can I extend my borrowing period?',
      'answer': 'Yes, you can extend your borrowing period by navigating to the My Books section and selecting the book you wish to extend. An option to extend the due date will be available.'
    },
  ];

  String _currentExplanation = '';

  // Function to show the explanation based on the selected question
  void _showExplanation(String answer) {
    setState(() {
      _currentExplanation = answer;
    });
  }

  // Build the list of questions as clickable items
  Widget _buildQuestionItem(Map<String, String> faq) {
    return GestureDetector(
      onTap: () => _showExplanation(faq['answer']!),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            faq['question']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot - Library Management'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display a list of predefined questions
            const Text(
              'Frequently Asked Questions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _faq.length,
                itemBuilder: (context, index) {
                  return _buildQuestionItem(_faq[index]);
                },
              ),
            ),
            // Display the explanation based on the clicked question
            if (_currentExplanation.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _currentExplanation,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
