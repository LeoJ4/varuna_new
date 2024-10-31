import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../common/color_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
//CRUD FOR NOTICE BOARD PICS AND VIDS
import '../common/helper.dart';


class noticeBoardCRUD extends StatefulWidget {
  const noticeBoardCRUD({super.key});

  @override
  State<noticeBoardCRUD> createState() => _noticeBoardCRUDState();
}

class _noticeBoardCRUDState extends State<noticeBoardCRUD> {

  File? imageFile; //stores image
  ImagePicker picker = ImagePicker(); // image pick isntance
  String? downloadURL;
  CollectionReference imagesCollection = FirebaseFirestore.instance.collection('noticeImage');
  CollectionReference videosCollection = FirebaseFirestore.instance.collection('noticevideo');

  Future<void> pickImageFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //XFile contains image AND image info. path
    if (image != null) {
      imageFile = File(image.path);
      uploadOnStorage(true); //function defined below
    }
  }

  Future<void> pickVideoFromGallery() async {
    XFile? image = await picker.pickVideo(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      uploadOnStorage(false); //made false so that the bol value is used to differentiate
      //true is for image & false is for video
    }
  }

  Future<void> uploadOnStorage(bool isImage) async {
    //Future: Promises a return but not immediate, eg upload of image which does not
    //happen instantly
    if (imageFile == null) return;

    // Get the file name
    String fileName = basename(imageFile!.path);

    try {
      // Create a reference to the Firebase storage location
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/$fileName');
//It acts like a "pointer" to a file or directory in your storage bucket.

      // Upload the image
      UploadTask uploadTask = ref.putFile(imageFile!);
//uploadTask is object of class putfile
      // Wait for the upload to complete
      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded image
        String downloadURL = await ref.getDownloadURL(); //method to generate unique url
        setState(() {
          if(isImage){
            imagesCollection.add({"url":downloadURL});
          }else{
            videosCollection.add({"url":downloadURL});
          }
        });
        Helper.showToast('File Uploaded Successfully');
        print("Download URL: $downloadURL");
      });
    } catch (e) {
      Helper.showToast('Error in uploading file');
      print(e);
    }
  }

  Future<void> deleteDialog(BuildContext context, String id, bool isImage){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                if(isImage){
                  imagesCollection.doc(id).delete();
                }else{
                  videosCollection.doc(id).delete();
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {//DISPLAY IMAGE CAROUSEL
    return SafeArea(
        child: Scaffold(
          backgroundColor: ColorHelper.whiteColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHelper.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: (){
                  pickImageFromGallery();
                },
                child: Text("Select Image",style: TextStyle(color: ColorHelper.whiteColor),),
              ),

              StreamBuilder<QuerySnapshot>( //streambuilder stores all info,
                stream: imagesCollection.snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // object to store data/ docs from Firestore
                  final items = snapshot.data?.docs ?? []; //? - Nullable data
                  //docs?? [] - store data&docs else Null array

                  return Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final doc = items[index];
                        final id = doc.id; //auto generated ID in firebase
                        final url = doc['url']; //value is name of key

                        return Container(
                          height: 200,
                          width: 200,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: ColorHelper.blackColor,width: 2)
                          ),
                          child: Stack(
                            children: [
                              Image.network(url,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                      onTap: (){
                                        deleteDialog(context,id,true);
                                      },
                                      child: Icon(Icons.delete)))
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              Divider(height: 2,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHelper.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: (){
                  pickVideoFromGallery();
                },
                child: Text("Select Video",style: TextStyle(color: ColorHelper.whiteColor),),
              ),

              StreamBuilder<QuerySnapshot>( //streambuilder stores all info,
                stream: videosCollection.snapshots(),
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

                  return Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final doc = items[index];
                        final id = doc.id; //auto generated ID in firebase
                        final url = doc['url']; //value is name of key

                        return Container(
                          height: 200,
                          width: 200,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: ColorHelper.blackColor,width: 2)
                          ),
                          child: Stack(
                            children: [
                              VideoPlayerItem(videoPath: url),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                      onTap: (){
                                        deleteDialog(context,id,false);
                                      },
                                      child: Icon(Icons.delete)))
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              )

            ],
          ),
        )
    );
  }
}


class VideoPlayerItem extends StatefulWidget {
  final String videoPath;

  const VideoPlayerItem({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with the asset video
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));

    // Initialize the video player future
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {//called when a stateful widget is being removed to release resources

    _controller.dispose(); //stops all animations/ resources with controller
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                // Play/Pause button
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: ColorHelper.blackColor,
                    size: 50,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading video: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
