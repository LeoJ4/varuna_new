import 'package:flutter/material.dart';
import 'package:varuna_new/common/color_helper.dart';
import 'package:varuna_new/ui/guesthouse_screen.dart';
import 'package:varuna_new/ui/picinfo_screen.dart';
import 'package:varuna_new/ui/varidhi_screen.dart';
import 'admin_login_screen.dart';
import 'info_screen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
final String? pno, name;
HomeScreen({required this.pno, required this.name});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MenuScreen(), // mess menu
    VaridhiScreen(), //Varidhi
    picInfo(),
    Guesthouse_Screen(), //miscellaneous page
    InfoScreen(), //INFO/FAQ
  ];

//CODE FOR TAB and ICONS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: Text('Varuna', style: TextStyle(
                fontFamily: 'lobster', fontSize: 40, color: Colors.black),)
          /*Image.asset(
            'assets/images/banner.png', // CUSTOM IMAGE AS banner
            height: 40,
            width: 200,
            fit: BoxFit.cover,
          ),*/
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
            icon: Image.asset(
              "assets/images/varuna-icon.jpg", height: 35, width: 35,),
            //CUSTOM IMAGE AS ICON
            label: 'Mess Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Varidhi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_work),
              label: 'Guest Houses'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'FAQ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
