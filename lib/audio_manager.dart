// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<bool> play(String path) async {
    // await _audioPlayer.stop();
    // if (path.contains('http')) {
    //   try {
    //     await _audioPlayer.setUrl(path);
    //   } catch (e) {
    //     return false;
    //   }
    // } else {
    //   print('assets/$path');
    //   await _audioPlayer.setAsset("assets/$path");
    // }
    // await _audioPlayer.play();

    // return true;

    final AudioPlayer _audioPlayer = AudioPlayer();
     if (path.contains('http')) {
      try {
        await _audioPlayer.setUrl(path);
      } catch (e) {
        return false;
      }
    } else {
      await _audioPlayer.setAsset("assets/$path");
    }
    await _audioPlayer.play();
    _audioPlayer.dispose();
    return true;
  }

  static Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
