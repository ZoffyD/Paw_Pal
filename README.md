# Pawpal - Flutter + PHP + MySQL

PawPal Adoption and Donation application

# 🐾 PawPal – Pet Adoption & Donation App

PawPal is an **Android mobile application** developed using **Flutter**, **PHP**, and **MySQL**.  
The system allows users to browse pets, submit pets for adoption or donation, make adoption requests, donate to pets in need, and manage their user profile.

This project uses **live server deployment via cPanel** and demonstrates full-stack mobile development.

---

## 🔧 Project Setup

### 1. Requirements

- Flutter SDK (Android only)
- JomHosting / cPanel Hosting
- MySQL Database
- Billplz Sandbox Account (Payment Simulation)

---

## 📥 Installation

### 1. Clone Project

Clone or download the project:

1. Backend Setup (cPanel)
Upload Backend Files
Login to cPanel

Open File Manager

Go to:

Copy code
public_html/
Upload the server/ folder to:

bash
Copy code
public_html/pawpal/server/
3. Database Setup
Create Database
Open MySQL Databases

Create:

Database: pawpal_db

Database user & password

Assign user to database with ALL PRIVILEGES

Import Database
Open phpMyAdmin

Select pawpal_db

Import:

pgsql
Copy code
pawpal_db.sql
4. Configure Database Connection
Edit:

bash
Copy code
server/api/dbconnect.php
php
Copy code
$servername = "localhost";
$username   = "cpanel_db_user";
$password   = "cpanel_db_password";
$dbname     = "cpanel_db_name";
5. Configure Flutter API URL
Edit:

bash
Copy code
lib/myconfig.dart
dart
Copy code
static const String server = "https://yourdomain.com";
6. Billplz Sandbox Configuration
Login to:

arduino
Copy code
https://sso.billplz-sandbox.com/
Update API keys in:

payment.php
php
Copy code
$api_key = 'YOUR_API_KEY';
$collection_id = 'YOUR_COLLECTION_ID';
payment_update.php
php
Copy code
$xkey = 'YOUR_X_KEY';
7. Flutter Dependencies
Ensure these dependencies exist in pubspec.yaml:

yaml
Copy code
http: ^1.5.0
shared_preferences: ^2.3.2
geolocator: ^14.0.2
geocoding: ^4.0.0
image_picker: ^1.2.1
image_cropper: ^11.0.0
intl: ^0.20.2
webview_flutter: ^4.13.0
Run:

bash
Copy code
flutter pub get
8. Android Permissions
Add to:

css
Copy code
android/app/src/main/AndroidManifest.xml
xml
Copy code
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>

<activity
  android:name="com.yalantis.ucrop.UCropActivity"
  android:screenOrientation="portrait"
  android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
📁 Folder Structure
php-template
Copy code
pawpal/
│
├── server/
│   ├── api/
│   │   ├── dbconnect.php
│   │   ├── submit_pet.php
│   │   ├── get_my_pets.php
│   │   └── ...
│   │
│   ├── uploads/
│   │   ├── pet/
│   │   │   └── pet_<id>_<index>.png
│   │   └── profile/
│   │       └── user_<id>.png
│
├── lib/
│   ├── views/
│   ├── model/
│   └── myconfig.dart
⚙️ API Usage
Endpoint	Method	Description
/register_user.php	POST	Register new user
/login_user.php	POST	User login
/get_user_details.php	GET	Load user profile
/update_profile.php	POST	Update user profile
/get_all_pets.php	GET	Load public pet list
/get_my_pets.php	GET	Load user submitted pets
/submit_pet.php	POST	Submit new pet
/update_pet.php	POST	Update pet details
/delete_pet.php	POST	Delete pet
/submit_adoption_request.php	POST	Submit adoption request
/get_my_adoptions.php	GET	Load adoption history
/submit_donation.php	POST	Submit donation
/get_my_donations.php	GET	Load donation history
/payment.php	GET	Create payment
/payment_update.php	GET	Update payment status

🖼 Image Storage
Uploaded images are stored at:

bash
Copy code
/server/api/uploads/pet/pet_<id>_<index>.png
/server/api/uploads/person/person <id>.png
Image paths are stored in the database as a JSON array.

❗ Notes
HTTPS must be enabled on hosting

API URLs must match domain

