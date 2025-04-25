import 'package:api_class/ui/screens/cancled_task_screen.dart';
import 'package:api_class/ui/screens/completed_task_screen.dart';
import 'package:api_class/ui/screens/new_task_screen.dart';
import 'package:api_class/ui/screens/progess_task_screen.dart';
import 'package:api_class/ui/widgets/tm_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screen =const [
   NewTaskScreen(),
   ProgessTaskScreen(),
   CompletedTaskScreen(),
   CanceledTaskScreen(),
  ];
  @override
 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: TmAppBar(
        onUpdate: (){
          setState(() {
            
          });
          Logger().w('Got the update from main bottom');
          
        },
        
      ),
      
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex, //current sele
        onDestinationSelected: (index){
          _selectedIndex = index;
          setState(() {
            
          });
        },
        destinations: const [
        NavigationDestination(icon: Icon(Icons.new_label),label: 'New',),
        NavigationDestination(icon: Icon(Icons.ac_unit_sharp),label: 'Progess',),
        NavigationDestination(icon: Icon(Icons.done),label: 'Completed',),
        NavigationDestination(icon: Icon(Icons.cancel),label: 'Canceled',)

      ]),
    );
}
}