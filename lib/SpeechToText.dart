import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

import 'package:translator/translator.dart';
import 'dart:io';
import "dart:async";

class SpeechToText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> with TickerProviderStateMixin {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  var translator = GoogleTranslator();

  String resultText = "";
  String arabicText = "", ff = "";

  String translateTo = "ar";
  String translateFrom = "en_US";

  bool showBtns = false;
  var txt = "Show btns";

  bool isLoaded = false;
  bool b1_isPressed = true;
  bool b2_isPressed = false;
  bool b3_isPressed = false;
  bool b4_isPressed = false;
  bool b5_isPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    // Like callback function
    _speechRecognition.setAvailabilityHandler((bool result) => setState(() {
          new Future.delayed(const Duration(seconds: 4));
          _isAvailable = result;
        }));

    //When speech recognition service
    _speechRecognition.setRecognitionStartedHandler(() => setState(() {
          new Future.delayed(const Duration(seconds: 4));
          _isListening = true;
        }));

    // Give back the result to the text
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() {
        resultText = speech;
      }),
    );

    // When user stop talking
    _speechRecognition.setRecognitionCompleteHandler(() => setState(() {
          _isListening = false;
        }));

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  Widget build(BuildContext context) {
    // UI
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                    child: Icon(Icons.cancel),
                    mini: true,
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      if (_isListening) {
                        _speechRecognition.cancel().then(
                              (result) => setState(() {
                                _isListening = result;
                                resultText = "";
                              }),
                            );
                      }
                    }),
                FloatingActionButton(
                    child: Icon(Icons.mic),
                    backgroundColor: Colors.pink,
                    onPressed: () {
                      setState(() {
                        if (_isAvailable && !_isListening) {
                          _speechRecognition
                              .listen(locale: translateFrom)
                              .then((result) {
                            print('$result');
                          });
                        }
                      });
                    }),
                FloatingActionButton(
                    child: Icon(Icons.stop),
                    mini: true,
                    backgroundColor: Colors.deepPurple,
                    onPressed: () {
                      setState(() {});
                      if (_isListening) {
                        _speechRecognition.stop().then(
                              (result) => setState(() => _isListening = result),
                            );
                      }
                    }),
              ],
            ),
            Container(
              // Get Size of screen
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              // Get Size of screen
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                arabicText,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            FloatingActionButton(
//                mini: true,
                backgroundColor: Colors.cyan,
                child: isLoaded? CircularProgressIndicator(value: null, strokeWidth: 5.0,) : Icon(Icons.translate),
                onPressed: () {
                  setState(() {
                    isLoaded = true;

                  });
                  Timer(Duration(seconds: 3), (){
                    setState(() {
                      isLoaded = false;
                      translator
                          .translate(resultText, to: translateTo)
                          .then((s) => arabicText = s);
                    });
                  });


                }),
            SizedBox(
              height: 70.0,
            ),
            FloatingActionButton(
                child: Text(txt, style: TextStyle(fontSize: 9.0),),
                onPressed: (){setState(() {
              showBtns = !showBtns;
              showBtns? txt = "Hide btns" : txt = "Show btns";
            });}),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showBtns? buildFloatingActionButton("Spanish", "es", b2_isPressed? Colors.green : Colors.grey) : SizedBox(),
                SizedBox(width: 10.0,),
                showBtns? buildFloatingActionButton("Arabic", "ar", b1_isPressed? Colors.green : Colors.grey) : SizedBox(),
                SizedBox(width: 10.0,),
                showBtns? buildFloatingActionButton("Chinese", "zh-cn", b3_isPressed? Colors.green : Colors.grey) : SizedBox(),
                SizedBox(width: 10.0,),
                showBtns? buildFloatingActionButton("Frensh", "fr", b4_isPressed? Colors.green : Colors.grey) : SizedBox(),
                SizedBox(width: 10.0,),
                showBtns? buildFloatingActionButton("German", "de", b5_isPressed? Colors.green : Colors.grey) : SizedBox(),
                SizedBox(width: 10.0,),

              ],
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(String title, String code, Color color) {
    return FloatingActionButton(
                //mini: true,
                  backgroundColor: color,
                  child: Text(title, style: TextStyle(fontSize: 12.0),),
                  onPressed: () {
                  setState(() {
                    translateTo = code;
                    switch(code){
                      case "es": b2_isPressed=true;b1_isPressed=false;b3_isPressed=false;b4_isPressed=false;b5_isPressed=false;break;
                      case "ar": b1_isPressed=true;b2_isPressed=false;b3_isPressed=false;b4_isPressed=false;b5_isPressed=false;break;
                      case "zh-cn": b3_isPressed=true;b1_isPressed=false;b2_isPressed=false;b4_isPressed=false;b5_isPressed=false;break;
                      case "fr": b4_isPressed=true;b1_isPressed=false;b3_isPressed=false;b2_isPressed=false;b5_isPressed=false;break;
                      case "de": b5_isPressed=true;b1_isPressed=false;b3_isPressed=false;b4_isPressed=false;b2_isPressed=false;break;
                    }
                  });
                  });
  }

  void translation() async {
    final translator = GoogleTranslator();

    final input = "Здравствуйте. Ты в порядке?";

    translator.translate(input, to: 'ar').then((s) => print("Source: " +
        input +
        "\n"
            "Translated: " +
        s +
        "\n"));

    new Future.delayed(const Duration(seconds: 2));
    sleep(const Duration(seconds: 5));
    translator
        .translate(resultText, to: 'ar')
        .then((s) => arabicText = s + ".");

    // for countries that default base URL doesn't work
    translator.baseUrl = "https://translate.google.cn/translate_a/single";
    translator.translateAndPrint("This means 'testing' in chinese",
        to: 'zh-cn');
    //prints 这意味着用中文'测试'

    var translation = await translator
        .translate("I would buy a car, if I had money.", from: 'en', to: 'it');
    print("translation: " + translation);
    // prints translation: Vorrei comprare una macchina, se avessi i soldi.
  }
}
