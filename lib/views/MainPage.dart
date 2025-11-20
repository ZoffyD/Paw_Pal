import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PawPal',
          style: TextStyle(fontSize: 24, color: Colors.yellowAccent),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome , ${widget.user?.name}!", style: TextStyle(color: Colors.blue, fontSize: 30) ),
              ],
          ),
        ),
      ),
    );
  }
}
