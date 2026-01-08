import 'package:flutter/material.dart';
import 'package:pawpal/views/LoginPage.dart';
import '../model/pet.dart';
import '../model/user.dart';
import '../myconfig.dart';
import 'AdoptionScreen.dart';
import 'DonationScreen.dart';

class PetDetailScreen extends StatefulWidget {
  final User user;
  final pet petData;

  const PetDetailScreen({super.key, required this.user, required this.petData});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  bool isGuest() {
    return widget.user.id == "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pet Details",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                color: const Color.fromARGB(255, 207, 207, 207),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadiusGeometry.vertical(
                  
                  bottom: Radius.circular(30),
                ),
                child: Image.network(
                  '${Myconfig.baseUrl}/assets/pet/pet_${widget.petData.petid}_1.png',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.pets, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Text(
                          widget.petData.petname.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                  const SizedBox(height: 4),
                  Text(
                    "Posted on: ${widget.petData.created_at}",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  infoCard(
                    Icons.pets_outlined, 
                    "Gender", 
                    widget.petData.gender.toString()
                    ),
                  infoCard(
                    Icons.calendar_today_outlined, 
                    "Age", 
                    "${widget.petData.age} years old"
                    ),
                  infoCard(
                    Icons.health_and_safety, 
                    "Health", 
                    widget.petData.health.toString()
                    ),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.petData.description.toString(),
                      style: TextStyle(
                        color:  Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        (widget.petData.petCategory == 'Donation Request' ||
                            widget.petData.petCategory == 'Help/Rescue')
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            icon: const Icon(
                              Icons.volunteer_activism,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Donate Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              if (isGuest()) {
                                showLoginDialog();
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DonationScreen(
                                      user: widget.user,
                                      petData: widget.petData,
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            icon: const Icon(Icons.home, color: Colors.white),
                            label: const Text(
                              "Request to Adopt",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              if (isGuest()) {
                                showLoginDialog();
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdoptionScreen(
                                      user: widget.user,
                                      petData: widget.petData,
                                    ),
                                  ),
                                );
                              }
                            },
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

  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Please login to use the features"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginpage()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  Widget infoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 93, 93, 93)),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
