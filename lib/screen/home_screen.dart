import 'package:flutter/material.dart';
import 'package:template_project/providers/auth_provider.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bg.jpeg'), // Ganti dengan path aset lokal Anda
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImagePlaceholder(),
                  SizedBox(height: 20),
                  TitleText(),
                  SizedBox(height: 10),
                  DescriptionText(),
                  SizedBox(height: 40),
                  ActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Aplikasi Kami",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24, // Ukuran font untuk judul
        fontWeight: FontWeight.bold, // Menebalkan teks
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/OIP.jpeg', // Ganti dengan path aset lokal Anda
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "SELAMAT DATANG DI APLIKASI KAMI",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.blue,
            shadowColor: Colors.blueAccent,
            elevation: 5,
          ),
          child: Row(
            children: [
              Icon(Icons.login),
              SizedBox(width: 5),
              Text("Sign In"),
            ],
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.green,
            shadowColor: Colors.greenAccent,
            elevation: 5,
          ),
          child: Row(
            children: [
              Icon(Icons.app_registration),
              SizedBox(width: 5),
              Text("Sign Up"),
            ],
          ),
        ),
      ],
    );
  }
}
