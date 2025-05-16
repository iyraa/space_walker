import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration? speed;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 100), // Default speed
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String displayedText = ''; // This will hold the text being typed out
  //late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  // @override
  // void didUpdateWidget(covariant TypewriterText oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.text != widget.text) {
  //     // If the text changes, reset the animation
  //     _resetAnimation();
  //   }
  // }

  // Start or restart the typing animation
  // void _resetAnimation() {
  //   _currentIndex = 0; // Reset the index
  //   displayedText = ''; // Reset the displayed text
  //   _startTypingAnimation();
  // }

  // void _startTypingAnimation() {
  //   _timer = Timer.periodic(widget.speed!, (timer) {
  //     if (_currentIndex < widget.text.length) {
  //       setState(() {
  //         displayedText += widget.text[_currentIndex];
  //         _currentIndex++;
  //       });
  //     } else {
  //       _timer.cancel(); // Stop the timer when the full text is displayed
  //     }
  //   });
  // }

  void _startTypingAnimation() async {
    while (_currentIndex < widget.text.length) {
      await Future.delayed(widget.speed!);
      setState(() {
        displayedText += widget.text[_currentIndex];
        _currentIndex++;
      });
    }
  }

  // @override
  // void dispose() {
  //   //_timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      style:
          widget.style ?? TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
