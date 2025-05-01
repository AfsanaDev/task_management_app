import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class CanceledTaskController extends GetxController{

  bool _getCanceledTaskInProgress = false;
  bool get getCanceledTaskInProgress => _getCanceledTaskInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TaskModel> _canceledTaskList =[];
  List<TaskModel> get canceledTaskList  => _canceledTaskList;
  
   Future<bool> getAllCanceledTaskList()async{

    bool isSuccess = false;
    _getCanceledTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.canceledTaskListUrl);

    if(response.isSuccess){
      
      // _getNewTaskInProgress = true;
      // setState(() {
        
      // });
     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _canceledTaskList = taskListModel.taskList;
     
     isSuccess = true;
     _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getCanceledTaskInProgress = false;
     update();

      return isSuccess;
  }
}