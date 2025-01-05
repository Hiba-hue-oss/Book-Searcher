import 'package:flutter/material.dart';
import 'book.dart'; // Import the Book class

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // Controller to store search query text
  final TextEditingController _controllerQuery = TextEditingController();
  String _text = ''; // Displays book info or error message
  List<Book> _searchResults = []; // Stores the search results

  @override
  void dispose() {
    _controllerQuery.dispose();
    super.dispose();
  }

  // Update book info or display error message
  void updateSearchResults(List<Book> books) {
    setState(() {
      _searchResults = books;
      // If no books found, update the text to display no results message
      if (_searchResults.isEmpty) {
        _text = "No books found.";
      }
    });
  }

  // Called when user clicks on the find button
  void getBooks() {
    String query = _controllerQuery.text.trim();
    if (query.isNotEmpty) {
      searchBook(updateSearchResults, query); // Search asynchronously for books based on query
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a search query')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Search input field
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controllerQuery,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter book title, author, or subject',
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Search button
            ElevatedButton(
              onPressed: getBooks,
              child: const Text(
                'Find',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            // Display search results
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    Book book = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: index % 2 == 0 ? Colors.amber[200] : Colors.cyan[100],
                      child: ListTile(
                        leading: Image.network(
                          book.bookPicture.replaceAll(r'\\', ''), // Remove extra slashes from the URL
                          height: width * 0.3,
                        ),
                        title: Text(book.title),
                        subtitle: Text('Author: ${book.author} \nSubject: ${book.subject}'),
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Text(
                  _text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
