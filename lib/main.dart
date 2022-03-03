import 'package:flutter/material.dart';
import 'morse.dart';
import 'flash_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morse Code Flasher',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a text controller and use it to retrieve the current value of the TextField.
  final myController = TextEditingController();
  String currentLetter = "";
  String currentMorse = "";
  String morseString = "";
  String inputString = "";
  bool errorFlag = false;
  String errorMessage = "";

  // Button text
  String buttonText = "Flash it!";

  // Check if buttons are active
  bool isActive = false;

  void startFlash() async {
    setInputText(myController.text);
    setMorseCode(MorseCode.stringToMorse(myController.text));
    List<String> morseWords = morseString.split("/ ");
    int stringLetterIndex = 0;
    for (int i = 0; i < morseWords.length; i++) {
      String morseWord = morseWords[i];
      List<String> morseLetters = morseWord.split(" ");
      morseLetters.removeLast();

      for (int j = 0; j < morseLetters.length; j++) {
        String morseLetter = morseLetters[j];
        updateLetters(myController.text[stringLetterIndex], morseLetter);
        await FlashController.flashLetter(morseLetter);
        stringLetterIndex++;
      }
      FlashController.pause(7 * FlashController.timeUnit);
    }
    updateLetters("", "");
  }

  //syncs the letter currently being flashed with one on screen
  void updateLetters(String letter, String morse) {
    setState(() {
      currentLetter = letter;
      currentMorse = morse;
    });
  }

  void setMorseCode(String morse) {
    setState(() {
      morseString = morse;
    });
  }

  void setInputText(String input) {
    setState(() {
      inputString = input;
    });
  }

  void setErrorFlag(String e) {
    setState(() {
      errorFlag = true;
      errorMessage = e;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morse Code Flasher'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: myController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'What do you wanna flash out?',
                    ),
                    maxLength: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Flash'),
                    onPressed: () {
                      startFlash();
                    },
                  ),
                ),
                Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      inputString != '' ? '$inputString -> $morseString' : '',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      currentLetter,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      currentMorse,
                      style: const TextStyle(fontSize: 30),
                    ),
                  )
                ]),
                const FlashController()
              ]),
        ),
      ),
    );
  }
}
