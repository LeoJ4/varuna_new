import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
import 'package:varuna_new/ui/varidhi_screen.dart';

import 'admin_login_screen.dart';
import 'info_screen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MenuScreen(),
    VaridhiScreen(),
    InfoScreen(),
    AdminLoginScreen(),
  ];

//CODE FOR TAB and ICONS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHelper.blackColor,
        centerTitle: true,
        title: Image.asset(
          'assets/images/banner.png', // CUSTOM IMAGE AS banner
          height: 40,
          width: 200,
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: ColorHelper.whiteColor,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar( //widget for bottom navigation
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/trident.jpg",height: 35,width: 35,),
            //CUSTOM IMAGE AS ICON
            label: 'MENU',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'VARIDHI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'INFO/ FAQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'ADMIN',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}