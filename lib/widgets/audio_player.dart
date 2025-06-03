import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? audioPath;
  final AudioPlayer audioPlayer;

  const AudioPlayerWidget({
    Key? key,
    required this.audioPath,
    required this.audioPlayer,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.audioPath != null) {
      _playAudio();
    }
  }

  Future<void> _playAudio() async {
    if (widget.audioPath != null) {
      await widget.audioPlayer.stop();
      await widget.audioPlayer.play(AssetSource('audio/sfx/${widget.audioPath}'), volume: 0.5);
      setState(() {
        isPlaying = true;
      });
    }
  }

  Future<void> _pauseAudio() async {
    await widget.audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _resumeAudio() async {
    await widget.audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              _pauseAudio();
            } else {
              _resumeAudio();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: _playAudio,
        ),
      ],
    );
  }
}