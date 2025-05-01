import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class TaskCardController extends GetxController{
  bool _inProgress = false;
  bool get inProgress=> _inProgress;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  


  Future<bool> changeTaskStatus(String status, String id) async {
    bool isSuccess =false;
    _inProgress = true;
    update();
    
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.updateTaskStatusUrl(id, status));
       

    _inProgress = false;
    update();
    if (response.isSuccess) {
      update();
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> deleteTask(String id) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.deleteTaskUrl(id));

    _inProgress = false;
    update();
    if (response.isSuccess) {
      update();
      isSuccess = true;
      _errorMessage = null;
    } else {
      
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}