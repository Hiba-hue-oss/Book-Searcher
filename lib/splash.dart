import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Animation controller for gradient transition
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this, // Use the 'this' keyword because the State class now provides TickerProvider
      duration: const Duration(seconds: 3), // Duration of the gradient change
    );

    // Create an animation that transitions between blue and red
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Start the animation when the widget is initialized
    _controller.forward();

    // Wait for 3 seconds and navigate to the Home page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // Using the animated color for the background
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, _colorAnimation.value ?? Colors.yellow],
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(seconds: 30),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1585007600263-71228e40c8d1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cmVhZGluZyUyMGljb258ZW58MHx8MHx8fDA%3D',
                  height: width * 0.3,
                  width: width * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
