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
    return widget.user.id == 0;
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
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
              child: Image.network(
                '${Myconfig.baseUrl}/assets/pet/pet_${widget.petData.petid}_1.png',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.pets, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(
                color: Colors.blueGrey,
                width: 1.0,
                style: BorderStyle.solid,
              ),
              columnWidths: {0: FixedColumnWidth(100.0), 1: FlexColumnWidth()},
              children: [
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Pet Name'),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.petData.petname.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Gender'),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.petData.gender.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Age'),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.petData.age.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Health'),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.petData.health.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('description'),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.petData.description.toString()),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('posted by'),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.petData.created_at.toString()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

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
                        style: TextStyle(color: Colors.white,fontSize: 20),
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
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
}
