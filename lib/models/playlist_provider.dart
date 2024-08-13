import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlaylistProvider extends ChangeNotifier {
  // Query object to get songs from device
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _playlist = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  PlaylistProvider() {
    requestStoragePermission();
    listenToDuration();
  }

  requestStoragePermission() async {
    PermissionStatus result;
    result = await Permission.audio.request();

    if (result.isGranted) {
      fetchSong();
    } else if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> fetchSong() async {
    _playlist = await _audioQuery.querySongs();
    notifyListeners();
  }

  // current play song
  int? _currentSongIndex;

  // A U D I O P L A Y E R

  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // initial not playing
  bool _isPlaying = false;
  bool _isRepeat = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].data;
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume current song
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pausePlay() {
    if (_isPlaying)
      pause();
    else
      resume();
    notifyListeners();
  }

  // seek specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1)
        currentSongIndex = currentSongIndex! + 1;
      else
        currentSongIndex = 0;
    }
  }

  // play prev song
  void playPrevSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0)
        currentSongIndex = currentSongIndex! - 1;
      else
        currentSongIndex = _playlist.length - 1;
    }
  }

  // toggle repeat
  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  // toggle random song
  void toggleRandomSong() {
    if (playlist.isNotEmpty) {
      Random random = Random();
      _currentSongIndex = random.nextInt(_playlist.length);
      play();
      notifyListeners();
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen full duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      // Check if the current duration is 1 second away from the total duration
      if (_isRepeat &&
          (_totalDuration.inSeconds - _currentDuration.inSeconds <= 1)) {
        seek(Duration.zero);
        play();
      }
      notifyListeners();
    });

    // listen next song
    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isRepeat) {
        seek(Duration.zero);
        play();
      } else {
        playNextSong();
      }
    });
  }

  // GETTER
  List<SongModel> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isRepeat => _isRepeat;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // SETTER
  set currentSongIndex(int? newIndex) {
    if (newIndex != null && newIndex != _currentSongIndex) {
      _currentSongIndex = newIndex;
      play();
    }
    notifyListeners();
  }
}
