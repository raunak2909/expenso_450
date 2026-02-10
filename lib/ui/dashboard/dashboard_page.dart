import 'package:expenso_450/domain/constants/app_routes.dart';
import 'package:expenso_450/ui/add_expense/add_expense_page.dart';
import 'package:expenso_450/ui/dashboard/nav_pages/home_page.dart';
import 'package:expenso_450/ui/dashboard/nav_pages/stats_page.dart';
import 'package:flutter/material.dart';

import 'nav_pages/my_profile_page.dart';
import 'nav_pages/notification_page.dart';

class DashBoardPage extends StatefulWidget {

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int mSelectedIndex = 0;

  List<Widget> mNavPages = [
    HomePage(),
    StatsPage(),
    AddExpensePage(),
    NotificationPage(),
    MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mNavPages[mSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: mSelectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          mSelectedIndex = index;
          setState(() {

          });
        },
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            activeIcon: IconButton(onPressed: () {
            }, icon: Icon(Icons.home, color: Color(0xffE78BBC),)),
            label: "Home",
            icon: Icon(Icons.home_outlined, color: Colors.grey,),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.bar_chart, color: Color(0xffE78BBC),),
            label: "Stats",
            icon: Icon(Icons.bar_chart_outlined, color: Colors.grey,),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: InkWell(
              onTap: (){
                Navigator.pushNamed(context, AppRoutes.add_expense);
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Color(0xffE78BBC),
                  borderRadius: BorderRadius.circular(11)
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.white,),
                ),
              ),
            )
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.notifications, color: Color(0xffE78BBC),),
            label: "Home",
            icon: Icon(Icons.notifications_none_outlined, color: Colors.grey,),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person, color: Color(0xffE78BBC),),
            label: "Home",
            icon: Icon(Icons.person_outline, color: Colors.grey,),
          ),
        ],
      ),
    );
  }
}
