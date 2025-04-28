import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class ForgotPasswordVerifyEmailController extends GetxController{
    bool _passwordVerifyEmailInProgress = false;
    bool get passwordVerifyEmailInProgress => _passwordVerifyEmailInProgress;

    String? _errorMessage;
    String? get errorMessage => _errorMessage;
    Future<bool> passwordVerifyEmail(String email)async{
      bool isSuccess = false;
    _passwordVerifyEmailInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyEmailUrl(email),  );
       _passwordVerifyEmailInProgress = false;
       update();

      if(response.isSuccess){
         isSuccess = true;
       _errorMessage = null;
      }else{
        
      update();
      _errorMessage = response.errorMessage;
      }

      _passwordVerifyEmailInProgress = false;
      update();

    return isSuccess;

  

  }
}