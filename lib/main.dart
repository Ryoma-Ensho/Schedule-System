import 'package:flutter/material.dart';
import 'package:yotei/sys_variable.dart';
import 'package:yotei/sys_method.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

void main() async {
  runApp(const MyApp());
  FlutterLocalNotificationsPlugin()
    ..resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission()
    ..initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 210, 208, 209),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSlide(),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 209, 181, 248),
        selectedFontSize: 17,
        unselectedFontSize: 17,
        currentIndex: slide,
        onTap: (value) {
          //ここで画面遷移を行う。
          setState(() {
            slide = value;
          });
        },
        //項目
        items: [
          BottomNavigationBarItem(
            label: '授業',
            tooltip: "授業のスケジュール",
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance),
          ),
          BottomNavigationBarItem(
            label: 'その他',
            icon: Icon(Icons.view_list_outlined),
            activeIcon: Icon(Icons.view_list),
          ),
        ],
      ),
    );
  }
}
