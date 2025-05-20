import 'package:flutter/material.dart';

class ErrorOverlay extends StatelessWidget {
  final String errorMessage;
  const ErrorOverlay({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 100,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
