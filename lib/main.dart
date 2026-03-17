import 'package:flutter/material.dart';
import 'screens/studHomePage.dart';   // student dashboard
import 'screens/adminHomePage.dart'; // admin dashboard


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/auth',
    routes: {
      '/auth': (context) => AuthScreen(),
      '/studentHome': (context) => StudentHomePage(),
      '/adminHome': (context) => AdminHomePage(),
    },
    theme: ThemeData(
      primarySwatch: Colors.cyan,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  ));
}

// Authentication screen
class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In / Sign Up"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to ValidApp",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan[700],
                ),
              ),
              SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  // Simple role check
                  if (email == "admin@validapp.com" && password == "admin123") {
                    Navigator.pushReplacementNamed(context, '/adminHome');
                  } else {
                    Navigator.pushReplacementNamed(context, '/studentHome');
                  }
                },
                child: Text("Sign In", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 15),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.cyan),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/studentHome');
                },
                child: Text("Create Account", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}