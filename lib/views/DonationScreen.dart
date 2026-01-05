import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/pet.dart';
import '../model/user.dart';
import '../myconfig.dart';


class DonationScreen extends StatefulWidget {
  final User user;
  final pet petData;

  const DonationScreen({super.key, required this.user, required this.petData});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final List<String> donationType = ['Money', 'Food', 'Medical'];
  String selectedType = 'Money';

  TextEditingController detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make a Donation"),
        backgroundColor: Colors.orange, // Orange to match the "Donate" theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                "${Myconfig.baseUrl}/assets/pet/pet_${widget.petData.petid}_1.png",
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Donate to ${widget.petData.petname}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            //Donation type
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Select Donation Type:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                underline: const SizedBox(),
                items: donationType.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          value == 'Money'
                              ? Icons.attach_money
                              : value == 'Food'
                              ? Icons.restaurant
                              : Icons.medical_services,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue!;
                    detailController.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Enter Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: detailController,
              keyboardType: selectedType == 'Money'
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: selectedType == 'Money'
                    ? "Enter Amount (RM)"
                    : "Enter description",
                hintText: selectedType == 'Money'
                    ? "e.g. 500"
                    : "e.g. two pax of antibodies",
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: submitDonation,
                child: Text(
                  "Confirm Donation",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitDonation() async {
    String input = detailController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in the details"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String amount = "0";
    String description = "";

    if (selectedType == "Money") {
      amount = input;

      if (double.tryParse(amount) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid amount"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      description = input;
    }

    try {
      final response = await http.post(
        Uri.parse("${Myconfig.baseUrl}/api/submit_donation.php"),
        body: {
          "userid": widget.user.id,
          "petid": widget.petData.petid,
          "donationType": selectedType, 
          "amount": amount,
          "description": description,
        },
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
           Navigator.pop(context); 
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text("Donation Successful!"),
               backgroundColor: Colors.green,
             ),
           );
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text(data['message'] ?? "Donation Failed"),
               backgroundColor: Colors.red,
             ),
           );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Server Error"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
