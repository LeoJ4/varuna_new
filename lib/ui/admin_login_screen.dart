import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../common/color_helper.dart';
import '../common/helper.dart';
import 'admin_home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

TextEditingController emailController = TextEditingController(text: "Joel47");
TextEditingController passwordController = TextEditingController(text: "12345678jt");
 late CollectionReference users;

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  @override
  void initState() {
    users = FirebaseFirestore.instance.collection('admin_cred');
    super.initState();
  }

  loginAdmin() async{
    QuerySnapshot q = await users
        .where('id', isEqualTo: emailController.text)
        .where('pass', isEqualTo: passwordController.text)
        .get();

    if (q.docs.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));
    } else {
      Helper.showToast("Invalid Credential"); //From class helper
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorHelper.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ADMIN PANEL",
              style: TextStyle(
                  color: ColorHelper.blackColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter username/ email',
                  hintText: 'USERNAME/ E-MAIL',
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
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHelper.blackColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              onPressed: () {
                if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                  loginAdmin();
                } else {
                  // show error log
                }
              },
              child: Text(
                "Login",
                style: TextStyle(color: ColorHelper.whiteColor),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
