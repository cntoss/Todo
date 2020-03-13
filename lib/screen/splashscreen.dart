import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unlimit/screen/homepage.dart';
class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () async{
        Navigator.pushNamed(context, HomePage.id);
      //Navigator.of(context).pushNamed(LoginPage.tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('image/unlimite.png'), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
