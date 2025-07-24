import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/viewmodels/login_viewmodel.dart';
import 'ui/views/login_screen.dart';
import 'ui/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = null; //prefs.getString('token');

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // Add other view models here as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reservation App',
        home: isLoggedIn ? HomeScreen() : LoginScreen(),
      ),
    );
  }
}