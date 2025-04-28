import 'package:api_class/ui/controllers/forgot_password_otp_verification_controller.dart';
import 'package:api_class/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:api_class/ui/controllers/login_controller.dart';
import 'package:api_class/ui/controllers/new_task_controller.dart';
import 'package:api_class/ui/controllers/registration_controller.dart';
import 'package:api_class/ui/controllers/reset_password_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(NewTaskController());
    Get.put(RegistrationController());
    Get.put(ForgotPasswordVerifyEmailController());
    Get.put(ForgotPasswordOtpVerificationController());
    Get.put(ResetPasswordController());
  }

}