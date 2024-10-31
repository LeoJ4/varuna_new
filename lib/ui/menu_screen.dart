import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<String> _fetchImageUrl() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance.collection('messimage').doc('imageurl').get();
  return doc['url'];
}

void _showFullscreenImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),  // Close the dialog on tap
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}
List breakfast = [];
List lunch = [];
List dinner = [];
List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday','Friday', "Saturday", "Sunday"];
String selectedItem = "Monday";
String breakFastMenu = "";
String lunchMenu = "";
String dinnerMenu = "";


class _MenuScreenState extends State<MenuScreen> {
  @override

  void initState() {//to refresh every time when day is changed
    // TODO: implement initState
    super.initState();
    getItems();
    super.initState();
  }

  Future<void> getItems() async {
    //menu time wise
    var menuData = FirebaseFirestore.instance.collection('menu');

    DocumentSnapshot documentSnapshot1 = await menuData.doc("breakfast").get();
    Map<String, dynamic>? documentData1 = documentSnapshot1.data() as Map<String, dynamic>?;
    breakfast = documentData1!["menu"];

    DocumentSnapshot documentSnapshot2 = await menuData.doc("lunch").get();
    Map<String, dynamic>? documentData2 = documentSnapshot2.data() as Map<String, dynamic>?;
    lunch = documentData2!["menu"];

    DocumentSnapshot documentSnapshot3 = await menuData.doc("dinner").get();
    Map<String, dynamic>? documentData3 = documentSnapshot3.data() as Map<String, dynamic>?;
    dinner = documentData3!["menu"];

    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    String dayName = getDayName(dayOfWeek);
    fetchAndShow(dayName);

    setState(() {}); //refresh build widget method
  }

  void fetchAndShow(String newValue) {
    selectedItem = newValue;
    int index = days.indexWhere((day) => day == newValue);
    breakFastMenu = breakfast[index];
    lunchMenu = lunch[index];
    dinnerMenu = dinner[index];
  }

  String getDayName(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Unknown day';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 30,),
                SizedBox(height: 20,),
                Text('Mess Menu for: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.red),),
                DropdownButton<String>(
                  value: selectedItem,  // Current selected value
                  items: days.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(' $item ', style: TextStyle(fontSize: 20, color: Colors.red),),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue!;
                      fetchAndShow(newValue);
                    });
                  },
                ),
                SizedBox(height: 20,),
                Card(child: Text('Breakfast: $breakFastMenu',
                style: TextStyle(fontSize: 20),)),
                SizedBox(height: 20,),
                Card(child: Text('Lunch : $lunchMenu',
                  style: TextStyle(fontSize: 20),)),
                SizedBox(height: 20,),
                Card(child: Text('Dinner $dinnerMenu',
                  style: TextStyle(fontSize: 20),)),


              SizedBox(height: 40,),
            Expanded(
              child: FutureBuilder<String>(
                future: _fetchImageUrl(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading image'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No image found'));
                  }
              
                  // Image URL fetched successfully
                  String imageUrl = snapshot.data!;
              
                  return GestureDetector(
                    onTap: () => _showFullscreenImage(context, imageUrl), // Show fullscreen image on tap
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },),
            ),
              ],
            ),
          ),
        )
    );
  }
}


