import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testproject/conunter_provider.dart';

class MediaPlayerProvider extends ChangeNotifier {
  static final provider = ChangeNotifierProvider(
    (ref) => MediaPlayerProvider(ref.watch(CounterProvider.provider)),
  );

  late final AudioPlayer _audioPlayer;
  final CounterProvider _counter;
  final markers = [
    "00:11.7",
    "00:23.1",
    "00:36.4",
    "00:48.5",
    "01:00.7",
    "01:10.0",
    "01:17.9",
    "01:40.0",
    "02:01.3",
    "02:08.8",
  ];

  List<Duration> covertToDuration() {
    List<Duration> durationList = [];
    for (int i = 0; i < markers.length; i++) {
      Duration currentDuration = parseDuration(markers[i]);
      durationList.add(currentDuration);
    }
    return durationList;
  }

  Duration parseDuration(String time) {
    List<String> parts = time.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsAndMilliSeconds = parts[1].split(".");
    int seconds = int.parse(secondsAndMilliSeconds[0]);
    int milliSeconds = int.parse(secondsAndMilliSeconds[1]);

    return Duration(
        minutes: minutes, seconds: seconds, milliseconds: milliSeconds);
  }

  MediaPlayerProvider(this._counter);

  void init() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAsset('assets/audio/003.lite.mp3');
    final durations = covertToDuration();

    int lastIncrementedIndex = -1;

    _audioPlayer.positionStream.listen((currentState) {
      for (int i = 0; i < durations.length; i++) {
        final time = durations[i];

        if (currentState >= time && i > lastIncrementedIndex) {
          _counter.counter++;
          print("my state2 $currentState");

          lastIncrementedIndex = i;
        }
      }
    });

    play();
  }

  Future<void> play() => _audioPlayer.play();

  Future<void> pause() => _audioPlayer.pause();
}
