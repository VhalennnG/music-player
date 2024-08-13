import 'package:flutter/material.dart';
import 'package:musicplayer/components/animated_text.dart';
import 'package:musicplayer/components/neu_box.dart';
import 'package:musicplayer/components/song_drawer.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key}) : super(key: key);

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, value, child) {
      final playlist = value.playlist;

      final currentSong = playlist[value.currentSongIndex ?? 0];

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: const SongDrawer(),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // app bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back)),
                    const Text('P L A Y L I S T',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // album artwork
                NeuBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: QueryArtworkWidget(
                          id: currentSong.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            height: 200,
                            width: 200,
                            child: Icon(
                              Icons.music_note_sharp,
                              size: 100,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          artworkWidth: 200,
                          artworkHeight: 200,
                          artworkFit: BoxFit.cover,
                          keepOldArtwork: false,
                        ),
                      ),

                      // Song and artist name
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: AnimatedText(
                                    text: currentSong.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Text(currentSong.artist ?? 'unknown artist'),
                              ],
                            ),
                            const Icon(Icons.music_note_sharp)
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // song duration progress
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(value.currentDuration)),
                          IconButton(
                            icon: const Icon(Icons.shuffle),
                            onPressed: () {
                              value.toggleRandomSong();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              value.isRepeat ? Icons.repeat_one : Icons.repeat,
                            ),
                            onPressed: () {
                              value.toggleRepeat();
                            },
                          ),
                          Text(formatTime(value.totalDuration)),
                        ],
                      ),
                    ),

                    // song duration progress
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                      ),
                      child: Slider(
                        min: 0,
                        max: value.totalDuration.inSeconds.toDouble(),
                        value: (value.currentDuration.inSeconds >
                                value.totalDuration.inSeconds)
                            ? value.totalDuration.inSeconds.toDouble()
                            : value.currentDuration.inSeconds.toDouble(),
                        activeColor: Colors.green,
                        onChanged: (double newValue) {
                          // during when the user is sliding around
                        },
                        onChangeEnd: (double newValue) {
                          value.seek(Duration(seconds: newValue.toInt()));
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // playback controls
                Row(
                  children: [
                    // skip prev
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playPrevSong,
                        child: const NeuBox(child: Icon(Icons.skip_previous)),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // play pause
                    Expanded(
                      child: GestureDetector(
                        onTap: value.pausePlay,
                        child: NeuBox(
                          child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // skip forward
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextSong,
                        child: const NeuBox(child: Icon(Icons.skip_next)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
