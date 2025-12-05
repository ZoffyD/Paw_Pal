import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/MainPage.dart';
import 'package:pawpal/views/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late double height, width;
  bool visible = true;
  bool isChecked = false;

  late User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if (width > 400) {
      width = 400;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Page",
          style: TextStyle(fontSize: 25, color: Colors.yellowAccent),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(16.0),
                  child: Image.asset('assets/image/pawpal.png', scale: 2.0),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: visible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (visible) {
                          visible = false;
                        } else {
                          visible = true;
                        }
                        setState(() {});
                      },
                      icon: Icon(Icons.visibility),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 5.0),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Remember Me"),
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          isChecked = value!;
                          setState(() {});
                          if (isChecked) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              prefUpdate(isChecked);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Preferences Stored"),
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please fill in all the details",
                                  ),
                                  duration: Duration(seconds: 4),
                                ),
                              );
                              isChecked = false;
                              setState(() {});
                            }
                          } else {
                            prefUpdate(isChecked);
                            if (emailController.text.isEmpty &&
                                passwordController.text.isEmpty) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Preferences Removed"),
                                duration: Duration(seconds: 4),
                                backgroundColor: Colors.red,
                              ),
                            );
                            emailController.clear();
                            passwordController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      loginuser();
                    },
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 7.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Text('Don\'t have an account? Register here.'),
                ),
                SizedBox(height: 7.0),
                Text('Forgot Password?'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void prefUpdate(bool isChecked) async {
    //save email and password
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberme', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberme');
    }
  }

  void loadPreferences() {
    //load saved email and password
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberme');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? "";
        passwordController.text = password ?? "";
        isChecked = true;
        setState(() {});
      }
    });
  }

  void loginuser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all the details"),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    http
        .post(
          Uri.parse('${Myconfig.baseUrl}/pawpal_db/api/login_user.php'),
          body: {"email": email, "password": password},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = (response.body);

            var resarray = json.decode(jsonResponse);
            if (resarray['success']) {
              user = User.fromJson(resarray['data'][0]);
              print (resarray['data'][0]); 
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login Failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
