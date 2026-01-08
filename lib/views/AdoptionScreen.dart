import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import '../model/pet.dart';
import '../model/user.dart';
import 'HomePage.dart';

class AdoptionScreen extends StatefulWidget {
  final User user;
  final pet petData;

  const AdoptionScreen({super.key, required this.user, required this.petData});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  TextEditingController motivationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adoption Request",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                "${Myconfig.baseUrl}/assets/pet/pet_${widget.petData.petid}_1.png",
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Adopt ${widget.petData.petname}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("Please tell us why you want to adopt this pet"),
            const SizedBox(height: 10),

            TextField(
              controller: motivationController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your motivation here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  if (motivationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please write a message")),
                    );
                    return;
                  }
                  showConfirmationDialog();
                },
                child: const Text(
                  "Submit Request",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm to adopt"),
          content: const Text(
            "Are you sure you want to submit this adoption request ?",
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () => submitAdoption(),
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void submitAdoption() {
    String motivation = motivationController.text;

    http
        .post(
          Uri.parse("${Myconfig.baseUrl}/api/adoption_request.php"),
          body: {
            "user_id": widget.user.id,
            "pet_id": widget.petData.petid,
            "motivation": motivation,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success']) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Request sent")));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(user: widget.user),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to send request")),
              );
            }
          }
        });
  }
}
