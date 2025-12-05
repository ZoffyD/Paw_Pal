import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/model/service.dart';
import 'package:pawpal/views/LoginPage.dart';
import 'package:pawpal/views/SubmitPetScreen.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<service> petList = [];
  String status = "No submission yet";
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadServices('');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PawPal Main Page',
          style: TextStyle(fontSize: 24, color: Colors.yellowAccent),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.yellowAccent),
            onPressed: () {
              loadServices('');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.yellowAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Loginpage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search",
                    ),
                  ),
                ),
              ),

              petList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page, size: 70),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: petList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),

                                  child: Image.network(
                                    '${Myconfig.baseUrl}/pawpal_db/assets/pet/pet_${petList[index].petid}_1.png',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.pets,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name: ${petList[index].petname.toString()}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Type: ${petList[index].petType.toString()}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Category: ${petList[index].petCategory.toString()}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Description: ${petList[index].description.toString()}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                          maxLines:2,
                                          overflow: TextOverflow.ellipsis,
                                      ), 
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Submitpetscreen(user: widget.user),
            )
          );
        },
        child:Icon(Icons.add),
        ),
    );
  }

  void loadServices(String query) {
    petList.clear();
    setState(() {
      status = "Loading . . .";
    });
    http.get(
      Uri.parse(
        '${Myconfig.baseUrl}/pawpal_db/api/get_my_pets.php?userid=${widget.user!.id}',
      ),
    ).then((response){
      if(response.statusCode == 200){
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['success']==true &&
           jsonResponse['data']!=null &&
           jsonResponse['data'].isNotEmpty){
            petList.clear();
            for(var item in jsonResponse['data']){
              petList.add(service.fromJson(item));
            }
            setState(() {
              status = "";
            });
        }else{
          setState(() {
            petList.clear();
            status = "No submission yet";
          });
        }
      }else{
        setState(() {
          status = "Failed to load data.";
          
        });
      }
    });
  }


}
