
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';

class ProgessTaskScreen extends StatefulWidget {
  const ProgessTaskScreen({super.key});

  @override
  State<ProgessTaskScreen> createState() => _ProgessTaskScreenState();
}

class _ProgessTaskScreenState extends State<ProgessTaskScreen> {

  bool _getAllTaskInProgress = false;
  List<TaskModel> _progressIntaskList =[];

  @override
  void initState() {
    _getAllProgressInTaskList();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getAllTaskInProgress == false,
        replacement: const CenteredCirculerProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView.separated(
            itemCount: _progressIntaskList.length,
            itemBuilder: (context, index){
               return  TaskCard(taskStatus: TaskStatus.progress, taskModel: _progressIntaskList[index],
                refreshList: _getAllProgressInTaskList,);
          
          
          
          }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
        ),
      ),
    );
  }

  Future<void> _getAllProgressInTaskList()async{
    _getAllTaskInProgress = true;
    setState(() {
        
      });

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.pogressTaskListUrl);

    if(response.isSuccess){
      
      // _getNewTaskInProgress = true;
      // setState(() {
        
      // });
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _progressIntaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getAllTaskInProgress = false;
      setState(() {
        
      });
  }
}