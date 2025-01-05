import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MoodTrackerApp());

class MoodTrackerApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
theme: ThemeData.dark().copyWith(
scaffoldBackgroundColor: Colors.deepPurpleAccent,
),
home: MoodTrackerPage(),
);
}
}

class MoodTrackerPage extends StatefulWidget {
@override
_MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
final List<String> moods = ["Happy", "Sad", "Excited", "Anxious", "Calm"];
final List<String> quotes = [
"Keep smiling, the world is brighter with you!",
"It's okay to feel down sometimes. Take it one step at a time.",
"Channel your excitement into something amazing today!",
"Take a deep breath. You’re stronger than your fears.",
"Stay calm and let the good vibes flow."
];

int? selectedMoodIndex;
String? displayedQuote;

void handleMoodSelection(int index) {
setState(() {
selectedMoodIndex = index;
displayedQuote = quotes[index];
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text("Mood Tracker"),
backgroundColor: Colors.deepPurple,
),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"How are you feeling today?",
style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
textAlign: TextAlign.center,
),
SizedBox(height: 20),
Wrap(
spacing: 10,
runSpacing: 10,
children: List.generate(moods.length, (index) {
return GestureDetector(
onTap: () => handleMoodSelection(index),
child: Container(
padding: EdgeInsets.all(12),
decoration: BoxDecoration(
color: selectedMoodIndex == index
? Colors.greenAccent
: Colors.purple[700],
borderRadius: BorderRadius.circular(8),
),
child: Text(
moods[index],
style: TextStyle(
fontSize: 18,
color: Colors.white,
),
),
),
);
}),
),
SizedBox(height: 30),
if (displayedQuote != null)
Column(
children: [
Text(
"Here's some motivation:",
style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
),
SizedBox(height: 10),
Text(
"\"$displayedQuote\"",
style: TextStyle(
fontSize: 16,
fontStyle: FontStyle.italic,
),
textAlign: TextAlign.center,
),
],
),
],
),
),
);
}
}
