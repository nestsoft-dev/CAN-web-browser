// import 'dart:html';
// import 'dart:io';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';




Future<void> _firebaseMessagingBackgroundHandler(message) async{
  await Firebase.initializeApp();

}



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAN ',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  AnimatedSplashScreen(splash: Center(
      child: Column(
        children: [
          Container(
            height: 200,
              width: 200,
              child: Image.asset('assets/can.png',fit: BoxFit.cover,)),
          SizedBox(height: 10,),
          Text('C A N',style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),)
        ],
      ),
    ),
      duration: 4000,
      splashIconSize: 250,
      animationDuration: Duration(seconds: 1),
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      nextScreen: HOME(),
      backgroundColor: Colors.blue,
      
    );
  }
}


class HOME extends StatefulWidget {
  const HOME({Key? key}) : super(key: key);

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message){
      print("Message is $message");
    });
    // Enable virtual display.
    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(await controller.canGoBack()){
          controller.goBack();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        body: WebView(
          initialUrl: "https://www.careeradvisorynetwork.ca",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller){
            this.controller = controller;
          },
        ),

      ),
    );
  }
}
