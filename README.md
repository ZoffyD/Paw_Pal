# pawpal

PawPal Adoption and Donation application
it includes Flutter + php + mySQL

For now it focus on Login and Register function

There a few page for now
-main 
-LoginPage
-RegisterPage
-MainPage
-SplashScreen 
-user

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

