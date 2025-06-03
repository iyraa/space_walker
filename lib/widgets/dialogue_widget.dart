import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:audioplayers/audioplayers.dart';

class DialogueWidget extends StatefulWidget {
  final List<NodeContent> dialogueHistory;
  final VoidCallback onNext;
  final String playerName;
  final bool isLastLine;
  final List<NodeContent>? choices;
  final void Function(NodeContent)? onChoiceSelected;
  final Map<String, Character> characterMap; // Add this to DialogueWidget

  const DialogueWidget({
    super.key,
    required this.dialogueHistory,
    required this.onNext,
    required this.playerName,
    required this.isLastLine,
    this.choices,
    this.onChoiceSelected,
    required this.characterMap,
  });

  @override
  State<DialogueWidget> createState() => _DialogueWidgetState();
}

class _DialogueWidgetState extends State<DialogueWidget> {
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void didUpdateWidget(covariant DialogueWidget oldWidget) {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // Scroll to the bottom of the dialogue history
  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 100),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  void _playAudio(String? audioPath) async {
    if (audioPath != null && audioPath.isNotEmpty) {
      await _audioPlayer.play(AssetSource(audioPath), volume: 0.5);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: widget.dialogueHistory.length,
              itemBuilder: (context, index) {
                final dialogue = widget.dialogueHistory[index];
                final characterId = dialogue.character;
                final characterName =
                    widget.characterMap[characterId]?.name ?? characterId;

                // Replace 'PLAYER' in characterName and narrative with the actual player name
                final displayName = characterName?.replaceAll(
                  'PLAYER',
                  widget.playerName,
                );
                final narrative = dialogue.narrative?.replaceAll(
                  'PLAYER',
                  widget.playerName,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment:
                        displayName == widget.playerName
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$displayName:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              narrative ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                //fontWeight: FontWeight.w700,
                                fontFamily: 'SpaceMono',
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (widget.isLastLine &&
              widget.choices != null &&
              widget.choices!.isNotEmpty)
            Column(
              children:
                  widget.choices!
                      .map(
                        (choice) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: OutlinedButton(
                            onPressed: () {
                              _playAudio(
                                'audio/sfx/click.mp3',
                              ); // Play SFX directly
                              widget.onChoiceSelected?.call(choice);
                            },
                            child: Text(choice.option ?? ''),
                          ),
                        ),
                      )
                      .toList(),
            )
          else if (!widget.isLastLine)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.rocket_launch, color: Color(0xFF9ED7D0)),
                iconSize: 32,
                tooltip: 'Next',
                onPressed: widget.onNext,
              ),
            ),
        ],
      ),
    );
  }
}
