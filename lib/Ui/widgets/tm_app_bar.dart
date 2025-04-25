
import 'dart:convert';

import 'package:api_class/ui/controllers/auth_controller.dart';
import 'package:api_class/ui/screens/login_screen.dart';
import 'package:api_class/ui/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({super.key, this.fromProfileSection, this.onUpdate});

  final bool? fromProfileSection;
  final VoidCallback? onUpdate;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme= Theme.of(context).textTheme;
    return  AppBar(
        backgroundColor: Colors.green,
        title: GestureDetector(
          onTap: (){
            if(fromProfileSection ?? false){
              return;
            }
            _onTapProfileSection(context);
          },
          child: Row(
            children: [
               CircleAvatar(
                radius: 16,
                backgroundImage:_shouldShowImage(AuthController.userModel?.photo) ? MemoryImage(base64Decode(AuthController.userModel?.photo ?? '')): null,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AuthController.userModel?.fullName ?? 'Unknown',
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      AuthController.userModel?.email ?? 'Unknown',
                      style: textTheme.bodySmall?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              IconButton(onPressed:()=> _onTapProfileLogedOutButton(context), icon: Icon(Icons.logout))
            ],
          ),
        ),
      );
  }

  bool _shouldShowImage(String? photo){
    return photo != null && photo.isNotEmpty;
  }
  void _onTapProfileSection(BuildContext context)async{
    await AuthController.getUserInformation();
   if (onUpdate != null) {
    onUpdate!();
  } else {
    debugPrint("No onUpdate callback provided.");
  }
    Navigator.push(context, MaterialPageRoute(
      builder: (context)=>  UpdateProfileScreen(),),);
  }
  Future<void> _onTapProfileLogedOutButton(BuildContext context)async{
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context)=>  const LoginScreen(),),
      (predicate)=> false);
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
