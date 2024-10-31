import 'package:flutter/material.dart';
import 'package:varuna_new/ui/admin_login_screen.dart';
import 'package:varuna_new/ui/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/color_helper.dart'; //FOR COLOR
import '../common/helper.dart'; //FOR TOAST
import 'home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
CollectionReference usersTbl = FirebaseFirestore.instance.collection('users');

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea( //leaves a padding on top to prevent overlap with phone UI
      child: Scaffold(
        backgroundColor: ColorHelper.whiteColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("SIGN IN",style: TextStyle(fontSize: 20 ,color: ColorHelper.blackColor, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10), //pads the text wrt screen
                child: TextField(
                  controller: emailController, //Stores input to emailController
                  decoration: InputDecoration(
                    labelText: 'Enter username/ email',
                    hintText: 'USERNAME/ E-MAIL',
                    border: OutlineInputBorder(), //without this no borders on textfield
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passwordController, //stores input to passwordController
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(), //prebuilt function for outline on input
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHelper.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                //CODE FOR CHECK OF PROPER USAGE
                onPressed: ()async{
                  if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                    QuerySnapshot q = await usersTbl
                        .where('email', isEqualTo: emailController.text)
                        .where('password', isEqualTo: passwordController.text)
                        .get(); //retrieves user info with match
                    if (q.docs.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    } else {
                      Helper.showToast("Invalid Credential"); //Method From class helper
                    }
                  }else{
                    // show error log
                  }
                },
                child: Text("Login",style: TextStyle(color: ColorHelper.whiteColor),),
              ),

              SizedBox(height: 20),
              ElevatedButton(onPressed: () async {
                GoogleSignIn gsin = GoogleSignIn(); //google signin class
                /*googleSignIn.signOut();
                return;*/
                //object gsin provides sign in, sign out
                GoogleSignInAccount? googleUser = await gsin.signIn();
                if (googleUser == null) {//if sing in was stopped/ unsuccessful
                  return null;
                }
                  await usersCollection.add(
                      {
                        'name': googleUser.displayName.toString(),
                        'mobile': "9999999999",
                        'email': googleUser.email.toString(),
                        'password': "123456"
                      });

                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

              }, style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black, // Shadow color
                  backgroundColor: ColorHelper.aquatic,
                  elevation: 10, // Elevation of the button
                  shape: RoundedRectangleBorder( // Shape of the button
                    borderRadius: BorderRadius.circular(12),
                  )
              ),
              child: Text("Log in using Gmail account",style: TextStyle(color: ColorHelper.blackColor),)),
              SizedBox(height: 10,),

              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
              }, style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black, // Shadow color
                  backgroundColor: ColorHelper.aquatic,
                  elevation: 10, // Elevation of the button
                  shape: RoundedRectangleBorder( // Shape of the button
                    borderRadius: BorderRadius.circular(12),
                  )
              ),
                  child: Text("New User? Click to Register",style: TextStyle(color: ColorHelper.blackColor),)),
              SizedBox(height: 10,),

              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
              }, style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black, // Shadow color
                  backgroundColor: Colors.redAccent,
                  elevation: 10, // Elevation of the button
                  shape: RoundedRectangleBorder( // Shape of the button
                    borderRadius: BorderRadius.circular(12),
                  )
              ),
                  child: Text("Admin Section",style: TextStyle(color: ColorHelper.blackColor)),
              )],
          ),
        ),
      ),
    );
  }
}

