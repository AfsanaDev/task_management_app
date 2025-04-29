import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController{
   bool _resetPasswordInProgress =false;
   bool get resetPasswordInProgress => _resetPasswordInProgress;

   String? _errorMessage;
   String? get errorMessage => _errorMessage;
    Future <bool> resetPassword(String email, String otp, String password)async{
      bool isSuccess = false;
    _resetPasswordInProgress = true;
    update();
  

    Map<String, dynamic> requestBody ={
      "email": email,
      "OTP": otp,
      "password":password
    };

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.recoverResetPasswordUrl,body: requestBody);
     _resetPasswordInProgress = false;
    update();
      if(response.isSuccess){
        isSuccess = true;
        _errorMessage = null;
      }else{
       _errorMessage = response.errorMessage;
      }
      _resetPasswordInProgress = false;
      update();
      return isSuccess;
  }
}