Android only (no iOS support)

Billplz is used in sandbox mode only

--

# User Authentication

## User Registration

The user registration feature allows new users to create an account.

### Required Fields
- Name  
- Email  
- Phone number  
- Password  
- Confirm password  

### Validation Performed
- Email format validation  
- Phone number length between 10–11 digits  
- Password length more than 6 characters  
- Password and confirm password matching  
- Empty field validation  

After successful validation, a **POST request** is sent to the PHP backend.  
The backend returns a **JSON response** indicating success or failure.

---

## User Login

The user login feature allows registered users to access the system.

### Login Process
- User inputs email and password  
- Password is hashed using **SHA-1** and matched with database value  
- User details are loaded from MySQL  
- Successful login message is displayed  
- User is navigated to the main page with user information  
- “Remember Me” option stores login data using **SharedPreferences**

Guest access is also provided with limited functionality.

---

# Public Pet Listing

The public pet listing screen displays **all pets available in the system**, regardless of ownership.

### Features
- Fetch pet list using HTTP GET request from PHP API  
- Display pets using card layout (image, name, type, age)  
- Search pets by name  
- Filter pets by category (Dog, Cat, Rabbit, Other)  
- Clicking a pet navigates to the Pet Details screen  

---

# Pet Submission

## Submit Pet Screen

This feature allows registered users to submit pets for adoption or donation requests.

### Required Fields
- Pet name  
- Pet type (Dog, Cat, Rabbit, Other)  
- Category (Adoption, Donation Request, Help/Rescue)  
- Description (minimum 10 characters)  
- Upload pet images (maximum 3 images)  

### Image Upload Control
- Image upload is limited to **maximum 3 images**
- Image 2 upload is enabled only if Image 1 exists
- Image 3 upload is enabled only if Image 2 exists
- This ensures efficient control of image upload count

### Image Handling
- Image Picker for selecting images  
- Image preview before submission  
- Image cropping supported  

---

## Submission Flow

1. Validate all required fields  
2. Ensure no required information is missing  
3. Convert images to Base64 format  
4. Send POST request to `submit_pet.php`  
5. Backend saves images using `file_put_contents()`  
6. Pet data is inserted into `tbl_pets`  
7. App receives JSON success response  

---

# Pet Details & Adoption Request

The Pet Details screen displays complete information of the selected pet.

### Displayed Information
- Pet name  
- Gender  
- Age  
- Health status  
- Description  
- Posted date  

### Adoption Request
- “Request to Adopt” button is shown for adoption category  
- User enters a short motivation message  
- Empty field validation is applied  
- Adoption request is submitted to `tbl_adoptions`  
- Confirmation dialog is shown before submission  

---

# Donation Module

The donation module allows users to donate to pets that require help.

### Donation Types
- Money  
- Food  
- Medical  

### Donation Logic
- Money donation requires amount input  
- Food and Medical donations require description  
- Form validation ensures required fields are filled  
- Donation data is stored in `tbl_donations`  

---

# Donation History

The donation history screen displays all donations made by the logged-in user.

### Features
- Retrieve donation records using user_id  
- Display donation type, amount, and status  
- Show “No history available” message if no record exists  

---

# User Profile

The user profile screen displays the logged-in user’s information.

### Displayed Information
- Name  
- Email  
- Phone number  
- Profile image  
- Wallet balance  

### Additional Features
- Wallet top-up simulation  
- Access to edit profile  
- User session stored using SharedPreferences  

---

# Edit Profile

The edit profile feature allows users to update their personal information.

### Editable Fields
- Name  
- Phone number  
- Profile image  

### Process
- Image can be selected from gallery or camera  
- Image uploaded to server using PHP file upload  
- Updated information saved to `tbl_users`  
- Profile screen refreshes automatically  

---

# Backend APIs

## submit_pet.php
- user_id  
- pet_name  
- pet_type  
- category  
- description  
- latitude, longitude  
- Up to 3 Base64 encoded images  

# Future Improvements
- Push notification support
- Admin approval workflow
- Enhanced payment gateway integration
- Advanced filtering and sorting
- UI/UX improvements

# Conclusion
PawPal demonstrates a complete mobile application with Flutter frontend, PHP backend, and MySQL database integration.
The system fulfills all course requirements and showcases practical implementation of mobile web programming concepts
