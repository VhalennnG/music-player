import 'package:flutter/material.dart';
import 'package:musicplayer/components/animated_text.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/pages/song_page.dart';
import 'package:provider/provider.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        if (value.currentSongIndex == null) {
          return const SizedBox.shrink();
        }

        return Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                // Navigate to the SongPage when the bar is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SongPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                padding: const EdgeInsets.only(
                    left: 12, right: 12, bottom: 8, top: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Song title and artist
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0), // Adjust the left padding as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: AnimatedText(
                                    text: value
                                        .playlist[value.currentSongIndex!]
                                        .title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  value.playlist[value.currentSongIndex!]
                                          .artist ??
                                      'Unknown artist',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Pause/Play and Next buttons
                        IconButton(
                          icon: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () => value.pausePlay(),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: () => value.playNextSong(),
                        ),
                      ],
                    ),

                    // Progress bar directly under the entire row
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: ValueListenableBuilder<Duration>(
                        valueListenable: value.currentDurationNotifier,
                        builder: (context, currentDuration, child) {
                          return Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: (currentDuration.inSeconds >
                                    value.totalDuration.inSeconds)
                                ? value.totalDuration.inSeconds.toDouble()
                                : currentDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            onChanged: (double newValue) {
                              // Do nothing when dragging
                            },
                            onChangeEnd: (double newValue) {
                              value.seek(Duration(seconds: newValue.toInt()));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
