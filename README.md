
# 🐾 PawPal  
### Flutter + PHP + MySQL  
Pet Adoption & Donation Mobile Application

---

## 📌 Project Overview

PawPal is an **Android-based mobile application** developed using:

- **Flutter** (Frontend)
- **PHP** (Backend)
- **MySQL** (Database)

The application allows users to:
- Browse pets available for adoption
- Submit pets for adoption or donation
- Request pet adoption
- Donate to pets in need
- Manage user profile and wallet

Backend services are deployed on a **live server using cPanel**, and communication is handled through **HTTP GET/POST APIs with JSON responses**.

---

## 🔧 1. Requirements

- Flutter SDK (Android only)
- JomHosting / cPanel Hosting
- MySQL Database
- Billplz Sandbox Account (Payment Simulation)

---

## 📥 2. Installation

### 2.1 Clone Project

```bash
git clone https://github.com/ZoffyD/Paw_Pal.git
cd Paw_Pal
flutter pub get
````

---

### 2.2 Backend Setup (cPanel)

1. Login to **cPanel**
2. Open **File Manager**
3. Navigate to:

   ```
   public_html/
   ```
4. Upload the `server/` folder to:

   ```
   public_html/pawpal/server/
   ```

---

### 2.3 Database Setup

**Create Database**

* Database name: `pawpal_db`
* Create database user
* Assign user with **ALL PRIVILEGES**

**Import Database**

1. Open **phpMyAdmin**
2. Select `pawpal_db`
3. Import `pawpal_db.sql`

---

### 2.4 Configure Database Connection

Edit `server/api/dbconnect.php`:

```php
$servername = "localhost";
$username   = "cpanel_db_user";
$password   = "cpanel_db_password";
$dbname     = "cpanel_db_name";
```

---

### 2.5 Configure Flutter API URL

Edit `lib/myconfig.dart`:

```dart
static const String server = "https://yourdomain.com";
```

---

### 2.6 Billplz Sandbox Configuration

Login to:

```
https://sso.billplz-sandbox.com/
```

Update the following files:

**payment.php**

```php
$api_key = 'YOUR_API_KEY';
$collection_id = 'YOUR_COLLECTION_ID';
```

**payment_update.php**

```php
$xkey = 'YOUR_X_KEY';
```

---

## 📦 3. Flutter Dependencies

Ensure the following dependencies exist in `pubspec.yaml`:

```yaml
http: ^1.5.0
shared_preferences: ^2.3.2
geolocator: ^14.0.2
geocoding: ^4.0.0
image_picker: ^1.2.1
image_cropper: ^11.0.0
intl: ^0.20.2
webview_flutter: ^4.13.0
```

Run:

```bash
flutter pub get
```

---

## 📱 4. Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>

<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

---

## 📁 5. Folder Structure

```
pawpal/
├── server/
│   ├── api/
│   ├── uploads/
│   │   ├── pet/
│   │   └── profile/
├── lib/
│   ├── views/
│   ├── model/
│   └── myconfig.dart
```

---

## ✨ 6. Features & Functionality

### 🔐 User Authentication

* User registration with validation
* Login with SHA-1 password hashing
* Session stored using SharedPreferences
* Guest login supported

### 🐶 Public Pet Listing

* View all pets
* Search by pet name
* Filter by category
* Card layout using `ListView.builder`

### ➕ Pet Submission

* Submit pet for adoption or donation
* Upload up to **3 images**
* Images encoded in Base64
* Stored using `file_put_contents()`
* Data saved in `tbl_pets`

### 📄 Adoption Request

* Submit motivation message
* Validation applied
* Stored in `tbl_adoptions`

### 💖 Donation Module

* Donation types: Money, Food, Medical
* Conditional form inputs
* Stored in `tbl_donations`

### 💳 Payment

* Billplz sandbox payment via WebView
* Payment status update

### 👤 Profile Management

* View & edit profile
* Upload profile image
* Wallet balance simulation

---

## ⚙️ 7. API Endpoints

| Endpoint                     | Method | Description      |
| ---------------------------- | ------ | ---------------- |
| /register_user.php           | POST   | Register user    |
| /login_user.php              | POST   | Login user       |
| /get_all_pets.php            | GET    | Load all pets    |
| /get_my_pets.php             | GET    | Load user pets   |
| /submit_pet.php              | POST   | Submit pet       |
| /update_profile.php          | POST   | Update pet       |
| /get_user_detail.php         | GET    | Get user detail  |
| /delete_pet.php              | POST   | Delete pet       |
| /adoption_request.php        | POST   | Adoption request |
| /submit_donation.php         | POST   | Submit donation  |
| /get_my_donations.php        | GET    | Donation history |
| /payment.php                 | GET    | Create payment   |
| /payment_update.php          | GET    | Update payment   |

---

## 🖼 8. Image Storage

```
/server/api/uploads/pet/pet_<id>_<index>.png
/server/api/uploads/profile/person<id>.png
```

Image paths are stored in the database as a **JSON array**.

---

## ❗ Notes

* HTTPS must be enabled
* Android only (no iOS)
* Billplz used in sandbox mode
* All APIs return JSON

---

## ✅ Conclusion

PawPal is a complete Flutter–PHP–MySQL mobile application deployed using cPanel.
It demonstrates authentication, CRUD operations, image upload, payment simulation, and session management.


## Future Improvements
- Push notification support
- Admin approval workflow
- Enhanced payment gateway integration
- Advanced filtering and sorting
- UI/UX improvements
