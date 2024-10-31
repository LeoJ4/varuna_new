import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:varuna_new/ui/login_screen.dart';

import '../common/color_helper.dart';
import '../common/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getSecretKey() async {//first collection, then key, then field
  CollectionReference keyCollection = FirebaseFirestore.instance.collection('secretkey');
  DocumentSnapshot sk = await keyCollection.doc('passwords').get();//document
  return sk.get('key'); //field name
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

//global variables ?
TextEditingController nameController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController keyController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController pnoController = TextEditingController();
final RegExp pnoregex = RegExp(r'^\d{5}[a-zA-Z]$');

String? skey;
CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');


class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {// built-in method called automatically when widget starts
    super.initState();//calls parent class init state
    loadSecretKey(); //asynchronous call to future type method
  }

  Future<void> loadSecretKey() async {
    // Await the result and update the state
  skey = await getSecretKey(); // global method defined at top
    setState(() {}); // refreshes the UI after retrieving the key i.e. after skey gets its value
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.whiteColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          
                Text("REGISTRATION",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: ColorHelper.blackColor),),
                SizedBox(height: 30,),
          
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),//NAME
          
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: pnoController,
                    decoration: InputDecoration(
                      labelText: 'Enter Service No',
                      hintText: 'Without special character',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ), //SERVICE NO
          
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
                      labelText: 'Enter Phone No',
                      hintText: 'Whatsapp Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),//MOBILE

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter desired Password',
                      hintText: 'Minimum 8 characters',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),//Password
          
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: keyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter secret registration key',
                      hintText: 'Contact admin (7005759806) for key',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),//REGISTRATION KEY
          
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    if(keyController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && mobileController.text.isNotEmpty){
                      if(mobileController.text.length < 10){
                        Helper.showToast("Enter correct mobile number");
                        return null;
                      }
                      else if(passwordController.text.length<8){
                        Helper.showToast("Password criteria not matching");
                        return null;
                      }
           /*           else if(pnoregex.hasMatch(pnoController.text)){
                        Helper.showToast("Invalid Service no");
                        return null;
                      }*/
                      else if(keyController.text!=skey){
                        Helper.showToast('Invalid registration key. Please contact admin');
                      }
                      else{
                        addData();
                        clearFields();
                      }
                    }
            else {
                      Helper.showToast('All fields required');
                    }
                  },
                  child: Text("Register",style: TextStyle(color: ColorHelper.whiteColor),),
                ),
          
                SizedBox(height: 20,),
          
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Back to Login Page",style: TextStyle( color: ColorHelper.blackColor),),
                ),
              ],
            ),
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
          'password': passwordController.text.toString(),
          'pno': pnoController.text.toString(),
        });
    Helper.showToast("Registered SuccessFully");
  }

  void clearFields() {
    nameController.clear();
    mobileController.clear();
    keyController.clear();
    passwordController.clear();
    pnoController.clear();
  }


}

