
import 'package:api_class/ui/controllers/progress_task_controller.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgessTaskScreen extends StatefulWidget {
  const ProgessTaskScreen({super.key});

  @override
  State<ProgessTaskScreen> createState() => _ProgessTaskScreenState();
}

class _ProgessTaskScreenState extends State<ProgessTaskScreen> {

final ProgressTaskController _progressTaskController = Get.find<ProgressTaskController>();

  @override
  void initState() {
    _getAllProgressInTaskList();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProgressTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getAllTaskInProgress == false,
            replacement: const CenteredCirculerProgressIndicator(),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.separated(
                itemCount: controller.progressIntaskList.length,
                itemBuilder: (context, index){
                   return  TaskCard(taskStatus: TaskStatus.progress, taskModel: controller.progressIntaskList[index],
                    refreshList: _getAllProgressInTaskList,);
              
              
              
              }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
            ),
          );
        }
      ),
    );
  }

  Future<void> _getAllProgressInTaskList()async{

    bool isSuccess = await _progressTaskController.getAllProgressInTaskList();

    if(isSuccess){
     
    }else{
      showSnackBarMessage(context, _progressTaskController.errorMessage!, true);
    }
    
  }
}