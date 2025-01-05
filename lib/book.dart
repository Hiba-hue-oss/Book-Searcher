import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

// main URL for REST pages
const String _baseURL = '4558232.atwebpages.com';

// class to represent a row from the books table
class Book {
  int _id;
  String _title;
  String _author;
  String _subject;
  String _bookPicture;

  Book(this._id, this._title, this._author, this._subject, this._bookPicture);

  // Getter methods
  int get id => _id;
  String get title => _title;
  String get author => _author;
  String get subject => _subject;
  String get bookPicture => _bookPicture;

  @override
  String toString() {
    return """
Id: $_id
Title: $_title
Author: $_author
Subject: $_subject""";
  }
}

// list to hold books retrieved from the books table
List<Book> _books = [];

// Asynchronously update book list
void updateBooks(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getBooks.php'); // Adjust this PHP file name if necessary
    final response = await http.get(url).timeout(const Duration(seconds: 30)); // 30 seconds timeout
    _books.clear();

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Book b = Book(
            int.parse(row['id']),
            row['title'],
            row['author'],
            row['subject'],
            row['book_picture']
        );
        _books.add(b);
      }
      update(true); // Callback with success
    } else {
      update(false); // Callback with failure
    }
  } catch (e) {
    update(false); // Callback with failure if there's an error
  }
}

void searchBook(Function(List<Book>) update, String query) async {
  try {

    // Construct the URL with the encoded query
    final url = Uri.http(_baseURL, 'searchBooks.php', {'query': query.trim()});

    print('Full URL: $url');


    // Make the GET request
    final response = await http.get(url).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      List<Book> books = [];

      // Iterate over the response and create Book objects
      for (var row in jsonResponse) {
        Book b = Book(
            int.parse(row['id']),
            row['title'],
            row['author'],
            row['subject'],
            row['book_picture']
        );
        books.add(b);
      }

      // Pass the list of books to the update function
      update(books);
    } else {
      // If the response status is not 200, return an empty list
      update([]);
    }
  } catch (e) {
    // In case of any errors (e.g., network failure), return an empty list
    update([]);
  }
}

// Function to generate colors for the boxes based on hue
Color getAmberColor(int index) {
  double hue = 45.0; // Amber hue in HSV (fixed)
  double saturation = 0.8 + (index % 2) * 0.2; // Alternate saturation for variation
  double value = 0.8 - (index % 2) * 0.1; // Alternate value for lighter/darker shades

  return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
}

Color getCyanColor(int index) {
  double hue = 180.0; // Cyan hue in HSV (fixed)
  double saturation = 0.8 + (index % 2) * 0.2; // Alternate saturation for variation
  double value = 0.8 - (index % 2) * 0.1; // Alternate value for lighter/darker shades

  return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
}

class ShowBooks extends StatelessWidget {
  const ShowBooks({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) => Column(
        children: [
          const SizedBox(height: 10),
          Container(
            // Apply amber or cyan based on index (even or odd)
            decoration: BoxDecoration(
              color: index % 2 == 0 ? getAmberColor(index) : getCyanColor(index),
              borderRadius: BorderRadius.circular(15), // Rounded corners for the box
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            width: width * 0.9,
            child: Row(
              children: [
                // Display the book image with a fixed size and rounded edges
                ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Apply rounded corners to the image
                  child: Image.network(
                    _books[index]._bookPicture.replaceAll(r'\\', ''), // Remove extra slashes if any
                    height: 160, // Fixed height for all images
                    width: 100,  // Fixed width for all images
                    fit: BoxFit.cover, // Ensures the image scales properly without distortion
                  ),
                ),
                SizedBox(width: width * 0.15),
                Flexible(
                  child: Text(
                    _books[index].toString(),
                    style: TextStyle(
                      fontSize: width * 0.04, // Slightly bigger font size
                      fontFamily: 'Cursive', // Custom font (you can choose another aesthetic font)
                      fontWeight: FontWeight.bold, // Bold text
                      color: Colors.white, // White text for contrast
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ], // Adding shadow effect
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
