import 'package:flutter/material.dart';
import 'package:practice_english/models/QuizQuestion.dart';
import 'package:practice_english/models/VocabularyItem.dart';


class QuizScreen extends StatefulWidget {
  final List<VocabularyItem> vocabularyList;

  const QuizScreen({required this.vocabularyList});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    _questions = widget.vocabularyList.map((item) {
      // Obtener 2 traducciones incorrectas diferentes
      final incorrectTranslations = widget.vocabularyList
          .where((element) => element.translation != item.translation)
          .map((e) => e.translation)
          .toSet() // Evita duplicados
          .toList()
        ..shuffle();

      // Seleccionar máximo 2 incorrectas
      final incorrectAnswers = incorrectTranslations.take(2).toList();

      return QuizQuestion(
        word: item.word,
        correctAnswer: item.translation,
        options: [item.translation, ...incorrectAnswers]..shuffle(),
      );
    }).toList()
      ..shuffle();
  }

  void _handleAnswer(int selectedIndex) {
    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _showFeedback = true;

      if (_questions[_currentQuestionIndex].options[selectedIndex] ==
          _questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswerIndex = null;
          _showFeedback = false;
        });
      } else {
        _showFinalScore();
      }
    });
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Text('Your score: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _selectedAnswerIndex = null;
                _showFeedback = false;
                _initializeQuiz();
              });
            },
            child: Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    final question = _questions[_currentQuestionIndex];
    final isCorrect = question.options[index] == question.correctAnswer;
    final isSelected = index == _selectedAnswerIndex;

    Color getColor() {
      if (!_showFeedback) return Colors.blue;
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
      return Colors.blue;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: getColor(),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: _showFeedback ? null : () => _handleAnswer(index),
      child: Text(
        question.options[index],
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return Center(child: CircularProgressIndicator());

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Quiz'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Score: $_score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  currentQuestion.word,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: currentQuestion.options.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) => _buildOptionButton(index),
              ),
            ),
            if (_showFeedback)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  currentQuestion.options[_selectedAnswerIndex!] ==
                          currentQuestion.correctAnswer
                      ? 'Correct Answer! 👍'
                      : 'Wrong Answer! 👎 Correct: ${currentQuestion.correctAnswer}',
                  style: TextStyle(
                    fontSize: 16,
                    color: currentQuestion.options[_selectedAnswerIndex!] ==
                            currentQuestion.correctAnswer
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}