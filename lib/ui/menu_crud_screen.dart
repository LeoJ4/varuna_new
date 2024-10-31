import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
import 'package:varuna_new/common/helper.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MenuCrudScreen extends StatefulWidget {
  @override
  _MenuCrudScreenState createState() => _MenuCrudScreenState();
}

class _MenuCrudScreenState extends State<MenuCrudScreen> {
  final TextEditingController monController = TextEditingController();
  final TextEditingController tueController = TextEditingController();
  final TextEditingController wedController = TextEditingController();
  final TextEditingController thuController = TextEditingController();
  final TextEditingController friController = TextEditingController();
  final TextEditingController satController = TextEditingController();
  final TextEditingController sunController = TextEditingController();

  final TextEditingController monController1 = TextEditingController();
  final TextEditingController tueController1 = TextEditingController();
  final TextEditingController wedController1 = TextEditingController();
  final TextEditingController thuController1 = TextEditingController();
  final TextEditingController friController1 = TextEditingController();
  final TextEditingController satController1 = TextEditingController();
  final TextEditingController sunController1 = TextEditingController();

  final TextEditingController monController2 = TextEditingController();
  final TextEditingController tueController2 = TextEditingController();
  final TextEditingController wedController2 = TextEditingController();
  final TextEditingController thuController2 = TextEditingController();
  final TextEditingController friController2 = TextEditingController();
  final TextEditingController satController2 = TextEditingController();
  final TextEditingController sunController2 = TextEditingController();

  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('menu');

  Future<void> pickAndUploadExcelFile() async {
    try {
      // Pick an Excel file using file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        // Read the file
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        // Extract data for each column and prepare Firestore documents
        Map<String, List<String>> columnData = {
          'breakfast': [],
          'lunch': [],
          'dinner': [],
        };

        // Skip the header row by starting the loop at index 1
        var rows = excel.tables[excel.tables.keys.first]!.rows;
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          columnData['breakfast']!.add(row[0]?.value.toString() ?? '');
          columnData['lunch']!.add(row[1]?.value.toString() ?? '');
          columnData['dinner']!.add(row[2]?.value.toString() ?? '');
        }

        // Upload data to Firestore collection 'menu'
        await uploadToFirestore(columnData);
      }
    } catch (e) {
      print("Error reading or uploading Excel file: $e");
    }
  }
  //database and table pointer

  void getData() async{

    var menuData = FirebaseFirestore.instance.collection('menu');

    DocumentSnapshot documentSnapshot = await menuData.doc("breakfast").get();
    Map<String, dynamic>? documentData = documentSnapshot.data() as Map<String, dynamic>?;
    List breakfast = documentData!["items"];

    monController.text = breakfast[0];
    tueController.text = breakfast[1];
    wedController.text = breakfast[2];
    thuController.text = breakfast[3];
    friController.text = breakfast[4];
    satController.text = breakfast[5];
    sunController.text = breakfast[6];

    DocumentSnapshot documentSnapshot1 = await menuData.doc("lunch").get();
    Map<String, dynamic>? documentData1 = documentSnapshot1.data() as Map<String, dynamic>?;
    List lunch = documentData1!["items"];

    monController1.text = lunch[0];
    tueController1.text = lunch[1];
    wedController1.text = lunch[2];
    thuController1.text = lunch[3];
    friController1.text = lunch[4];
    satController1.text = lunch[5];
    sunController1.text = lunch[6];

    DocumentSnapshot documentSnapshot2 = await menuData.doc("dinner").get();
    Map<String, dynamic>? documentData2 = documentSnapshot2.data() as Map<String, dynamic>?;
    List dinner = documentData2!["items"];

    monController2.text = dinner[0];
    tueController2.text = dinner[1];
    wedController2.text = dinner[2];
    thuController2.text = dinner[3];
    friController2.text = dinner[4];
    satController2.text = dinner[5];
    sunController2.text = dinner[6];


    setState(() {});
  }

 @override
  void initState() {
    // TODO: implement initState

   getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorHelper.whiteColor,
        appBar: AppBar(
          title: Text('Menu CRUD'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(onPressed: pickAndUploadExcelFile,
            child: Text("Upload Excel File"),),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text("Monday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(monController,monController1,monController2),
                ],
              ),
              Row(
                children: [
                  Text("Tuesday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(tueController,tueController1,tueController2),
                ],
              ),
              Row(
                children: [
                  Text("Wednesday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(wedController,wedController1,wedController2),

                ],
              ),
              Row(
                children: [
                  Text("Thursday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(thuController,thuController1,thuController2),

                ],
              ),
              Row(
                children: [
                  Text("Friday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(friController,friController1,friController2),

                ],
              ),
              Row(
                children: [
                  Text("Saturday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(satController,satController1,satController2),
                ],
              ),
              Row(
                children: [
                  Text("Sunday :",style: TextStyle(color: ColorHelper.blackColor),),
                  SizedBox(width: 10,),
                  commonTextField(sunController,sunController1,sunController2),
                ],
              ),
              SizedBox(height: 30,),
              ElevatedButton(//CODE FOR ADD/ UPDATE OF MENU
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHelper.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: (){
                  if(monController.text.isNotEmpty && tueController.text.isNotEmpty && wedController.text.isNotEmpty && thuController.text.isNotEmpty && friController.text.isNotEmpty && satController.text.isNotEmpty && sunController.text.isNotEmpty
                  && monController1.text.isNotEmpty && tueController1.text.isNotEmpty && wedController1.text.isNotEmpty && thuController1.text.isNotEmpty && friController1.text.isNotEmpty && satController1.text.isNotEmpty && sunController1.text.isNotEmpty
                  && monController2.text.isNotEmpty && tueController2.text.isNotEmpty && wedController2.text.isNotEmpty && thuController2.text.isNotEmpty && friController2.text.isNotEmpty && satController2.text.isNotEmpty && sunController2.text.isNotEmpty){

                    itemsCollection.doc("breakfast").set({
                      "menu" :[
                        monController.text,
                        tueController.text,
                        wedController.text,
                        thuController.text,
                        friController.text,
                        satController.text,
                        sunController.text
                      ]
                    });

                    itemsCollection.doc("lunch").set({
                      "menu" :[
                        monController1.text,
                        tueController1.text,
                        wedController1.text,
                        thuController1.text,
                        friController1.text,
                        satController1.text,
                        sunController1.text
                      ]
                    });

                    itemsCollection.doc("dinner").set({
                      "menu" :[
                        monController2.text,
                        tueController2.text,
                        wedController2.text,
                        thuController2.text,
                        friController2.text,
                        satController2.text,
                        sunController2.text
                      ]
                    });

                  }else{
                    Helper.showToast("Please Fill All Field");
                  }
                },
                child: Text("Submit Menu",style: TextStyle(color: ColorHelper.whiteColor),),
              ),
              SizedBox(height: 30,),
            ],
          ),

        ),
      ),
    );
  }

  Widget commonTextField(TextEditingController controller1,TextEditingController controller2,TextEditingController controller3){
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              controller: controller1,
              decoration: InputDecoration(hintText: '',border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              controller: controller2,
              decoration: InputDecoration(hintText: '',border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              controller: controller3,
              decoration: InputDecoration(hintText: '',border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadToFirestore(Map<String, List<String>> data) async {
    CollectionReference menuCollection = FirebaseFirestore.instance.collection('menu');

    try {
      for (var entry in data.entries) {
        await menuCollection.doc(entry.key).set({
          'items': entry.value,
        });
      }
      print("Data uploaded successfully!");
    } catch (e) {
      print("Error uploading to Firestore: $e");
    }
  }


}
