import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
import 'package:varuna_new/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { //Called only ONCE for loading of necessary setup
    // USED TO CARRY OUT code WHILST LOADING OF ANOTHER CODE
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()),
      );//LoginScreen is called after 2 seconds
    //  Note: Push replace replaces the instance, so when we press back,
      // we can no longer access main.dart or splash_screen.dart
    });
    super.initState();
  }
// calling super.initState() ensures that the Flutter framework completes its necessary
// setup for the widget, allowing your custom initialization to happen on top of that.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/trident.jpeg", height: 500,width: 400,),
          ],
        ),
      ),
    );
  }
}
