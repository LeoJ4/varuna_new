import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//FAQ CRUD
class InfoCrudScreen extends StatefulWidget {
  @override
  _InfoCrudScreenState createState() => _InfoCrudScreenState();
}

class _InfoCrudScreenState extends State<InfoCrudScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('info');
  //database and table pointer

  // Add a new string to Firestore
  Future<void> _addItem(String Timing, String value) async {
    await itemsCollection.add({'Timing':Timing, 'value': value});
  }

  // Edit an existing string in Firestore
  Future<void> _editItem(String id, String newTiming, String newValue) async {
    await itemsCollection.doc(id).update({'Timing':newTiming, 'value': newValue});
  }

  // Delete an item from Firestore
  Future<void> _deleteItem(String id) async {
    await itemsCollection.doc(id).delete();
  }

  // Show dialog to add or edit items
  Future<void> _showInputDialog({String? id, String? initialValue}) async {
    _textController.text = initialValue ?? ''; // ?? - non-coalescing -left value assigned if not null
    //else if null right value assigned
    bool isEditing = id != null;
    //if id not equal null then store true in Bool variable, else store false

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Item' : 'Add Item'),
          content: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(hintText: 'Enter Question'),
              ),
              TextField(
                controller: _textController2,
                decoration: InputDecoration(hintText: 'Enter Answer'),
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
                  _editItem(id, _textController.text, _textController2.text);
                } else {
                  _addItem(_textController.text, _textController2.text);
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
        title: Text('FAQ CRUD'),
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
              final ans = doc['value']; //value is name of key
              final ques = doc['Timing'];

              return ListTile(
                subtitle: Text(ques),
                title: Text(ans),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showInputDialog(id: id, initialValue: ans),
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
