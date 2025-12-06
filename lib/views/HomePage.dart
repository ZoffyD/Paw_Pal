import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/model/service.dart';
import 'package:pawpal/views/LoginPage.dart';
import 'package:pawpal/views/MainPage.dart';
import 'package:pawpal/views/SubmitPetScreen.dart';

class Homepage extends StatefulWidget {
  final User? user;

  const Homepage({super.key, required this.user});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<service> petList = [];
  String status = "Loading . . .";
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PawPal Home Page',
          style: TextStyle(fontSize: 24, color: Colors.yellowAccent),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.yellowAccent),
            onPressed: () {
              loadAll();
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.yellowAccent),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage(user: widget.user)),
              );
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
                              vertical: 8,
                              horizontal: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),

                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenWidth * 0.22,
                                      color: Colors.grey,

                                      child: Image.network(
                                        '${Myconfig.baseUrl}/pawpal_db/assets/pet/pet_${petList[index].petid}_1.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.pets,
                                                size: 50,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: ${petList[index].petname.toString()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Type: ${petList[index].petType.toString()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Category: ${petList[index].petCategory.toString()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Description: ${petList[index].description.toString()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDetails(index);
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_sharp,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
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
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      
    );
  }

  void loadAll() {
    petList.clear();
    setState(() {
      status = "Loading . . .";
    });
    http
        .get(Uri.parse('${Myconfig.baseUrl}/pawpal_db/api/getalldetails.php'))
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(service.fromJson(item));
              }
              setState(() {
                status = "";
              });
            } else {
              setState(() {
                petList.clear();
                status = "No pets yet";
              });
            }
          } else {
            setState(() {
              status = "Failed to load data.";
            });
          }
        });
  }
  void showDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(petList[index].petname.toString()),
          content: SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Image.network(
                      '${Myconfig.baseUrl}/pawpal_db/assets/pet/pet_${petList[index].petid}_1.png',
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
                  SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    columnWidths: {
                      0: FixedColumnWidth(100.0),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pet Name'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petname.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pet Type'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petType.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Category'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                petList[index].petCategory.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Description'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                petList[index].description.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Pet Owner'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].name.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Phone'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].phone.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Em'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].email.toString()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future<User> getPetOwnerDetails(int index) async {
      String petownerid = petList[index].userId.toString();
      User petOwner = User();
      try {
        final response = await http.get(
          Uri.parse(
            '${Myconfig.baseUrl}/pawpal/api/getOwnerDetails.php?userid=$petownerid',
          ),
        );
        if (response.statusCode == 200) {
          var jsonResponse = response.body;
          var resarray = jsonDecode(jsonResponse);
          if (resarray['success'] == true) {
            petOwner = User.fromJson(resarray['data'][0]);
          }
        }
      } catch (e) {
        print('Fetching user data error :$e');
      }
      return petOwner;
    }
  }
}
