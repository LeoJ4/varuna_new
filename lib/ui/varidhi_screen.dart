import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../common/color_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

//ACTUALLY VARIDHI SCREEN
class VaridhiScreen extends StatefulWidget {
  const VaridhiScreen({super.key});

  @override
  State<VaridhiScreen> createState() => _VaridhiScreenState();
}


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

final ScrollController imageScrollController = ScrollController();
final ScrollController videoScrollController = ScrollController();

CollectionReference imagesCollection = FirebaseFirestore.instance.collection('images');
CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');
List<String> imageList = [];
List<String> videoList = [];

class _VaridhiScreenState extends State<VaridhiScreen> {

  @override
  void initState() {
    getItems();
    super.initState();
  }

  Future<void> getItems() async {
    imageList.clear();
    videoList.clear();

    QuerySnapshot imageSnapshot = await imagesCollection.get();
    QuerySnapshot videoSnapshot = await videosCollection.get();
    imageSnapshot.docs.forEach((item) {
      imageList.add(item['url']); //
    });

    videoSnapshot.docs.forEach((item) {
      videoList.add(item['url']);
    });
    setState(() {}); //refresh build widget method
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text('Varidhi', style: TextStyle(fontFamily: 'lobster', fontSize: 40, color: Colors.redAccent,),),
                SizedBox(height: 20,),
               Container(
              padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue)),
                  child: Column(
                    children: [
            Text('Order Timings: 1900 - 2130:', style: TextStyle(fontSize: 20),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){
                      openWhatsApp(context,'+917005759806');
                    },
                    child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Whatsapp Order"),
                        ))),
                InkWell(
                    onTap: (){
                      makePhoneCall('+917005759806');
                    },
                    child: Card(
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Call Varidhi"),
                        ))),
              ],
            )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text('Restaurant Menu', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.redAccent,),),
                SizedBox(height: 10,),
                Container(
                  height: 200,
                  child: Stack( //Overlapping containers to accommodate arrows
                    children: [
                      ListView.builder(
                        controller: imageScrollController,
                        itemCount: imageList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 200,
                            width: 250,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: ColorHelper.blackColor,width: 2)
                            ),
                            child: InkWell(
                              onTap: (){
                                _showFullscreenImage(context,imageList[index]);
                              },
                                child: Image.network(imageList[index])),
                            //Retrieves image from Image table from firebase with url as index
                          );
                        },
                      ),
                      SizedBox(height: 10,),
            
                      Container(
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: (){
                                  jumpToIndex(0);
                                },
                                child: Icon(Icons.arrow_left,color: Colors.lightBlue,size: 50,)),
                            InkWell(
                                onTap: (){
                                  jumpToIndex(imageList.length);
                                },
                                child: Icon(Icons.arrow_right,color: Colors.lightBlue, size: 50,)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text('Varidhi Facilities', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.redAccent,),),
                SizedBox(height: 10,),
                Container(
                  height: 200,
                  child: Stack(
                      children: [ListView.builder(
                        controller: videoScrollController,
                        itemCount: videoList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 200,
                            width: 250,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: ColorHelper.blackColor,width: 2)
                            ),
                            child: InkWell(
                              onTap: () {
                                _showFullscreenVideo(context,videoList[index]);
                              },
                                child: VideoPlayerItem(videoPath: videoList[index])),
                          );
                        },
                      ),
                        Container(
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: (){
                                    jumpToIndexVideo(0);
                                  },
                                  child: Icon(Icons.arrow_left,color: Colors.lightBlue,size: 50,)),
                              InkWell(
                                  onTap: (){
                                    jumpToIndexVideo(imageList.length);
                                  },
                                  child: Icon(Icons.arrow_right,color: Colors.lightBlue, size: 50,)),
                            ],
                          ),
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
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

  void _showFullscreenVideo(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),  // Close the dialog on tap
          child: InteractiveViewer(
            child:  VideoPlayerItem(videoPath: videoUrl),
          ),
        ),
      ),
    );
  }

  void jumpToIndex(int index) {
    double position = index * 250; //250 width of item multiplied by image.length
    imageScrollController.animateTo(
      position,
      duration: Duration(seconds: 1),
      curve: Curves.easeInCirc,
    );
  }
}


void jumpToIndexVideo(int index) {
  double position = index * 250; //250 width of item multiplied by image.length
  videoScrollController.animateTo(
    position,
    duration: Duration(seconds: 1),
    curve: Curves.easeInCirc,
  );
}

class VideoPlayerItem extends StatefulWidget {
  final String videoPath;

  const VideoPlayerItem({ required this.videoPath});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  //Future:
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
  void dispose() {
    _controller.dispose();
    super.dispose();
    //dispose : Close the state of a file when it is not used
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
      child: FutureBuilder(//code carried out while video is loading
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
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