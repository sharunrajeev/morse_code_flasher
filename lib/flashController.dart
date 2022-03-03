import 'package:torch_light/torch_light.dart';

class Flasher {
  int timeUnit = 300;

  Future<void> flashLight(int ms) async {
    await TorchLight.enableTorch();
    await Future.delayed(Duration(milliseconds: ms));
    await TorchLight.disableTorch();
  }

  // Function to pause a specific time
  Future<void> pause(int ms) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  Future<bool> flashString(String morse) async {
    print(morse);
    for (int i = 0; i < morse.length; i++) {
      String letter = morse[i];
      if (letter == '.') {
        flashLight(timeUnit);
        await pause(timeUnit);
      } else if (letter == '-') {
        flashLight(3 * timeUnit);
        await pause(3 * timeUnit);
      } else if (letter == '#') {
        await pause(3 * timeUnit);
      } else if (letter == ' ') {
        await pause(6 * timeUnit);
      }
      await pause(timeUnit);
    }
    return true;
  }

  String hello() {
    return "Hello";
  }
}
