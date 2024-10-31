import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../common/color_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

final ScrollController imageScrollController = ScrollController();
final ScrollController videoScrollController = ScrollController();

CollectionReference imagesCollection = FirebaseFirestore.instance.collection('images');
CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');
List<String> imageList = [];
List<String> videoList = [];
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
  void initState() {
    getItems();
    super.initState();
  }

  Future<void> getItems() async {
    QuerySnapshot imageSnapshot = await imagesCollection.get();
    QuerySnapshot videoSnapshot = await videosCollection.get();
    imageSnapshot.docs.forEach((item) {
      imageList.add(item['url']); //
    });

    videoSnapshot.docs.forEach((item) {
      videoList.add(item['url']);
    });

    //menu time wise
    var menuData = FirebaseFirestore.instance.collection('menu');

    DocumentSnapshot documentSnapshot1 = await menuData.doc("breakfast").get();
    Map<String, dynamic>? documentData1 = documentSnapshot1.data() as Map<String, dynamic>?;
    breakfast = documentData1!["items"];

    DocumentSnapshot documentSnapshot2 = await menuData.doc("lunch").get();
    Map<String, dynamic>? documentData2 = documentSnapshot2.data() as Map<String, dynamic>?;
    lunch = documentData2!["items"];

    DocumentSnapshot documentSnapshot3 = await menuData.doc("dinner").get();
    Map<String, dynamic>? documentData3 = documentSnapshot3.data() as Map<String, dynamic>?;
    dinner = documentData3!["items"];



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
          body: Column(
            children: [
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
                          child: Image.network(imageList[index]),
                          //Retrieves image from Image table from firebase with url as index
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
                              jumpToIndex(0);
                            },
                              child: Icon(Icons.arrow_left,color: ColorHelper.blackColor,size: 50,)),
                          InkWell(
                            onTap: (){
                              jumpToIndex(imageList.length);
                            },
                              child: Icon(Icons.arrow_right,color: ColorHelper.blackColor, size: 50,)),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: 200,
                child: ListView.builder(
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
                      child: VideoPlayerItem(videoPath: videoList[index]),
                    );
                  },
                ),
              ),
              Text('Today Menu. Select for other days', style: TextStyle(backgroundColor: Colors.lightBlueAccent, ),),
              DropdownButton<String>(
                value: selectedItem,  // Current selected value
                hint: Text('Select Day'),  // Placeholder before selection
                items: days.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue!;
                    fetchAndShow(newValue);
                  });
                },
              ),
              Card(child: Text('Breakfast: $breakFastMenu')),
              Card(child: Text('Lunch : $lunchMenu')),
              Card(child: Text('Dinner $dinnerMenu')),
            ],
          ),
        )
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
