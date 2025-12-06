import 'package:flutter/material.dart';
import 'package:goonmarket/helpers/user_info.dart'; 
import 'package:goonmarket/ui/login_page.dart';
import 'package:goonmarket/ui/inventaris_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> { 
  Widget page = const CircularProgressIndicator(); 

  @override 
  void initState() { 
    super.initState(); 
    isLogin(); 
  } 

  void isLogin() async { 
    var token = await UserInfo().getToken(); 
    if (token != null) { 
      setState(() { 
        page = const InventarisPage(); 
      }); 
    } else { 
      setState(() { 
        page = const LoginPage(); 
      }); 
    } 
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoonMarket',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: page,
    );
  }
}