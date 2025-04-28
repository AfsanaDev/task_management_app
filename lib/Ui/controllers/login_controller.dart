import 'package:api_class/data/models/login_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:api_class/ui/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{ 

bool _loginInProgress = false;
bool get loginInProgress => _loginInProgress;
String? _errorMessage;
String? get errorMessage => _errorMessage;

 Future<bool> login(String email, String password)async{
  bool isSuccess = false;
     _loginInProgress = true;
    update();
    Map<String, dynamic> requestBody ={
        "email": email,
      "password": password
    };
    NetworkResponse response = await NetworkClient.postRequest(url: Urls.loginUrl, body: requestBody);
     
    if( response.isSuccess){

      LoginModel loginModel = LoginModel.fromJson(response.data!);
      

      await AuthController.saveUserInformation(loginModel.token, loginModel.userModel);
     isSuccess = true;
     _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _loginInProgress = false;
    update();
    return isSuccess;
  } 
}