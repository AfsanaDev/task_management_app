import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:get/get.dart';

class ForgotPasswordOtpVerificationController extends GetxController{

  bool _otpVerificationInProgress = false;
  bool get otpVerificationInProgress => _otpVerificationInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
    Future <bool> otpVerification(String email, String otp)async{
      bool isSuccess = false;
    _otpVerificationInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyOtpUrl(email, otp));

      if(response.isSuccess){
        isSuccess = true;
        _errorMessage = null;
      }else{
        _errorMessage = response.errorMessage;
      }
      _otpVerificationInProgress = false;
      update();
      return isSuccess;
  }

}