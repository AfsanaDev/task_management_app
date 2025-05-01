import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/models/task_status_count_list_model.dart';
import 'package:api_class/data/models/task_status_count_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class NewTaskController extends GetxController{
bool _getNewTaskInProgress = false;
bool get getNewTaskInProgress => _getNewTaskInProgress;
String? _errorMessage;
String? get errorMessage => _errorMessage;
List<TaskModel> _newTaskList =[];

List<TaskModel> get newTaskList => _newTaskList;

bool _getStatusCountInProgress = false;
bool get getStatusCountInProgress => _getStatusCountInProgress;
List<TaskStatusCountModel> _taskStatusCountList =[];

List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;

 Future<bool> getNewTaskList()async{
  bool isSuccess = false;
    _getNewTaskInProgress = true;
    update();

  final NetworkResponse response = await NetworkClient.getRequest(url: Urls.newTaskListUrl);

    if(response.isSuccess){
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _newTaskList = taskListModel.taskList;
     isSuccess = true;
     _errorMessage = null;
    }else{
     _errorMessage = response.errorMessage;
    }
    _getNewTaskInProgress = false;
    update();

      return isSuccess;
  }


  Future<bool> getAllTaskStatusCount()async{
    bool isSuccess = false;
    _getStatusCountInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.taskStatusCountUrl);
      _getStatusCountInProgress = false;
      update();

    if(response.isSuccess){
     
     TaskStatusCountListModel taskStatusCountListModel = TaskStatusCountListModel.fromJson(response.data ?? {});
     _taskStatusCountList = taskStatusCountListModel.statusCountList;
     update();
     isSuccess = true;
     _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getStatusCountInProgress = false;
    update();

    return isSuccess;
  }

}