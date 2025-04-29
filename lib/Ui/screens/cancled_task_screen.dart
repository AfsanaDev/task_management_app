
import 'package:api_class/ui/controllers/canceled_task_controller.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  //List<TaskModel> _canceledTaskList =[];
  final CanceledTaskController _canceledTaskController = Get.find<CanceledTaskController>();

  @override
  void initState() {
    _getAllCanceledTaskList();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CanceledTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getCanceledTaskInProgress == false,
            replacement: const CenteredCirculerProgressIndicator(),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.separated(
                itemCount: controller.canceledTaskList.length,
                itemBuilder: (context, index){
                   return TaskCard(taskStatus: TaskStatus.cancelled,
                    taskModel: controller.canceledTaskList[index],
                    refreshList: _getAllCanceledTaskList,);
              
              }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
            ),
          );
        }
      ),
    );
  }

  Future<void> _getAllCanceledTaskList()async{
 
    final bool isSuccess = await _canceledTaskController.getAllCanceledTaskList();
    
    if(isSuccess){
   
    }else{
      showSnackBarMessage(context, _canceledTaskController.errorMessage!, true);
    }
    
  }
}