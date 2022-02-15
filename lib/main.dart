import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Authentication/authentication.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


 var pref = await SharedPreferences.getInstance();

  runApp( MyApp(pref:pref));
}

class MyApp extends StatefulWidget {

  final SharedPreferences pref ;

  const MyApp({Key key, this.pref}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Homelyy Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:

      Scaffold(

          body  : widget.pref.getString('email') == null ? Authentication() : FutureBuilder(
        future: AllApi().getVendor(email:  widget.pref.getString('email')),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: Image.asset('assets/images/homelyy.png'));
          }else{
            print('snapstos ${snapshot.requireData.country}');
            return MyHomePage(vendorDetails: snapshot.requireData,);
          }


        }
      )),
    );
  }
}
