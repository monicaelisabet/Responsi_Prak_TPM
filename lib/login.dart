import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'database.dart';
import 'moviescreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void _login(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    DatabaseHelper helper = DatabaseHelper();
    List<Map<String, dynamic>> users = await helper.getUser(username);

    if (users.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('User not found.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    Map<String, dynamic> user = users.first;
    if (user['password'] == password) {
      _navigateToHome(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid password.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 64.0),
              Image.asset(
                'assets/image/movie.webp',
                width: 350.0,
                height: 400.0,
              ),
              SizedBox(height: 32.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  minimumSize: Size(200, 50),
                ),
              ),
              SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Dont have an account? ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _navigateToRegister(context);
                        },
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

  