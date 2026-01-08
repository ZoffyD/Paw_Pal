import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/views/SubmitPetScreen.dart';
import '../model/pet.dart';
import '../shared/mydrawer.dart';

class Mypetscreen extends StatefulWidget {
  final User? user;

  const Mypetscreen({super.key, required this.user});

  @override
  State<Mypetscreen> createState() => _MypetscreenState();
}

class _MypetscreenState extends State<Mypetscreen> {
  List<pet> petList = [];
  String status = "No submission yet";
  late double screenWidth, screenHeight;

  TextEditingController searchController = TextEditingController();

  List<String> filterList = ['All', 'Cat', 'Dog', 'Rabbit', 'Other'];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    loadPet();
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
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: Text(
          'My Pet',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.white, size: 30),
            onPressed: () {
              loadPet();
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
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              decoration: const InputDecoration(
                                hintText: "Search pets...",
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              onSubmitted: (value) => loadPet(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedFilter,
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.blueAccent,
                              ),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedFilter = newValue!;
                                });
                                loadPet();
                              },
                              items: filterList.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              //Pet List
              Expanded(
                child: petList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 60, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: petList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 0,
                              ),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: "pet_${petList[index].petid}",
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        color: Colors.grey[200],
                                        child: Image.network(
                                          '${Myconfig.baseUrl}/assets/pet/pet_${petList[index].petid}_1.png',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                  color: Colors.grey[400],
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            petList[index].petname.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  petList[index].petType
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blueAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                petList[index].age.toString(),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            petList[index].description
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDeleteDialog(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Post"),
          content: Text("Are you sure you want to delete ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deletePet(index);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void deletePet(int index) {
    http
        .post(
          Uri.parse("${Myconfig.baseUrl}/api/delete_pet.php"),
          body: {"petid": petList[index].petid},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['success'] == true) {
              setState(() {
                petList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pet deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to delete pet"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }

  void loadPet() {
    petList.clear();
    setState(() {
      status = "Loading . . .";
    });

    String search = searchController.text;

    http
        .get(
          Uri.parse(
            '${Myconfig.baseUrl}/api/get_my_pets.php?userid=${widget.user!.id}&search=$search&filter=$selectedFilter',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(pet.fromJson(item));
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
}
