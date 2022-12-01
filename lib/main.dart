// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdvancedScreen(),
    );
  }
}


const _googleIcon = 'assets/images/google.png';
const _dartIcon = 'assets/images/dart.png';
const _flutterIcon = 'assets/images/flutter.png';

class AdvancedScreen extends StatefulWidget {
  const AdvancedScreen({super.key});

  @override
  _AdvancedScreenState createState() => _AdvancedScreenState();
}

class _AdvancedScreenState extends State<AdvancedScreen>
    with SingleTickerProviderStateMixin {
  double validScratches = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener(
        (listener) {
          if (listener == AnimationStatus.completed) {
            _animationController.reverse();
          }
        },
      );
    _animation = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Scratch Card",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildRow(_dartIcon, _flutterIcon),
            buildRow(_flutterIcon, _googleIcon),
            buildRow(_dartIcon, _flutterIcon),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String left, String center,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScratchBox(image: left),
        ScratchBox(
          image: center,
          animation: _animation,
          onScratch: () {
            setState(() {
              validScratches++;
              if (validScratches == 3) {
                _animationController.forward();
              }
            });
          },
        ),
      ],
    );
  }
}



class ScratchBox extends StatefulWidget {
  const ScratchBox({super.key, 
    required this.image,
    this.onScratch,
    this.animation,
  });

  final String image;
  final VoidCallback? onScratch;
  final Animation<double>? animation;

  @override
  _ScratchBoxState createState() => _ScratchBoxState();
}

class _ScratchBoxState extends State<ScratchBox> {
  bool isScratched = false;
  double opacity = 0.5;

  @override
  Widget build(BuildContext context) {
    var icon = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 750),
      child: Image.asset(
        widget.image,
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    );

    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.all(10),
      child: Scratcher(
        accuracy: ScratchAccuracy.low,
        color: Colors.blueGrey,
        image: Image.asset('assets/images/scratch.png'),
        brushSize: 15,
        threshold: 60,
        onThreshold: () {
          setState(() {
            opacity = 1;
            isScratched = true;
          });
          widget.onScratch?.call();
        },
        child: Container(
          child: widget.animation == null
              ? icon
              : ScaleTransition(
                  scale: widget.animation!,
                  child: icon,
                ),
        ),
      ),
    );
  }
}