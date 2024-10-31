import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
import 'package:varuna_new/ui/login_screen.dart';
import 'package:varuna_new/ui/noticeBoardCRUD.dart';
import 'package:varuna_new/ui/varidhi_crud_screen.dart';

import 'add_menu_screen.dart';
import 'info_crud_screen.dart';
import 'menu_crud_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  @override
  void initState() {
    storagePermission();
    super.initState();
  }

  void storagePermission()async{// for mobile permissions access
    bool permissionStatus;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus = await Permission.photos.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }
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
                child: Card(elevation: 5,
                    child: Text("Varidhi Media CRUD",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),))),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VaridhiCrudScreen()));
                },
                child: Card(elevation: 5,
                    child: Text("Military Institutes CRUD",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),))),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InfoCrudScreen()));
                },
                child: Card(elevation: 5,
                    child: Text("FAQ CRUD",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),))),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuCrudScreen()));
                },
                child: Card(elevation: 5,
                    child: Text("Mess Menu CRUD",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),))),
            SizedBox(height: 40,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => noticeBoardCRUD()));
                },
                child: Card(elevation: 5,
                    child: Text("Notice Board CRUD",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'lobster'),))),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
