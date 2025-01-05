import 'package:flutter/material.dart';
import 'book.dart'; // Import the Book class
import 'search.dart'; // Import the Search class

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false; // Used to show books list or progress bar

  // Function to update the state of the books list
  void update(bool success) {
    setState(() {
      _load = true; // Show book list when data is loaded
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Load data when the widget is first added to the tree
    updateBooks(update); // Assuming `updateBooks` is the function to load books
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: !_load ? null : () {
              setState(() {
                _load = false; // Show progress bar while refreshing
                updateBooks(update); // Refresh the book data
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              // Navigate to the search page
              setState(() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Search()), // Open Search page for books
                );
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text('Available Books',style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // Show books or progress bar based on loading state
      body: _load ? const ShowBooks() // Display the books once they're loaded
       : const Center(child: CircularProgressIndicator()), // Show progress bar when loading
    );
  }
}
