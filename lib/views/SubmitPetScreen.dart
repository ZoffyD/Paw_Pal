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
          'Submit New Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle("Pet Photos"),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageSlot(1, image1, true),
                      if( image1 !=null)
                      _buildImageSlot(2, image2, true),
                      if( image2 !=null)
                      _buildImageSlot(3, image3, true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              _buildSectionTitle("Infomation"),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        petNameController,
                        "Pet Name",
                        Icons.pets,
                        false,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              ageController,
                              "Age",
                              Icons.calendar_today,
                              false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdown(
                              gender,
                              selectedGender,
                              "Gender",
                              Icons.male,
                              (val) {
                                setState(() => selectedGender = val!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildSectionTitle("Pet Details"),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDropdown(
                        petType,
                        selectedType,
                        "Pet Type",
                        Icons.pets_sharp,
                        (val) => setState(() => selectedType = val!),
                      ),
                      const SizedBox(height: 10),
                      _buildDropdown(
                        category,
                        selectedCategory,
                        "Post Category",
                        Icons.category,
                        (val) => setState(() => selectedCategory = val!),
                      ),
                      const SizedBox(height: 10),
                      _buildDropdown(
                        health,
                        selectedHealth,
                        "Health Status",
                        Icons.medical_services,
                        (val) => setState(() => selectedHealth = val!),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          prefixIcon: const Icon(
                            Icons.description,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 242, 235, 235),
                        ),
                        onChanged: (value) => description = value,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 3,
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: InputBorder.none,
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
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical:16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  showSubmissionDialog();
                },
                child: Text('Submit Post', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildImageSlot(int num, File? image, bool isEnable) {
    return GestureDetector(
      
      onTap: () => chooseImageSource(num),
      child: Container(
        width: width / 4.0,
        height: 100,
        decoration: BoxDecoration(
          color: isEnable
          ? (image == null ? const Color.fromARGB(255, 190, 190, 190) : Colors.white)
          :Colors.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnable
            ? (image == null ? const Color.fromARGB(255, 246, 243, 243) : Colors.blue)
            : Colors.grey,
            width: image == null ? 1 : 2,
          ),
          image: image != null
              ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
              : null,
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEnable ? Icons.add_a_photo : Icons.lock, 
                    color: isEnable ? Colors.black
                    : Colors.black),
                  const SizedBox(height: 4),
                  Text("Photo $num", style: TextStyle(fontSize:10, color: Colors.black, fontWeight: FontWeight.bold))
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.blue),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool manyLine,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: const Color.fromARGB(255, 242, 235, 235)
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String value,
    String label,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: const Color.fromARGB(255, 242, 235, 235),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
      ),
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val, 
          child: Text(val)
          );
      }).toList(),
      onChanged: onChanged,
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
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 5),
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
            'gender': gender,
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
