import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/model/donation.dart';

import '../model/user.dart';
import '../myconfig.dart';
import '../shared/mydrawer.dart';

class MyDonationScreen extends StatefulWidget {
  final User user;
  const MyDonationScreen({super.key, required this.user});

  @override
  State<MyDonationScreen> createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {
  List<Donation> donationList = [];
  String status = "Loading ...";
  late double screenWidth, screenHeight;
  final dateformat = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    loadDonation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: const Text(
          "Donation History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: donationList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (status == "Loading...")
                    const CircularProgressIndicator()
                  else
                    Icon(Icons.history, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: donationList.length,
                itemBuilder: (context, index) {
                  return buildDonationCard(donationList[index]);
                },
              ),
              onRefresh: () async {
                loadDonation();
              },
            ),
    );
  }

  void loadDonation() async {
    if(widget.user.id =="0"){
      setState(() {
        status = "Please login to view history";
      });
      return;
    }

    try {
      var response = await http.get(
        Uri.parse("${Myconfig.baseUrl}/api/get_my_donation.php?userid=${widget.user.id}"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          var list = data['data'] as List;
          setState(() {
            donationList = list.map((item) => Donation.fromJson(item)).toList();
            status = donationList.isEmpty ? "No donation found" : "";
          });
        } else {
          setState(() {
            status = "No history available";
            donationList = [];
          });
        }
      }
    } catch (e) {
      setState(() {
        status = "Connection Error";
      });
    }
  }
}

Widget buildDonationCard(Donation donation) {
  bool isMoney = donation.donation_type == 'Money';

  IconData icon = isMoney ? Icons.attach_money : Icons.fastfood;
  Color iconColor = isMoney ? Colors.green : Colors.orange;

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: const EdgeInsets.all(15),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 15),
          //show details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To: ${donation.pet_name}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  donation.description ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isMoney
                    ? "RM ${double.parse(donation.amount!).toStringAsFixed(2)}"
                    : donation.donation_type!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isMoney ? Colors.blue : Colors.orange,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 15, 
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
