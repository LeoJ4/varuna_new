import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/color_helper.dart';
import '../model/varidhi_model.dart';
//FAQ SCREEN
class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

List<Info> infoList = []; //list for storing list

TextEditingController searchController = TextEditingController();
List<Info> filteredItems = []; //list for storing filtered list
CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('info');

class _InfoScreenState extends State<InfoScreen> {

  @override
  void initState() {
    getItems(); // Gets data from database
    super.initState(); //pre-defined
  }


  Future<void> getItems() async {
    QuerySnapshot querySnapshot = await _itemsCollection.get();
    //querySnapshot stores all data of firebase  collection info

    infoList.clear();
    filteredItems.clear();

    querySnapshot.docs.forEach((item) {
      infoList.add(Info(a: item["Timing"], b: item["value"]));
    });
   //adds all values from firebase table to infoList
    filteredItems = List.from(infoList);
    setState(() {}); //refresh build widget method
  }


  void filterItems(String txt) {
    setState(() {
      filteredItems = infoList
          .where((item) => item.b.toLowerCase().contains(txt)) //b is second index
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
              controller: searchController, //stores input of search bar
              onChanged: (value){
                filterItems(value.toLowerCase());
              },
              decoration: InputDecoration(
 /*               labelText: 'Search here',*/
                hintText: 'Search here',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder( //Looping the list times the itemCount
              itemCount: filteredItems.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorHelper.blackColor, width: 2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredItems[index].a), // Display field 'a' from
                      Text(filteredItems[index].b), // Display field 'b'
                    ],
                  ), //index starts from beginning of table in firebase
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
