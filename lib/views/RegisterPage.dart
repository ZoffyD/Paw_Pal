import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmpasswordController = TextEditingController();

  late double height, width;
  bool isVisible = true;
  bool isLoading = false;

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
          'Register',
          style: TextStyle(color: Colors.amber, fontSize: 23.0),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/image/pawpal.png', scale: 2.0),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: passwordController,
                    obscureText: isVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (isVisible) {
                            isVisible = false;
                          } else {
                            isVisible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    controller: ConfirmpasswordController,
                    obscureText: isVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (isVisible) {
                            isVisible = false;
                          } else {
                            isVisible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Register button is pressed');
                        RegisterValidation();
                      },
                      child: Text('Register'),
                    ),
                  ),
                  SizedBox(height: 7.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginpage(),
                        ),
                      );
                    },
                    child: Text('Already have an account ? Login here'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void RegisterValidation() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = ConfirmpasswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all details'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (password != confirmpassword) {
      SnackBar snackBar = const SnackBar(content: Text('Password not match'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if(password .length < 6){
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;  
    }
    if(phone.length < 10 || phone.length > 11){
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid phone number'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;  
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid email address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to register this account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              registerUser(email, name, phone, password);
            },
            child: Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void registerUser(
    String email,
    String name,
    String phone,
    String password,
  ) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              SizedBox(width: 20),
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
    await http
        .post(
          Uri.parse('${Myconfig.baseUrl}/pawpal/api/register_user.php'),
          body: {
            'email': email,
            'name': name,
            'password': password,
            'phone': phone,
          },
        )
        .then((response) {
          print(response.statusCode);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(jsonResponse);
            
            if (resarray['success']) {
              if (!mounted) return;
              SnackBar snackBar = const SnackBar(
                content: Text('Register successful'),
              );
              //close the loading dialog
              if (isLoading) {
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {
                  isLoading = false;
                });
              }
              //close the confirmation dialog
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginpage()),
              );
            } else {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(content: Text(resarray['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text('Registration fail. Please try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .timeout(
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Request Timed Out. Please try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );
    if (isLoading) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }
  }
}