import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
//actually GUEST HOUSE SCREEN
class VaridhiCrudScreen extends StatefulWidget {
  @override
  _VaridhiCrudScreenState createState() => _VaridhiCrudScreenState();
}

class _VaridhiCrudScreenState extends State<VaridhiCrudScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('varidhi');
  //database and table pointer

  // Add a new string to Firestore
  Future<void> _addItem(String name,String mobile,String email,String timing) async {
    await itemsCollection.add(
        {
          'name': name,
          'mobile': mobile,
          'email': email,
          'timing': timing,
        }
    );
  }

  // Edit method for edit in Firestore database
  Future<void> _editItem(String id, String name,String mobile,String email,String timing) async {
    await itemsCollection.doc(id).update(
        {
          'name': name,
          'mobile': mobile,
          'email': email,
          'timing': timing,
        }
    );
  }

  // Delete an item from Firestore
  Future<void> _deleteItem(String id) async {
    await itemsCollection.doc(id).delete();
  }

  // Show dialog to add or edit items
  Future<void> _showInputDialog({String? id, String? initialValue,String? phone,String? email,String? timing}) async {
    nameController.text = initialValue ?? ''; // ?? - non-coalescing -left value assigned if not null
    mobileController.text = phone ?? "";
    emailController.text = email ?? "";
    timeController.text = timing ?? "";
    //else if null right value assigned
    bool isEditing = id != null;
    //if id passed then store true in Bool variable, else store null

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Item' : 'Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter name'),
              ),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter phone number'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Enter email id'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(hintText: 'Enter time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isEditing) {
                  _editItem(id, nameController.text,mobileController.text,emailController.text,timeController.text);
                } else {
                  _addItem(nameController.text,mobileController.text,emailController.text,timeController.text);
                }
                Navigator.of(context).pop();


              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD'),
      ),
      body: StreamBuilder<QuerySnapshot>( //streambuilder stores all info,
      //query snapshot is part of firebase
        stream: itemsCollection.snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Get the list of documents from Firestore
          final items = snapshot.data?.docs ?? []; //? - Nullable data
          //?? [] - else Nullable array storage

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final doc = items[index];
              final id = doc.id; //auto generated ID in firebase
              final value = doc['name']; //value is name of key
              final mobile = doc['mobile']; //value is name of key
              final email = doc['email']; //value is name of key
              final timing = doc['timing']; //value is name of key

              return ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorHelper.blackColor,width: 1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value),
                      Text(mobile),
                      Text(email),
                      Text(timing),
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showInputDialog(id: id, initialValue: value,phone: mobile,email: email,timing: timing ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(), // Open dialog to add new item
        child: Icon(Icons.add),
      ),
    );
  }
}
