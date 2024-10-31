import 'package:flutter/material.dart';

import '../common/color_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/varidhi_model.dart';

class VaridhiScreen extends StatefulWidget {
  const VaridhiScreen({super.key});

  @override
  State<VaridhiScreen> createState() => _VaridhiScreenState();
}

List<VaridhiModel> infoList = [];
List<VaridhiModel> filteredItems = [];
TextEditingController searchController = TextEditingController();
CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('varidhi');

//Whatsapp API, LaunchURL added in pubsec.yaml
void openWhatsApp(BuildContext context, String mobile) async {
  var whatsappUrl = "https://wa.me/$mobile";  // WhatsApp URL with phone number
  if (!await launchUrl(Uri.parse(whatsappUrl))) {
    throw Exception('Could not launch');
  }
}

void makePhoneCall(String mobile) async {
  final Uri phoneUri = Uri(
    scheme: 'tel', //fixed keyword 'tel' for Telephone
    path: mobile,
  );

  if (!await launchUrl(phoneUri)) {
    throw Exception('Could not launch');
  }
}


Future<void> sendEmail(String emailTxt) async {
  final Uri emailUri = Uri(
    scheme: 'mailto', //shceme mailto for emails
    path: emailTxt,
  );


  if (!await launchUrl(emailUri)) {
    throw Exception('Could not launch');
  }
}

class _VaridhiScreenState extends State<VaridhiScreen> {

  @override
  void initState() {
    getItems();
    super.initState();
  }


  Future<void> getItems() async {
    QuerySnapshot querySnapshot = await _itemsCollection.get();
//stores all table data from firebase database
    infoList.clear();
    filteredItems.clear();

    querySnapshot.docs.forEach((item) {
      infoList.add(VaridhiModel(item["name"], item["mobile"], item["email"], item["timing"]));
    }); //stores all table data from snapshot to VaridhiModel class

    filteredItems = infoList;
    setState(() {}); //refresh build widget method
  }

  void filterItems(String txt) {
    setState(() {
      filteredItems = infoList
          .where((item) => item.name.toLowerCase().contains(txt))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorHelper.whiteColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: (value){
                filterItems(value.toLowerCase()); //Search method called here on change
                // with search controller as parameter
              },
              decoration: InputDecoration(
                hintText: 'Search here',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder( //Loooping of list
              itemCount: filteredItems.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorHelper.blackColor, width: 2)),
                  child: Column(
                    children: [ //name and time retrieved from table from firebase
                      //here index is the name of field
                      Text(filteredItems[index].name,style: TextStyle(fontSize: 20),),
                      Text(filteredItems[index].timing,style: TextStyle(fontSize: 20),),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              openWhatsApp(context, filteredItems[index].mobile);
                            },
                              child: Text("Msg Whatsapp")),
                          InkWell(
                              onTap: (){
                                makePhoneCall(filteredItems[index].mobile);
                              },
                              child: Text("Place Call")),
                          InkWell(
                              onTap: (){
                                sendEmail(filteredItems[index].email);
                              },
                              child: Text("E-mail")),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
