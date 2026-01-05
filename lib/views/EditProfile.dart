import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class Editprofile extends StatefulWidget {
  final User user;
  const Editprofile({super.key, required this.user});

  @override
  State<Editprofile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Editprofile> {
  File? image;
  String? serverImageName;

  ImagePicker picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //profile image
            Center(
              child: GestureDetector(
                onTap: pickimagedialog,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: buildProfileImage(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Icon(Icons.camera_alt, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.user.name ?? "User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputField("Name", nameController, Icons.person, false),
                    inputField("Phone", phoneController, Icons.phone, false),
                    inputField("Email", emailController, Icons.email, false),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: _updateProfile,
                        child: const Text(
                          "Save changes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nameController.text = prefs.getString('name') ?? widget.user.name ?? '';
      phoneController.text =
          prefs.getString('phone') ?? widget.user.phone ?? '';
      emailController.text =
          prefs.getString('email') ?? widget.user.email ?? '';

      String? savedImage = prefs.getString('profile_image');
      if (savedImage != null && savedImage.isNotEmpty) {
        serverImageName = savedImage;
      }
    });
  }

  Future<void> _updateProfile() async {
    String newName = nameController.text.trim();
    String newPhone = phoneController.text;
    String newEmail = emailController.text;

    if (newName.isEmpty || newPhone.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (newPhone.length < 10 || newPhone.length > 11) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid phone number'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(newEmail)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid email address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String base64Image = "";
    if (image != null) {
      base64Image = base64Encode(image!.readAsBytesSync());
    }

    try {
      final response = await http.post(
        Uri.parse('${Myconfig.baseUrl}/api/update_profile.php'),
        body: {
          "user_id": widget.user.id.toString(),
          "name": newName,
          "phone": newPhone,
          "email": newEmail,
          "image": base64Image,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', newName);
          await prefs.setString('phone', newPhone);
          await prefs.setString('email', newEmail);

          widget.user.name = newName;
          widget.user.phone = newPhone;
          widget.user.email = newEmail;

          if (data['new_image'] != null) {
            await prefs.setString('profile_image', data['new_image']);
            setState(() {
              serverImageName = data['new_image'];
              image = null;
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? "Update failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildProfileImage() {
    //if local image is choose from gallery
    if (image != null) {
      return CircleAvatar(
        radius: 90,
        backgroundColor: Colors.grey,
        backgroundImage: FileImage(image!),
      );
    }
    String url;
    if (serverImageName != null) {
      url = '${Myconfig.baseUrl}/pawpal/server/assets/person/$serverImageName?v=${DateTime.now().millisecondsSinceEpoch}';
    } else {
      url =
          '${Myconfig.baseUrl}/pawpal/server/assets/person/person_${widget.user.id}.png?v=${DateTime.now().millisecondsSinceEpoch}';
    }

    return CircleAvatar(
      radius: 90,
      backgroundColor: Colors.grey,
      child: ClipOval(
        child: Image.network(
          url,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => getInitialText(),
        ),
      ),
    );
  }

  Widget inputField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isPassword,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget getInitialText() {
    return Center(
      child: Text(
        widget.user.name != null && widget.user.name!.isNotEmpty
            ? widget.user.name![0].toUpperCase()
            : "?",
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void pickimagedialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Add Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose image source",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 20),

              _imageOption(
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),

              const SizedBox(height: 12),

              _imageOption(
                icon: Icons.photo_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: const Color(0xFF1F3C88)),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}
