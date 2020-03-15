import 'package:flutter/material.dart';
import 'screen/splashscreen.dart';
import 'screen/homepage.dart';
import 'screen/contact.dart';
import 'screen/call.dart';
import 'screen/dashboard.dart';
import 'custom_provider/app_state.dart';
import 'package:provider/provider.dart';
void main() async {
  runApp(new UnLimited());
}

class UnLimited extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'sans serif',
          primarySwatch: Colors.teal,
        ),
        home: ChangeNotifierProvider<AppState>(
            create: (_) {
              return AppState();
            },
            child: SplashScreen()),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomePage.id: (context) => HomePage(),
          DashBoard.id: (context) => DashBoard(),
          ContactList.id: (context) => ContactList(),
          CallList.id: (context) => CallList(),
         });
  }
}
