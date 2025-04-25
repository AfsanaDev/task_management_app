
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  
  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList =[];
  
  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskList();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCompletedTaskInProgress == false,
        replacement: const CenteredCirculerProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView.separated(
            itemCount: _completedTaskList.length,
            itemBuilder: (context, index){
               return  TaskCard(taskStatus: TaskStatus.completed, taskModel: _completedTaskList[index], 
               refreshList: _getAllCompletedTaskList,);
          
          }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
        ),
      ),
    );
  }


   Future<void> _getAllCompletedTaskList()async{
    _getCompletedTaskInProgress = true;
    setState(() {
        
      });

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.completedTaskListUrl);

    if(response.isSuccess){
      
      // _getNewTaskInProgress = true;
      // setState(() {
        
      // });
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _completedTaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getCompletedTaskInProgress = false;
      setState(() {
        
      });
  }
}