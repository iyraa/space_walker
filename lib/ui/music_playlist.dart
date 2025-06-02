import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:marquee/marquee.dart';

// add the reest of the music
class MusicPlaylist extends StatefulWidget {
  final AudioPlayer player;
  final void Function(String assetPath) onPlay;
  final void Function()? onPause;
  final void Function(String assetPath)? onNext;
  final void Function(String assetPath)? onPrev;

  static const Map<String, String> tracks = {
    'Olympus by 32': 'audio/music/32stitches_olympus.mp3',
    'Carry On by Anna Yvette, Lost Sky':
        'audio/music/anna_yvette_lost_sky_carry_on_vocal.mp3',
    'Carry On by Anna Yvette, Lost Sky Instrumental':
        'audio/music/anna_yvette_lost_sky_carry_on.mp3',
    'Orphic Night by Diandra Faye': 'audio/music/diandra_faye_orphic_night.mp3',
    'Samurai by Jim Yosef': 'audio/music/jim_yosef_samurai.mp3',
    'AI by Max Brhon': 'audio/music/max_brhon_ai.mp3',
    'Mortals by Warriyo feat. Laura Brehm':
        'audio/music/warriyo_laura_brehm_mortals.mp3',
  };

  const MusicPlaylist({
    super.key,
    required this.player,
    required this.onPlay,
    this.onPause,
    this.onNext,
    this.onPrev,
  });

  @override
  State<MusicPlaylist> createState() => _MusicPlaylistState();
}

class _MusicPlaylistState extends State<MusicPlaylist> {
  int currentIndex = 0;
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<String> get trackNames => MusicPlaylist.tracks.keys.toList();

  @override
  void initState() {
    super.initState();
    widget.player.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });
    widget.player.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  void _play() {
    setState(() {
      isPlaying = true;
    });
    widget.onPlay(MusicPlaylist.tracks[trackNames[currentIndex]]!);
  }

  void _pause() {
    setState(() {
      isPlaying = false;
    });
    if (widget.onPause != null) widget.onPause!();
  }

  void _next() {
    if (currentIndex < trackNames.length - 1) {
      setState(() {
        currentIndex++;
        isPlaying = true;
      });

      if (widget.onNext != null) {
        widget.onNext!(MusicPlaylist.tracks[trackNames[currentIndex]]!);
      } else {
        _play();
      }
    } else {
      setState(() {
        isPlaying = false;
      });
      if (widget.onPause != null) widget.onPause!();
    }
  }

  void _prev() {
    setState(() {
      currentIndex = (currentIndex - 1 + trackNames.length) % trackNames.length;
      isPlaying = true;
    });
    if (widget.onPrev != null) {
      widget.onPrev!(MusicPlaylist.tracks[trackNames[currentIndex]]!);
    } else {
      _play();
    }
  }

  @override
  void dispose() {
    // widget.player.stop();
    // widget.player.release();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final name = trackNames[currentIndex];
    //final timeLeft = _duration - _position;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Marquee for sliding song title
              SizedBox(
                height: 28,
                width: 140,
                child: Marquee(
                  text: name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 40.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
              // Time left (optional)
              // Text(
              //   "-${_formatDuration(timeLeft > Duration.zero ? timeLeft : Duration.zero)}",
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.primary,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: _prev,
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: isPlaying ? _pause : _play,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: _next,
                  ),
                ],
              ),
            ],
          ),
          // Timeline slider
          Slider(
            value: _position.inSeconds.toDouble().clamp(
              0,
              _duration.inSeconds.toDouble(),
            ),
            min: 0,
            max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1,
            onChanged: (value) async {
              final newPosition = Duration(seconds: value.toInt());
              await widget.player.seek(newPosition);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
