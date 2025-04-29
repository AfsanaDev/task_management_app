import 'package:api_class/data/models/task_list_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class ProgressTaskController extends GetxController{
  bool _getAllTaskInProgress = false;
  bool get getAllTaskInProgress =>_getAllTaskInProgress;

  String? _errorMessage;
  String? get errorMessage =>_errorMessage;

  List<TaskModel> _progressIntaskList =[];
  List<TaskModel> get progressIntaskList  => _progressIntaskList;

    Future<bool> getAllProgressInTaskList()async{
      bool isSuccess = false;
    _getAllTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.pogressTaskListUrl);

    if(response.isSuccess){

     TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
     _progressIntaskList = taskListModel.taskList;
     isSuccess = true;
     _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _getAllTaskInProgress = false;
      update();
      return isSuccess;
  }
}