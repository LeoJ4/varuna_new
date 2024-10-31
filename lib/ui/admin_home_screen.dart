import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
import 'package:varuna_new/ui/login_screen.dart';
import 'package:varuna_new/ui/varidhi_crud_screen.dart';

import 'add_menu_screen.dart';
import 'info_crud_screen.dart';
import 'menu_crud_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMenuScreen()));
                },
                child: Text("Canteen Items",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),)),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VaridhiCrudScreen()));
                },
                child: Text("Varidhi CRUD",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),)),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InfoCrudScreen()));
                },
                child: Text("general Info",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),)),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuCrudScreen()));
                },
                child: Text("Mess Menu",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),)),
          ],
        ),
      ),
    );
  }
}
