import 'package:api_class/ui/controllers/new_task_controller.dart';
import 'package:api_class/ui/screens/add_new_task_screen.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/summary_card.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {



  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  
  @override
  void initState() {
    
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<NewTaskController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.getStatusCountInProgress ==false,
                  replacement: const Padding(
                    padding: EdgeInsets.all(16),
                    child: CenteredCirculerProgressIndicator(),
                  ),
                  child: _buildSummaryCard());
              }
            ),
            GetBuilder<NewTaskController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.getNewTaskInProgress == false,
                  replacement: const SizedBox(
                    height: 300,
                    child: CenteredCirculerProgressIndicator()),
                  child: ListView.separated(
                    itemCount: controller.newTaskList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return   TaskCard(
                      taskStatus: TaskStatus.sNew, 
                      taskModel: controller.newTaskList[index],
                      refreshList: _getAllNewTaskList,
                      );
                  
                  }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
                );
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onTapAddNewTask,
      child: const Icon(Icons.add),),
    );
  }
  void _onTapAddNewTask(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNewTaskScreen(),),);
  }
  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _newTaskController.taskStatusCountList.length,
          itemBuilder: (context, index){
            return  SummaryCard(
              title: _newTaskController.taskStatusCountList[index].status,
              count: _newTaskController.taskStatusCountList[index].count.toString());
          }),
      ),
    );
  }

  Future<void> _getAllTaskStatusCount()async{
  

    bool isSuccess = await _newTaskController.getAllTaskStatusCount();

    if(isSuccess){
     
    }else{
      showSnackBarMessage(context,_newTaskController.errorMessage!, true);
    }
    
  }

  Future<void> _getAllNewTaskList()async{

     final bool isSuccess = await _newTaskController.getNewTaskList();
    if(isSuccess){
      setState(() {
        
      });
      showSnackBarMessage(context, _newTaskController.errorMessage!, true);
    }
  
  }
}