import 'package:flutter/material.dart';
import 'package:musicplayer/components/my_drawer.dart';
import 'package:musicplayer/components/now_playing.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/pages/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "P L A Y L I S T",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          // get the playlist
          final List<SongModel> playlist = value.playlist;

          // check if playlist is empty
          if (playlist.isEmpty) {
            return Center(
              child: const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Tidak ada lagu atau izin penyimpanan ditolak",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // return list view ui
          return Stack(children: [
            ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                // get individual song
                final SongModel song = playlist[index];

                // return list UI song
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.artist ?? 'unknown artist'),
                  leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: ClipOval(
                        child: Container(
                          width: 55,
                          height: 55,
                          color: Theme.of(context).colorScheme.primary,
                          child: Icon(Icons.music_note_sharp),
                        ),
                      ),
                      artworkHeight: 55,
                      artworkWidth: 55,
                      artworkFit: BoxFit.cover,
                      keepOldArtwork: false),
                  onTap: () => goToSong(index),
                );
              },
            ),

            // Now Playing
            NowPlayingBar()
          ]);
        },
      ),
    );
  }
}
