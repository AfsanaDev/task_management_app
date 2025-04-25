import 'package:api_class/ui/screens/add_new_task_screen.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/summary_card.dart';
import 'package:api_class/ui/widgets/task_card.dart';
import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/models/task_status_count_list_model.dart';
import 'package:api_class/data/models/task_status_count_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {


  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  bool _getNewTaskInProgress = false;
  List<TaskModel> _newTaskList = [];
  @override
  void initState() {
    
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _getStatusCountInProgress ==false,
            replacement: const Padding(
              padding: EdgeInsets.all(16),
              child: CenteredCirculerProgressIndicator(),
            ),
            child: _buildSummaryCard()),
          Visibility(
            visible: _getNewTaskInProgress == false,
            replacement: const SizedBox(
              height: 300,
              child: CenteredCirculerProgressIndicator()),
            child: ListView.separated(
              itemCount: _newTaskList.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return   TaskCard(taskStatus: TaskStatus.sNew, taskModel: _newTaskList[index],
                refreshList: _getAllNewTaskList,
                );
            
            }, separatorBuilder: (context, index) => const SizedBox(height: 8,),),
          )
        ],
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
          itemCount: _taskStatusCountList.length,
          itemBuilder: (context, index){
            return  SummaryCard(
              title: _taskStatusCountList[index].status,
              count: _taskStatusCountList[index].count.toString());
          }),
      ),
    );
  }

  Future<void> _getAllTaskStatusCount()async{
    _getStatusCountInProgress = true;
    setState(() {
      
    });

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.taskStatusCountUrl);
    //  _getStatusCountInProgress = false;
    //   setState(() {
        
    //   });

    if(response.isSuccess){
     
     TaskStatusCountListModel taskStatusCountListModel = TaskStatusCountListModel.fromJson(response.data ?? {});
     _taskStatusCountList = taskStatusCountListModel.statusCountList;
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getStatusCountInProgress = false;
      setState(() {
        
      });
  }

  Future<void> _getAllNewTaskList()async{
    _getNewTaskInProgress = true;
    setState(() {
        
      });

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.newTaskListUrl);

    if(response.isSuccess){
      
      // _getNewTaskInProgress = true;
      // setState(() {
        
      // });
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _newTaskList = taskListModel.taskList;
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getNewTaskInProgress = false;
      setState(() {
        
      });
  }
}