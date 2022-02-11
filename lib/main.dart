import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Authentication/authentication.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('notification'),
  enableLights: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> firebaseMessgaingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessgaingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
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
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription:channel.description,
                // icon: 'zayka_pizza_hub',
                sound:
                    const RawResourceAndroidNotificationSound('notification'),
                // other properties...
                importance: channel.importance,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Homelyy Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Scaffold(body  : widget.pref.getString('email') == null ? Authentication() : FutureBuilder(
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
