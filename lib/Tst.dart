//import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'dart:async';
//import 'dart:io';
//
//class TextToSpeech extends StatefulWidget {
//  @override
//  _TextToSpeechState createState() => _TextToSpeechState();
//}
//
//enum TtsState { playing, stopped }
//
//
//class _TextToSpeechState extends State<TextToSpeech> with TickerProviderStateMixin{
//  FlutterTts flutterTts = new FlutterTts();
//
//  TtsState ttsState = TtsState.stopped;
//  get isPlaying => ttsState == TtsState.playing;
//  get isStopped => ttsState == TtsState.stopped;
//
//  initTts() {
//    flutterTts = FlutterTts();
//
//    flutterTts.setLanguage("ar");
//
//    flutterTts.setStartHandler(() {
//      setState(() {
//        ttsState = TtsState.playing;
//      });
//    });
//
//    flutterTts.setCompletionHandler(() {
//      setState(() {
//        ttsState = TtsState.stopped;
//      });
//    });
//
//    flutterTts.setErrorHandler((msg) {
//      setState(() {
//        ttsState = TtsState.stopped;
//      });
//    });
//  }
//
//
//
//    Future _speak() async{
//    var result = await flutterTts.speak("خالد عبد الرا");
//    if (result == 1) setState(() => ttsState = TtsState.playing);
//  }
//
//
//  Future _stop() async{
//    var result = await flutterTts.stop();
//    if (result == 1) setState(() => ttsState = TtsState.stopped);
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: FloatingActionButton(onPressed: (){_speak()}),
//
//    );
//  }
//}
