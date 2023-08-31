import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplitScreenPage extends StatefulWidget {
  const SplitScreenPage({super.key});

  @override
  _SplitScreenPageState createState() => _SplitScreenPageState();
}

class _SplitScreenPageState extends State<SplitScreenPage> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: -math.pi,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 90,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Swipe for safety',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: 0,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 90,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Swipe for unsafety',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2-3,
                top: 180,
                bottom: 180,
                width: 1,
                child: Container(
                  color: Colors.white,
                ),
              ),
              Positioned(
                left: 30,
                top: 75,
                child: GestureDetector(
                  onTap: _toggleVisibility,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 10,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Click to return to \n previous image',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}