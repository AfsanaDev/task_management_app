
import 'package:api_class/ui/controllers/completed_task_controller.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  
  final CompletedTaskController _completedTaskController = Get.find<CompletedTaskController>();
  
  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskList();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CompletedTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getCompletedTaskInProgress == false,
            replacement: const CenteredCirculerProgressIndicator(),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.separated(
                itemCount:_completedTaskController.completedTaskList.length,
                itemBuilder: (context, index){
                   return  TaskCard(taskStatus: TaskStatus.completed,
                    taskModel: _completedTaskController.completedTaskList[index], 
                   refreshList: _getAllCompletedTaskList,);
              
              }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
            ),
          );
        }
      ),
    );
  }


   Future<void> _getAllCompletedTaskList()async{
  

    bool isSuccess = await _completedTaskController.getAllCompletedTaskList();

    if(isSuccess){
      
    }else{
      showSnackBarMessage(context, _completedTaskController.errorMessage!, true);
    }
  }
}