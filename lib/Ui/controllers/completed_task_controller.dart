import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class CompletedTaskController extends GetxController{
  bool _getCompletedTaskInProgress = false;
  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;

  List<TaskModel> _completedTaskList =[];
  List<TaskModel> get completedTaskList  => _completedTaskList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
   Future<bool> getAllCompletedTaskList()async{

    bool isSuccess = false;
    _getCompletedTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.completedTaskListUrl);

    if(response.isSuccess){
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _completedTaskList = taskListModel.taskList;
     isSuccess = true;
     _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getCompletedTaskInProgress = false;
      update();
    
    return isSuccess;
  }
}