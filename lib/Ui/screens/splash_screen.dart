import 'package:api_class/Ui/controllers/auth_controller.dart';
import 'package:api_class/Ui/screens/login_screen.dart';
import 'package:api_class/Ui/utils/assets_path.dart';
import 'package:api_class/Ui/widgets/main_bottom_nav_screen.dart';
import 'package:api_class/Ui/widgets/screen_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen()async{
    await Future.delayed(Duration(seconds: 2));
   // print(AuthController.email);
    final bool isLoggedIn = await AuthController.checkIfUserLoggedIn();
    Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context) => isLoggedIn ? const MainBottomNavScreen() : const LoginScreen(),)
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:ScreenBackground(child: 
          Center(child: SvgPicture.asset(AssetsPath.logoSvg, width: 120,)))
    );
  }
}