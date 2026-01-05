import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/views/HomePage.dart';

class Submitpetscreen extends StatefulWidget {
  final User? user;

  const Submitpetscreen({super.key, required this.user});

  @override
  State<Submitpetscreen> createState() => _SubmitpetscreenState();
}

class _SubmitpetscreenState extends State<Submitpetscreen> {
  File? image1;
  File? image2;
  File? image3;
  ImagePicker picker = ImagePicker();

  //to be filled in
  List<String> gender = ['male', 'female'];
  String selectedGender = 'male';

  List<String> petType = ['Dog', 'Cat', 'Rabbit', 'Other'];
  String selectedType = 'Dog';

  List<String> category = ['Adoption', 'Donation Request', 'Help/Rescue'];
  String selectedCategory = 'Adoption';

  List<String> health = ['healthy', 'unhealthy'];
  String selectedHealth = 'healthy';

  String description = '';

  TextEditingController petNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  late double height, width;
  late Position position;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 600) {
      width = 600;
    } else {
      width = width;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Submit Pet Page',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      labelText: 'Pet Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Pet Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: gender.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Pet Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petType.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: category.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Health',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: health.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHealth = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    maxLines: 3,
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: () async {
                          position = await _determinePosition();
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                position.latitude,
                                position.longitude,
                              );
                          Placemark place = placemarks[0];
                          locationController.text =
                              "${place.street},\n${place.postalCode},${place.locality},\n${place.administrativeArea}, ${place.country}";
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text("Upload Pet Image (Max 3 images)"),
                  SizedBox(height: 10.0),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            chooseImageSource(1);
                          },
                          child: Container(
                            width: width / 4,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: image1 != null
                                  ? DecorationImage(
                                      image: FileImage(image1!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: image1 == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Upload image',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                        if (image1 != null)
                          GestureDetector(
                            onTap: () {
                              chooseImageSource(2);
                            },
                            child: Container(
                              width: width / 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                image: image2 != null
                                    ? DecorationImage(
                                        image: FileImage(image2!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: image2 == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: Colors.grey[700],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Upload image',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                        if (image2 != null)
                          GestureDetector(
                            onTap: () {
                              chooseImageSource(3);
                            },
                            child: Container(
                              width: width / 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                image: image3 != null
                                    ? DecorationImage(
                                        image: FileImage(image3!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: image3 == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: Colors.grey[700],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Upload image',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      showSubmissionDialog();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void chooseImageSource(int num) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickfromGallery(num);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickfromCamera(num);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickfromGallery(int num) async {
    if (image1 != null && image2 != null && image3 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only select up to 3 images'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);

    if (images == null) return;

    setState(() {
      if (num == 1) {
        image1 = File(images.path);
        cropImage(image1!, num);
      } else if (num == 2) {
        image2 = File(images.path);
        cropImage(image2!, num);
      } else if (num == 3) {
        image3 = File(images.path);
        cropImage(image3!, num);
      }
    });
  }

  Future<void> pickfromCamera(int num) async {
    if (image1 != null && image2 != null && image3 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only Max 3 images allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final XFile? images = await picker.pickImage(source: ImageSource.camera);

    if (images == null) return;
    setState(() {
      if (num == 1) {
        image1 = File(images.path);
        cropImage(image1!, num);
      } else if (num == 2) {
        image2 = File(images.path);
        cropImage(image2!, num);
      } else if (num == 3) {
        image3 = File(images.path);
        cropImage(image3!, num);
      }
    });
  }

  Future<void> cropImage(File currentFile, int num) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: currentFile.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.amberAccent,
          toolbarWidgetColor: Colors.blueAccent,
        ),
      ],
    );
    if (croppedFile != null) {
      currentFile = File(croppedFile.path);
    }
    switch (num) {
      case 1:
        image1 = currentFile;
        break;
      case 2:
        image2 = currentFile;
        break;
      case 3:
        image3 = currentFile;
        break;
    }
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //test where location service is enabled or not
      //if not
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  void showSubmissionDialog() {
    String name = petNameController.text.trim();
    //every field is not field
    if (name.isEmpty &&
        description.trim().isEmpty &&
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    //name validation
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter pet name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    //description validation
    if (description.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (description.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description should be at least 10 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    //image validation
    if (image1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Post'),
          content: const Text('Are you sure to submit this post? '),
          actions: [
            TextButton(
              onPressed: () {
                submitpost();
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void submitpost() async {
    String img1 = "";
    String img2 = "";
    String img3 = "";

    if (image1 != null) {
      img1 = base64Encode(image1!.readAsBytesSync());
    }
    if (image2 != null) {
      img2 = base64Encode(image2!.readAsBytesSync());
    }
    if (image3 != null) {
      img3 = base64Encode(image3!.readAsBytesSync());
    }

    String petName = petNameController.text.trim();
    String age = ageController.text;
    String gender = selectedGender;
    String Type = selectedType;
    String petCategory = selectedCategory;
    String health = selectedHealth;
    String desc = description;

    http
        .post(
          Uri.parse('${Myconfig.baseUrl}/api/submit_pet.php'),
          body: {
            'userid': widget.user!.id.toString(),
            'petName': petName,
            'age': age,
            'gender':gender,
            'petType': Type,
            'petCategory': petCategory,
            'health': health,
            'description': desc,
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
            'image1': img1,
            'image2': img2,
            'image3': img3,
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);

            if (resarray['success'] == true) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(user: widget.user),
                ),
              );

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pet submission successful'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pet submission failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}
