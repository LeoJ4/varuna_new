import 'package:flutter/material.dart';
import 'package:varuna_new/ui/admin_login_screen.dart';
import 'package:varuna_new/ui/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/color_helper.dart'; //FOR COLOR  ColorHelper()
import '../common/helper.dart'; //FOR TOAST showtoast()
import 'home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

void preloadMedia() async {
  // Start fetching media here, e.g., images or videos
  await FirebaseFirestore.instance.collection('media').get();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController pnoController = TextEditingController();
TextEditingController passwordController = TextEditingController();
CollectionReference usersTbl = FirebaseFirestore.instance.collection('users');

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  Future<void> _login() async {//login button on press code
    setState(() {
      isLoading = true; //toggle loading animation on or off
    });

    try {
      if (pnoController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        QuerySnapshot q = await usersTbl
            .where('pno', isEqualTo: pnoController.text)
            .where('password', isEqualTo: passwordController.text)
            .get();
        DocumentSnapshot d =  await usersTbl.doc('I98pJ91wSVu56eZ1vEDN').get();
        String p = d.get('pno').toString();
        String n = d.get('name').toString();

        if (q.docs.isNotEmpty) {//if credentials ok push to homescreen page
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(pno: p, name: n,)));
        } else {
          Helper.showToast("Invalid or Unregistered Credential ");
        }
      } else {
        // show error log
        Helper.showToast("Please enter all fields ");
      }
    } catch (e) {
      // Handle errors (e.g., Firebase exceptions)
      Helper.showToast("An error occurred during login.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.whiteColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 25,
                    color: ColorHelper.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: pnoController,
                    decoration: InputDecoration(
                      labelText: 'Enter service no',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _login,
                  //if isloading is true, do nothing. Else, isloading = true
                  child: isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                      : Text("Login", style: TextStyle(color: ColorHelper.whiteColor)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    backgroundColor: ColorHelper.aquatic,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Register", style: TextStyle(color: ColorHelper.blackColor)),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    backgroundColor: Colors.redAccent,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("ADMIN PORTAL", style: TextStyle(color: ColorHelper.blackColor)),
                ),
              ], //design of
            ),
          ),
        ),
      ),
    );
  }
}