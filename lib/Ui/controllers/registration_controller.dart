import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController{
  bool _resigtrationInProgress = false;
  bool get registrationInProgress => _resigtrationInProgress;
  String? _errorMessage ;
  String? get errorMessage => _errorMessage;
  
  Future <bool> registerUser(String email, String firstName, String lastName, String mobile, String password) async{
    bool isSuccess = false; 
    _resigtrationInProgress = true;
    update();
    Map<String, dynamic> requestBody ={
        "email": email,
      "firstName":  firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password
    };
    NetworkResponse response = await NetworkClient.postRequest(url: Urls.registerUrl, body: requestBody);
     _resigtrationInProgress = false;
    update();
    if(response.isSuccess){
      isSuccess = true;
     _errorMessage = null;
    }
     
    else{
    //  showSnackBarMessage(context, response.errorMessage, true);
     _errorMessage = response.errorMessage;
    
    }
     _resigtrationInProgress = false;
    update();
    return isSuccess;
  }
  
}
