import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class AddNewTaskController extends GetxController{
  final bool _addNewTaskInProgress = false;
  bool get addNewTaskInProgress => _addNewTaskInProgress;

  String? _errorMessage ;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description)async{
    bool isSuccess = false;
    _addNewTaskInProgress == true;
    update();

    Map<String, dynamic> requestBody={
       "title": title,
      "description": description,
      "status":"New"
    };

    final NetworkResponse response = await NetworkClient.postRequest(url: Urls.createTaskUrl , body: requestBody);

    if(response.isSuccess){
      update();
     isSuccess = true;
     _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _addNewTaskInProgress == false;
    update();
    return isSuccess;
  }
}