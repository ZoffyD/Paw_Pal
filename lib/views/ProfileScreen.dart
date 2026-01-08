import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/EditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../shared/mydrawer.dart';
import 'paymentpage.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String email;
  late String phone;
  String wallet = "0.00";
  String? image;
  bool isLoading = false;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.user.name ?? "Guest";
    email = widget.user.email ?? "guest@gmail.com";
    phone = widget.user.phone ?? "Not set yet";

    loadLocalData();

    if (widget.user.id != "0") {
      _loadUserData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //  profile header
            Container(
              
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                children: [
                  buildProfileImage(),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //wallet
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(15),
              ),
              child: Container(
                height: 110,
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "My Wallet",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "RM $wallet",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 31, 60, 136),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Top Up",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showTopUpWalletDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  infoCard(Icons.phone, "Phone Number", phone),
                  infoCard(Icons.email, "Email Address", email),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Editprofile(user: widget.user),
                          ),
                        ).then((value) {
                          if (widget.user.id.toString() != "0") {
                            _loadUserData();
                          }
                        });
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${Myconfig.baseUrl}/api/get_user_detail.php?userid=${widget.user.id}',
        ),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          var userData = jsonResponse['data'][0];

          setState(() {
            name = userData['name'];
            phone = userData['phone'];
            email = userData['email'];
            wallet = double.parse(userData['wallet'] ?? "0").toStringAsFixed(2);

            widget.user.name = name;
            widget.user.email = email;
            widget.user.phone = phone;

            if (userData['profile_image'] != null &&
                userData['profile_image'].toString().isNotEmpty) {
              image = userData['profile_image'];
            }else{
              image = null;
            }
            isLoading = false;
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', name);
          await prefs.setString('phone', phone);
          await prefs.setString('email', email);
          await prefs.setString('wallet', wallet);
          if (image != null) {
            await prefs.setString('profile_image', image!);
          }
        }
      }
    } catch (e) {
      print("$e");
    }
  }

  Widget infoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      child: ListTile(
        leading: Container(
          height: 110,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 85, 85, 85)),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildProfileImage() {
    if (image == null || image!.isEmpty ) {
      return CircleAvatar(
        radius: 90,
        backgroundColor: Colors.white,
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width:4)
          ),
          alignment: Alignment.center,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        )
      );
    }
    String url = '${Myconfig.baseUrl}/assets/person/$image?v=${DateTime.now().millisecondsSinceEpoch}';

    return CircleAvatar(
      radius: 90,
      backgroundColor: Colors.grey,
      child: ClipOval(
        child: Image.network(
          url,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void showTopUpWalletDialog() {
    amountController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Top Up Wallet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter amount to be top up"),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  prefixText: "RM ",
                  hintText: "e.g. 100.00",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),

              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                double amount = double.tryParse(amountController.text) ?? 0.00;
                if (amount > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentScreen(user: widget.user, amount: amount),
                    ),
                  ).then((value) {
                    _loadUserData();
                  });
                }
              },
              child: Text("Top Up"),
            ),
          ],
        );
      },
    );
  }

  void loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? name;
      phone = prefs.getString('phone') ?? phone;
      email = prefs.getString('email') ?? email;
      wallet = prefs.getString('wallet') ?? wallet;

      String? savedImage = prefs.getString('profile_image');
      if (savedImage != null && savedImage.isNotEmpty) {
        image = savedImage;
      }
    });
  }
}
