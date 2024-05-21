import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliotech',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Index 1 for Book List

  final List<Widget> _pages = [
    HomePage(), // Index 0 for Home
    BookListPage(), // Index 1 for Book List
    LibraryPage(), // Index 2 for Library
    ProfilePage(), // Index 3 Profile page
    SettingsPage(), // Index 4 Settings page
    EventPage(), // Index 5 Event Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bibliotech'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}

class MyNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  MyNavigationBar({required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Books',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
      ],
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Latest News Section
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest News',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.0),
                _buildNewsItem(
                  'New Library Events Announced!',
                  'Discover exciting upcoming events at our library, from author talks to book clubs and more. Stay tuned for dates and details!',
                ),
                SizedBox(height: 8.0),
                _buildNewsItem(
                  'Library Expansion Update',
                  "Get the latest on our library's expansion project, including new sections, enhanced facilities, and a broader collection of books and resources.",
                ),
                SizedBox(height: 8.0),
                _buildNewsItem(
                  'Digital Library Access Now Available!',
                  "Access our library's digital collection from anywhere, anytime. Explore e-books, audiobooks, and digital resources to enrich your reading experience.",
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          // Logout Option
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(description),
        Divider(),
      ],
    );
  }
}
  Widget _buildNewsItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(description),
        Divider(),
      ],
    );
  }


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  bool _isStrongPassword(String password) {
    String pattern = r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  bool _isValidEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Future<void> _registerWithEmailAndPassword(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (!_isStrongPassword(_passwordController.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Password is not strong enough. It must be at least 8 characters long and contain a mix of letters, numbers, symbols, and at least one uppercase letter.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid email format.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
        'userId': userCredential.user!.uid,
        'email': _emailController.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookListPage()),
      );
    } catch (e) {
      print('Failed to register: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to register. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bibliotech'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bibliotech',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Create Account',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              'Let\'s get started by filling out the form below.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _registerWithEmailAndPassword(context),
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                textStyle: TextStyle(fontSize: 18),
                minimumSize: Size(double.infinity, 50), // Set width to fill parent and height to 50
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String publishedDate;
  final String publisher;
  final String description;
  final double price;
  final String imageURL;
  final String previewLink;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.publisher,
    required this.description,
    required this.price,
    required this.imageURL,
    required this.previewLink,
  });
}

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late Future<List<Book>> futureBooks = Future.value([]);
  final CollectionReference reservedBooksCollection =
  FirebaseFirestore.instance.collection('ReservedBooks');

  Random random = Random();
  TextEditingController searchController = TextEditingController();

  Future<List<Book>> fetchRandomBooks() async {
    final response = await http.get(
      Uri.https('www.googleapis.com', '/books/v1/volumes', {
        'q': 'subject:fiction',
        'maxResults': '20',
        'key': 'AIzaSyB_Keln8dwtYVbQ9216wJxD4aqc3sXD514',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Book> books = [];

      for (var item in data['items']) {
        var volumeInfo = item['volumeInfo'];
        var saleInfo = item['saleInfo'];

        // Generate random price between $5 and $50
        double price = 5 + random.nextDouble() * (50 - 5);

        books.add(Book(
          id: item['id'],
          title: volumeInfo['title'] ?? 'Unknown Title',
          author:
          volumeInfo['authors'] != null && volumeInfo['authors'].isNotEmpty
              ? volumeInfo['authors'][0]
              : 'Unknown Author',
          publishedDate: volumeInfo['publishedDate'] ?? 'Unknown Date',
          publisher: volumeInfo['publisher'] ?? 'Unknown Publisher',
          description: volumeInfo['description'] ?? 'No description available',
          price: price,
          imageURL: volumeInfo['imageLinks'] != null
              ? volumeInfo['imageLinks']['thumbnail'] ?? ''
              : '',
          previewLink: volumeInfo['previewLink'] ?? '',
        ));
      }

      return books;
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  Future<void> reserveBook(Book book) async {
    try {
      // Check if the user has already reserved the book
      bool alreadyReserved = await checkIfBookReserved(book.id);
      if (alreadyReserved) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('You have already reserved this book.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // If the book is not already reserved, proceed with reservation
      await reservedBooksCollection.add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'bookId': book.id,
        'title': book.title,
        'author': book.author,
        'publishedDate': book.publishedDate,
        'publisher': book.publisher,
        'description': book.description,
        'price': book.price,
        'imageURL': book.imageURL,
        'reservedAt': Timestamp.now(),
        'previewLink': book.previewLink,
      });
      // Show success message or perform any other action
    } catch (e) {
      print('Error reserving book: $e');
      // Show error message or handle error as needed
    }
  }

  Future<bool> checkIfBookReserved(String bookId) async {
    try {
      // Check if the current user has already reserved the book
      var query = await reservedBooksCollection
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('bookId', isEqualTo: bookId)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking reservation: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    futureBooks = fetchRandomBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Filter books based on search query
                  futureBooks = fetchRandomBooks().then((books) => books
                      .where((book) =>
                  book.title
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                      book.author
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList());
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Book>>(
                future: futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Book book = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 4.0,
                          child: ListTile(
                            leading: Image.network(
                              book.imageURL,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(book.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Author: ${book.author}'),
                                SizedBox(height: 4.0),
                                Text('Price: \$${book.price.toStringAsFixed(2)}'),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => reserveBook(book),
                              child: Text('Reserve'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                textStyle: TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(book: book),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final Book book;

  BookDetailsPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    book.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                book.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Author: ${book.author}'),
              Text('Published Date: ${book.publishedDate}'),
              Text('Publisher: ${book.publisher}'),
              SizedBox(height: 16.0),
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(book.description),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewListPage(book: book),
                    ),
                  );
                },
                child: Text('View Reviews'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Library'),
        ),
        body: Center(
          child: Text('Please log in to view your reserved books.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ReservedBooks')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No books reserved yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              String id = data['id'] ?? '';
              String title = data['title'] ?? 'Unknown Title';
              String author = data['author'] ?? 'Unknown Author';
              String publishedDate = data['publishedDate'] ?? 'Unknown Date';
              String publisher = data['publisher'] ?? 'Unknown Publisher';
              String description = data['description'] ?? 'No description available';
              double price = (data['price'] ?? 0.0).toDouble();
              String imageURL = data['imageURL'] ?? '';
              String previewLink = data['previewLink'] ?? '';

              Book reservedBook = Book(
                id: id,
                title: title,
                author: author,
                publishedDate: publishedDate,
                publisher: publisher,
                description: description,
                price: price,
                imageURL: imageURL,
                previewLink: previewLink,
              );

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Image.network(
                    reservedBook.imageURL,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(reservedBook.title),
                  subtitle: Text('Author: ${reservedBook.author}'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeReservedBook(document.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _navigateToReviewPage(context, reservedBook),
                      ),
                      IconButton(
                        icon: Icon(Icons.book),
                        onPressed: () =>
                            _navigateToBookContentPage(context, reservedBook),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _removeReservedBook(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('ReservedBooks')
          .doc(documentId)
          .delete();
    } catch (e) {
      print('Error removing reserved book: $e');
    }
  }

  void _navigateToReviewPage(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewSubmissionPage(book: book)),
    );
  }

  void _navigateToBookContentPage(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookContentPage(book: book)),
    );
  }
}

class BookContentPage extends StatelessWidget {
  final Book book;

  BookContentPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: book.previewLink.isNotEmpty
            ? ElevatedButton(
          onPressed: () => _launchURL(book.previewLink),
          child: Text('Read Book'),
        )
            : Text('No preview available for this book.'),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


class ReviewSubmissionPage extends StatefulWidget {
  final Book book;

  ReviewSubmissionPage({required this.book});

  @override
  _ReviewSubmissionPageState createState() => _ReviewSubmissionPageState();
}

class _ReviewSubmissionPageState extends State<ReviewSubmissionPage> {
  String reviewMessage = '';
  int rating = 0;

  void _submitReview() async {
    if (reviewMessage.isNotEmpty && rating > 0) {
      try {
        await FirebaseFirestore.instance.collection('Reviews').add({
          'bookName': widget.book.title,
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'reviewMessage': reviewMessage,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully')),
        );
        Navigator.pop(context); // Return to previous page after submission
      } catch (e) {
        print('Error submitting review: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a review message and rating')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book: ${widget.book.title}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Your Review:', style: TextStyle(fontSize: 16)),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write your review here',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (value) {
                setState(() {
                  reviewMessage = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Rating:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    icon: Icon(Icons.star, size: 30),
                    onPressed: () {
                      setState(() {
                        rating = i;
                      });
                    },
                    color: i <= rating ? Colors.yellow : Colors.grey,
                  ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Submit Review', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewListPage extends StatelessWidget {
  final Book book;

  ReviewListPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for ${book.title}'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Reviews')
            .where('bookName', isEqualTo: book.title)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // If there are no reviews for this book
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No reviews available for this book.'),
            );
          }

          // If there are reviews, display them in a ListView
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              String userId = data['userId'];
              String reviewMessage = data['reviewMessage'];
              int rating = data['rating'];

              // Fetch user details from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(reviewMessage),
                      subtitle: Text('Rating: $rating'),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text(reviewMessage),
                      subtitle: Text('Rating: $rating'),
                    );
                  }

                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                    String userName = userData?['name'] ?? 'Unknown User';
                    String userEmail = userData?['email'] ?? 'No email provided';

                    return ListTile(
                      title: Text(reviewMessage),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rating: $rating'),
                          Text('By: $userName'),
                          Text('Email: $userEmail'),
                        ],
                      ),
                    );
                  } else {
                    return ListTile(
                      title: Text(reviewMessage),
                      subtitle: Text('Rating: $rating'),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage() {
    _emailController.text = '';
    _passwordController.text = '';
  }

  Future<void> _loginWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Handle errors
      print('Failed to login: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Failed to login. Please check your credentials and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bibliotech',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _loginWithEmailAndPassword(context),
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Sign up here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    // Add onPressed callback for navigation
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                text: 'Forgot your password? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Reset it here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    // Add onPressed callback for navigation
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to forgot password page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      // Show success message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Password reset email sent. Please check your email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors
      print('Failed to send password reset email: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
          Text('Failed to send password reset email. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forgot Your Password?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Enter your email address below to receive a password reset link.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/default_profile_image.png'),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  var userEmail = userData['email'] ?? 'No email found';
                  var userName = userData['name'] ?? 'No name found';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: $userName',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Email: $userEmail',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Account Settings',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the ForgotPasswordPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text('Change Password'),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current user information
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    // Dispose text controllers
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadUserProfile() async {
    // Load user profile data from Firestore and set the text controllers
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          _nameController.text = userSnapshot['name'] ?? '';
          _emailController.text = userSnapshot['email'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  void _saveProfileChanges() async {
    // Save the updated profile information to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'name': _nameController.text,
        'email': _emailController.text,
      });
      // Navigate back to the ProfilePage after saving changes
      Navigator.pop(context); // Close the EditProfilePage
      Navigator.pushReplacement(
        // Navigate back to ProfilePage, replacing the current route
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      print('Error saving profile changes: $e');
      // Show error message to the user if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile changes. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveProfileChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to notifications settings page
              },
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    // Navigate to notifications settings page
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Notifications Settings',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _showFAQ(context);
              },
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    _showFAQ(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Help and Support',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Logout functionality
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    // Logout functionality
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFAQ(BuildContext context) {
    // Show a dialog with FAQ or navigate to a FAQ page
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("FAQ"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Q: How do I reset my password?"),
                SizedBox(height: 8),
                Text("A: You can reset your password by..."),
                SizedBox(height: 16),
                Text("Q: Can I change my username?"),
                SizedBox(height: 8),
                Text("A: No, currently you cannot change your username."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to feedback form page
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackFormPage()),
                );
              },
              child: Text('Submit Feedback'),
            ),
          ],
        );
      },
    );
  }
}
class FeedbackFormPage extends StatelessWidget {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit Feedback',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () {
                _submitFeedback(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback(BuildContext context) async {
    String subject = subjectController.text.trim();
    String message = messageController.text.trim();

    if (subject.isNotEmpty && message.isNotEmpty) {
      // Save feedback to Firestore
      await FirebaseFirestore.instance.collection('feedback').add({
        'subject': subject,
        'message': message,
        'timestamp': DateTime.now(),
      });

      // Clear text fields
      subjectController.clear();
      messageController.clear();

      // Navigate back to Help and Support page
      Navigator.pop(context);
    } else {
      // Show error message if subject or message is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both subject and message.'),
      ));
    }
  }
}

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: ListView(
        children: [
          EventWidget(
            event: Event(
              name: 'Book Signing Event',
              imageUrl:
                  'https://static.wikia.nocookie.net/lotr/images/8/87/Ringstrilogyposter.jpg/revision/latest/scale-to-width-down/1000?cb=20210720095933',
              dateTime: DateTime(2024, 4, 18, 12, 30),
              // Friday, April 18th, 12:30 PM
              description:
                  'During the event, attendees would have the opportunity to meet Tolkien, briefly converse with him, and have their books signed. It\'s a special occasion for fans to connect with the author, express their admiration for his work, and obtain a personalized memento in the form of a signed book.',
              location: '4545 Pierre-de Coubertin Ave\nMontreal, QC. H1V 3N7',
              spotsRemaining: 250,
            ),
          ),

          // Add more EventWidget instances here for other events
          EventWidget(
            event: Event(
              name: 'Book Signing Event',
              imageUrl:
                  'https://cdn.mos.cms.futurecdn.net/d4RuRPLJHfAyUJiusHpZem-650-80.jpg.webp',
              dateTime: DateTime(2024, 4, 20, 10, 30),
              // Friday, April 18th, 12:30 PM
              description:
                  'During the event, fans will have the chance to meet Rob MacGregor, the acclaimed author of numerous Indiana Jones novels. They can enjoy a brief conversation with him and get their books signed. This is a unique opportunity to connect with the author, share their appreciation for his work, and leave with a special signed memento',
              location: '4545 Pierre-de Coubertin Ave\nMontreal, QC. H1V 3N7',
              spotsRemaining: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String name;
  final String imageUrl;
  final DateTime dateTime;
  final String description;
  final String location;
  final int spotsRemaining;

  Event({
    required this.name,
    required this.imageUrl,
    required this.dateTime,
    required this.description,
    required this.location,
    required this.spotsRemaining,
  });
}

class EventWidget extends StatelessWidget {
  final Event event;

  EventWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 8),
          Image.network(
            event.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Text(
            '${DateFormat('EEEE, MMMM d || hh:mm a').format(event.dateTime)}',
          ),
          SizedBox(height: 8),
          Text(
            'During the event, attendees would have the opportunity to meet Tolkien, briefly converse with him, and have their books signed. It\'s a special occasion for fans to connect with the author, express their admiration for his work, and obtain a personalized memento in the form of a signed book.',
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Event Location:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(event.location, style: TextStyle(color: Colors.black)),
                // Changed text color to black
                SizedBox(height: 8),
                Text('Spots Remaining: ${event.spotsRemaining}'),
              ],
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (event.spotsRemaining > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationConfirmationPage(
                      name: '',
                      email: '',
                      event: event,
                    ),
                  ),
                );
              }
            },
            child: Text('Reserve Now'),
          ),
        ],
      ),
    );
  }
}

class ReservationConfirmationPage extends StatelessWidget {
  final String name;
  final String email;
  final Event event;

  ReservationConfirmationPage(
      {required this.name, required this.email, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Congratulations!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Your event ticket has been successfully reserved.'),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
