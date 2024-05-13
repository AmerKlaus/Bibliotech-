import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

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
      bottomNavigationBar: MyNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class MyNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  MyNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home Page',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Book List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Library',
        ),
      ],
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
                _buildNewsItem('New Library Events Announced!', 'Discover exciting upcoming events at our library, from author talks to book clubs and more. Stay tuned for dates and details!'),
                SizedBox(height: 8.0),
                _buildNewsItem('Library Expansion Update', "Get the latest on our library's expansion project, including new sections, enhanced facilities, and a broader collection of books and resources."),
                SizedBox(height: 8.0),
                _buildNewsItem('Digital Library Access Now Available!', "Access our library's digital collection from anywhere, anytime. Explore e-books, audiobooks, and digital resources to enrich your reading experience."),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          // Logout Option
          ElevatedButton(
            onPressed: () {
              // Implement logout functionality here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Logout'),
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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;

  bool _isStrongPassword(String password) {
    // Password must be at least 8 characters long and contain a mix of letters, numbers, and symbols
    String pattern =
        r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  bool _isValidEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Future<void> _registerWithEmailAndPassword(BuildContext context) async {
    // Check if passwords match
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

    // Check if password meets strength requirements
    if (!_isStrongPassword(_passwordController.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Password is not strong enough. It must be at least 8 characters long and contain a mix of letters, numbers, symbols, and at least one big letter.'),
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

    // Check if email is valid
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
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Store additional user information in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid, // Store user ID in Firestore
        'email': _emailController.text,
      });

      // Navigate to home screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookListPage()),
      );
    } catch (e) {
      // Handle errors
      print('Failed to register: $e');
      // Show error message to the user
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
        child: Padding(
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
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
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
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
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
              ElevatedButton(
                onPressed: () => _registerWithEmailAndPassword(context),
                child: Text('Register'),
              ),
            ],
          ),
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

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.publisher,
    required this.description,
    required this.price,
    required this.imageURL,
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
        // Replace 'YOUR_API_KEY' with your actual API key
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
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  // Filter books based on search query
                  futureBooks = fetchRandomBooks()
                      .then((books) => books.where((book) =>
                  book.title.toLowerCase().contains(value.toLowerCase()) ||
                      book.author.toLowerCase().contains(value.toLowerCase()))
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
                          child: ListTile(
                            leading: Image.network(book.imageURL),
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
                              // Call reserveBook function
                              child: Text('Reserve'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              book.imageURL,
              width: MediaQuery.of(context).size.width,
              height: 300,
              fit: BoxFit.cover,
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
            Text('Description:'),
            Expanded(
              child: SingleChildScrollView(
                child: Text(book.description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // User is not logged in, display a message to log in
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

          // If there are no reserved books
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No books reserved yet.'),
            );
          }

          // If there are reserved books, display them in a ListView
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              // Check for null values before assigning to variables
              String id = data['id'] ?? '';
              String title = data['title'] ?? 'Unknown Title';
              String author = data['author'] ?? 'Unknown Author';
              String publishedDate = data['publishedDate'] ?? 'Unknown Date';
              String publisher = data['publisher'] ?? 'Unknown Publisher';
              String description = data['description'] ?? 'No description available';
              double price = (data['price'] ?? 0.0).toDouble();
              String imageURL = data['imageURL'] ?? '';

              // Create a Book object from the data
              Book reservedBook = Book(
                id: id,
                title: title,
                author: author,
                publishedDate: publishedDate,
                publisher: publisher,
                description: description,
                price: price,
                imageURL: imageURL,
              );

              // Display the reserved book in a ListTile or a custom widget
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Image.network(reservedBook.imageURL),
                  title: Text(reservedBook.title),
                  subtitle: Text('Author: ${reservedBook.author}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeReservedBook(document.id),
                    // Call removeReservedBook function
                  ),
                  // You can add more details here if needed
                ),
              );
            }).toList(),
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
      // Show success message or perform any other action
    } catch (e) {
      print('Error removing reserved book: $e');
      // Show error message or handle error as needed
    }
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
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
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
            Text.rich(
              TextSpan(
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
            Text.rich(
              TextSpan(
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
        padding: EdgeInsets.all(16.0),
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
            TextField(
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
