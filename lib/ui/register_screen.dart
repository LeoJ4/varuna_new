import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:varuna_new/ui/login_screen.dart';

import '../common/color_helper.dart';
import '../common/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

//global variables ?
TextEditingController nameController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.whiteColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Register Area",style: TextStyle(color: ColorHelper.blackColor),),
              SizedBox(height: 40,),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]")),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: mobileController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter your mobile number',
                    hintText: 'Enter your mobile number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passwordController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),


              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHelper.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: () {
                  if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && mobileController.text.isNotEmpty){
                    if(mobileController.text.length < 10){
                      Helper.showToast("enter correct mobile number");
                    }else{
                      addData();
                    }
                  }else{
                    Helper.showToast("enter all field");
                  }
                },
                child: Text("Register",style: TextStyle(color: ColorHelper.whiteColor),),
              ),

              SizedBox(height: 20,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHelper.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Back to sing in",style: TextStyle(color: ColorHelper.whiteColor),),
              ),


            ],
          ),
        ),
      ),
    );
  }

  void addData() async{
    await usersCollection.add(
        {
          'name': nameController.text.toString(),
          'mobile': mobileController.text.toString(),
          'email': emailController.text.toString(),
          'password': passwordController.text.toString()
        });
    Helper.showToast("Registerd SuccessFully");
  }
}

