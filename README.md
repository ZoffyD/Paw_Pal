# Pawpal - Flutter + PHP + MySQL

PawPal Adoption and Donation application

# Project Overview 
PawPal is a mobile application that support only android version.
It is build using Flutter as frontend, PHP as backend, and MySQL (database)

For now, the project focuses on "User Authentication" and "Pet Submission", which include 
image uploads and list out user submissions.

In future, there will be further implementation and improvement will be done.

# User Authentication 
User Registration 
- Name, email, phone, password, confirm password
Hence validation is done to validate
-email ( correct format)
-phone ( length between 10-11 long)
-password ( more than 6 char long)
-password match 
-empty field validation
after validate will send POST request to PHP API
JSON response handling


User Login
- Email + Password input
-SHA-1 hashed password match
-Loads user details from MySQL
-Displays successful login message
-Navigates to Main Page with user info
-“Remember Me” stored using SharedPreferences

# Pet Submission
SubmitPet Screen
The required field for the submission are:
- pet name
- pet type (dog, cat, rabbit, other)
- category (adoption, donation request, help/rescue)
- description (min 10 characters)
- Auto-filled location using geolocation
- upload images (maximum 3 images can be upload)
  but it is control using 3 if to check if image1 is not null hence box to upload image2 will be visible same as image3, hence it is efficient to control not more than 3 can be upload
  in the upload images have three important things which is (image picker, preview, cropper)

# Submission flow:
- validate all field ( ensure all field is filled, no required info is miss out)
- encode images to Base64
- send the filled in data to submit_pet.php
- file_put_contents() is used to saved images at backend
- data is added into tbl_pets
- app then will receive a success message

# Backend 
submit_pet.php
-user_id
-pet name
-pet type
-category
-description
-latitude, longitude
- up to 3 Base64 images

For the processes, the image file name is created as like this pet_(petid)_(number of images).png
Hence, it saves using file_put_contents(), then all data is saved in MySQL.

get_my_pets.php
This is created for the purpose of getting the user submission, which was successfully posted.

getalldetails.php
This is created for to load all the services from all users

# Examples of JSON Response
FROM submit_pet.php 
-successful pet submission 
 $response = array('success' => true, 'message' => 'Pet Submitted successful');

FROM get_my_pets.php
-no submission
$response = array("success"=> false,"message"=> "No submission yet", "data"=>[]);
