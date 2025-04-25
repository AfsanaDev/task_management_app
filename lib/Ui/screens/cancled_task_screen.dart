
import 'package:api_class/Ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/Ui/widgets/snack_bar_message.dart';
import 'package:api_class/Ui/widgets/task_card.dart';
import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  bool _getCanceledTaskInProgress = false;
  List<TaskModel> _canceledTaskList =[];

  @override
  void initState() {
    _getAllCanceledTaskList();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCanceledTaskInProgress == false,
        replacement: const CenteredCirculerProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView.separated(
            itemCount: _canceledTaskList.length,
            itemBuilder: (context, index){
               return TaskCard(taskStatus: TaskStatus.cancelled,
                taskModel: _canceledTaskList[index],
                refreshList: _getAllCanceledTaskList,);
          
          }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
        ),
      ),
    );
  }

  Future<void> _getAllCanceledTaskList()async{
    _getCanceledTaskInProgress = true;
    setState(() {
        
      });

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.canceledTaskListUrl);

    if(response.isSuccess){
      
      // _getNewTaskInProgress = true;
      // setState(() {
        
      // });
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _canceledTaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getCanceledTaskInProgress = false;
      setState(() {
        
      });
  }
}