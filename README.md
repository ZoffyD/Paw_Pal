# Pawpal - Flutter + PHP + MySQL

PawPal Adoption and Donation application

# 🐾 PawPal – Pet Adoption & Donation Mobile Application

PawPal is an **Android-based mobile application** developed using **Flutter**, **PHP**, and **MySQL**.  
The system allows users to browse pets, submit pets for adoption or donation, request adoptions, donate to pets in need, and manage their user profile.

The backend is deployed on a **live server using cPanel**, and the frontend communicates with the backend using **HTTP GET/POST APIs with JSON responses**.

---

## 🔧 Project Setup

### 1. Requirements

- Flutter SDK (Android only)
- JomHosting / cPanel Hosting
- MySQL Database
- Billplz Sandbox Account (payment simulation)

---

## 📥 Installation

### 1. Clone Project

```bash
git clone https://github.com/ZoffyD/Paw_Pal.git
cd pawpal
flutter pub get
2. Backend Setup (cPanel)
Upload Backend Files
Login to cPanel

Open File Manager

Navigate to:

Copy code
public_html/
Upload the server/ folder to:

bash
Copy code
public_html/pawpal/server/
3. Database Setup
Open MySQL Databases

Create:

Database: pawpal_db

Database user & password

Assign the user to the database with ALL PRIVILEGES

Import Database
Open phpMyAdmin

Select pawpal_db

Import pawpal_db.sql

4. Configure Database Connection
Edit server/api/dbconnect.php:

php
Copy code
$servername = "localhost";
$username   = "cpanel_db_user";
$password   = "cpanel_db_password";
$dbname     = "cpanel_db_name";
5. Configure Flutter API URL
Edit lib/myconfig.dart:

dart
Copy code
static const String server = "https://yourdomain.com";
6. Billplz Sandbox Configuration
Login to:

arduino
Copy code
https://sso.billplz-sandbox.com/
Update:

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
Add to android/app/src/main/AndroidManifest.xml:

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
│   │   ├── login_user.php
│   │   ├── register_user.php
│   │   ├── submit_pet.php
│   │   ├── adoption_request.php
│   │   ├── submit_donation.php
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
✨ Application Features & Code Explanation
🔐 User Authentication
Registration

Inputs: name, email, phone, password

Validations:

Email format

Phone length (10–11)

Password > 6 characters

Empty field check

Password is hashed before saving

Data inserted into tbl_users

Login

Email + password authentication

Password matched using SHA-1 hashing

User session stored using SharedPreferences

Guest login supported with limited access

🐶 Public Pet Listing
Loads all pets from backend using GET request

Displays pet cards using ListView.builder

Search by pet name

Filter by pet type/category

Selecting a pet opens Pet Details screen

➕ Pet Submission
Submit Pet Screen

Required fields:

Pet name

Pet type

Category

Health status

Description

Location (latitude & longitude)

Upload up to 3 images

Image control:

Image 2 enabled only if Image 1 exists

Image 3 enabled only if Image 2 exists

Images are previewed and cropped before upload

Submission Flow

Validate all inputs

Convert images to Base64

Send POST request to submit_pet.php

Images saved using file_put_contents()

Pet record saved in tbl_pets

📄 Pet Details & Adoption
Displays full pet information

“Request to Adopt” button for adoption category

Adoption form:

Motivation message

Empty field validation

Data inserted into tbl_adoptions

💖 Donation Module
Donation types:

Money

Food

Medical

Conditional input:

Money → amount

Food/Medical → description

Donation saved in tbl_donations

💳 Payment (Billplz Sandbox)
Payment initiated via payment.php

WebView used for Billplz payment page

Payment status updated via payment_update.php

Payment records stored in tbl_payments

📜 Donation History
Displays all donations by logged-in user

Loaded using get_my_donations.php

Shows donation type, amount, and status

👤 User Profile & Edit Profile
Displays:

Name

Email

Phone

Profile image

Wallet balance

Edit profile:

Update name, phone, avatar

Image uploaded and stored on server

User session persists using SharedPreferences

⚙️ API Endpoints
Endpoint	Method	Description
/register_user.php	POST	Register new user
/login_user.php	POST	User login
/get_user_details.php	GET	Load user profile
/update_profile.php	POST	Update user profile
/get_all_pets.php	GET	Load all pets
/get_my_pets.php	GET	Load user pets
/submit_pet.php	POST	Submit new pet
/update_pet.php	POST	Update pet
/delete_pet.php	POST	Delete pet
/submit_adoption_request.php	POST	Submit adoption request
/get_my_adoptions.php	GET	Load adoption history
/submit_donation.php	POST	Submit donation
/get_my_donations.php	GET	Load donation history
/payment.php	GET	Create payment
/payment_update.php	GET	Update payment status

🖼 Image Storage
bash
Copy code
/server/api/uploads/pet/pet_<id>_<index>.png
/server/api/uploads/profile/user_<id>.png
Image paths are stored in the database as a JSON array.

❗ Notes
HTTPS must be enabled

Android platform only

Billplz used in sandbox mode

All APIs return JSON responses

✅ Conclusion
PawPal is a complete Flutter–PHP–MySQL mobile application deployed on a live server using cPanel.
It demonstrates authentication, CRUD operations, image upload, payment simulation, and session management. 

# Future Improvements
- Push notification support
- Admin approval workflow
- Enhanced payment gateway integration
- Advanced filtering and sorting
- UI/UX improvements


The system fulfills all course requirements and showcases practical implementation of mobile web programming concepts
