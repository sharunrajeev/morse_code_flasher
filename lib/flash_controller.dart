import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FlashController extends StatelessWidget {
  const FlashController({Key? key}) : super(key: key);

  static int timeUnit = 300;

  static Future<void> checkTorch() async {
    try {
      await TorchLight.isTorchAvailable();
    } catch (e) {
      @override
      Widget build(BuildContext context) {
        return const SnackBar(
          content: Text('Torch is not available'),
        );
      }
    }
  }

  static Future<void> flashLight(int ms) async {
    await TorchLight.enableTorch();
    await Future.delayed(Duration(milliseconds: ms));
    await TorchLight.disableTorch();
  }

  // Function to pause a specific time
  static Future<void> pause(int ms) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  static Future<bool> flashLetter(String morse) async {
    checkTorch();
    for (int i = 0; i < morse.length; i++) {
      String letter = morse[i];
      if (letter == '.') {
        flashLight(timeUnit);
        await pause(timeUnit);
      } else if (letter == '-') {
        flashLight(3 * timeUnit);
        await pause(3 * timeUnit);
      }
      await pause(timeUnit);
    }
    await pause(3 * timeUnit);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
