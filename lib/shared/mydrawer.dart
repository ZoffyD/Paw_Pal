import 'package:flutter/material.dart';
import 'package:pawpal/views/HomePage.dart';
import 'package:pawpal/views/MyPetScreen.dart';

import '../model/user.dart';
import '../myconfig.dart';
import '../shared/animated_route.dart';
import '../views/DonationHistoryScreen.dart';
import '../views/LoginPage.dart';
import '../views/ProfileScreen.dart';

class MyDrawer extends StatefulWidget {
  final User? user;
  const MyDrawer({super.key, this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenHeight;

  bool isGuest() {
    return widget.user?.id == "0";
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      elevation: 4,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: (widget.user != null && !isGuest())
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        '${Myconfig.baseUrl}/assets/person/person${widget.user!.id}.png?v=${DateTime.now().millisecondsSinceEpoch}',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            widget.user?.name?.isNotEmpty == true
                                ? widget.user!.name![0].toUpperCase()
                                : "?",
                                style: TextStyle(fontSize: 20),
                          );
                        },
                      ),
                    )
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_2, color: Colors.grey),
                  ),
            accountName: Text(widget.user?.name ?? 'Guest'),
            accountEmail: Text(widget.user?.email ?? 'Guest@gmail.com'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(Homepage(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('My Pet'),
            onTap: () {
              Navigator.pop(context);
              if (isGuest()) {
                showGuestAlert();
              } else {
                Navigator.pushReplacement(
                  context,
                  AnimatedRoute.slideFromRight(Mypetscreen(user: widget.user!)),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.volunteer_activism),
            title: Text('My Donation'),
            onTap: () {
              Navigator.pop(context);
              if (isGuest()) {
                showGuestAlert();
              } else {
                Navigator.pushReplacement(
                  context,
                  AnimatedRoute.slideFromRight(
                    MyDonationScreen(user: widget.user!),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              if (isGuest()) {
                showGuestAlert();
              } else {
                Navigator.pushReplacement(
                  context,
                  AnimatedRoute.slideFromRight(
                    ProfileScreen(user: widget.user!),
                  ),
                );
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginpage()),
              );
            },
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginpage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void showGuestAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please Login to use this feature"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
