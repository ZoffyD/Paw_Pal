# Pawpal - Flutter + PHP + MySQL

PawPal Adoption and Donation application

# Installation
1. Install XAMPP
2. Open XAAMPP Control Panel and Start Apache and MySQL
3. Download the project as zip file
4. Extract the file in C:\xampp\htdcos
5. Open localhost/phpymyadmin
6. Create a database name "pawpal_db"
7. Import the database
8. After import successful, run the main file in VS code

# Project Overview

PawPal is a mobile application that supports **Android platform only**.  
It is developed using **Flutter** as the frontend, **PHP** as the backend, and **MySQL** as the database.

The application focuses on providing a platform for **pet adoption and donation**, where users can browse pets, submit adoption requests, donate to pets in need, and manage their user profile.

The system demonstrates full-stack mobile application development, including user authentication, CRUD operations, image upload, payment simulation, and session management.

---

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
