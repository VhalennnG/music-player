import 'package:flutter/material.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/pages/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongDrawer extends StatefulWidget {
  const SongDrawer({Key? key}) : super(key: key);

  @override
  State<SongDrawer> createState() => _SongDrawerState();
}

class _SongDrawerState extends State<SongDrawer> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // go to song
  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    // playlistProvider.
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SongPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(children: [
        SizedBox(height: 40),
        Expanded(
            child: Consumer<PlaylistProvider>(builder: (context, value, child) {
          // get the playlist
          final List<SongModel> playlist = value.playlist;

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final SongModel song = playlist[index];

              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist ?? 'unknown artist'),
                leading: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    width: 55,
                    height: 55,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: const Icon(Icons.music_note_sharp),
                  ),
                  artworkHeight: 55,
                  artworkWidth: 55,
                  artworkFit: BoxFit.cover,
                ),
                onTap: () => goToSong(index),
              );
            },
          );
        }))
      ]),
    );
  }
}
