import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SystemLogWidget extends StatefulWidget {
  final List<String> logs;
  final String playerName;

  const SystemLogWidget({
    super.key,
    required this.logs,
    required this.playerName,
  });

  @override
  State<SystemLogWidget> createState() => _SystemLogWidgetState();
}

class _SystemLogWidgetState extends State<SystemLogWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant SystemLogWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.logs.length,
            itemBuilder:
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        widget.logs[index].replaceAll(
                          'PLAYER',
                          widget.playerName,
                        ),
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                    isRepeatingAnimation: false,
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
