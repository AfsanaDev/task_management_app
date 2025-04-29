
import 'package:api_class/ui/controllers/forgot_password_otp_verification_controller.dart';
import 'package:api_class/ui/screens/login_screen.dart';
import 'package:api_class/ui/screens/reset_password_screen.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOtpVerificationScreen extends StatefulWidget {
  const ForgotPasswordOtpVerificationScreen({super.key,  required this.email,});
  //final String otp;
  final String email;
  @override
  State<ForgotPasswordOtpVerificationScreen> createState() => _ForgotPasswordOtpVerificationScreenState();
}

class _ForgotPasswordOtpVerificationScreenState extends State<ForgotPasswordOtpVerificationScreen> {

  final TextEditingController _pinCondeController = TextEditingController();
  
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  final ForgotPasswordOtpVerificationController _forgotPasswordOtpVerificationController = Get.find<ForgotPasswordOtpVerificationController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ScreenBackground(
        
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height:80,),
               Text("Pin Verification",
              style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4,),
              Text("A 6 digit code will be sent to your email address",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24,),
             PinCodeTextField(
              
              length: 6,
              keyboardType: TextInputType.number,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedColor: Colors.white,
                inactiveFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              controller: _pinCondeController,
              onCompleted: (v) {
                print("Completed");
              },
              
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              }, appContext: context,
            ),
              
              const SizedBox(height: 16,),
              ElevatedButton(
               //_onTabSubmitButton
                onPressed: _otpVerification,
               child: const Text('Verify'),),
               const SizedBox(height: 32,),
               Center(
                 child: RichText(text:  TextSpan(
                  style: const TextStyle(
                    color: Color.fromARGB(137, 3, 2, 2),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  
                  ),
                  children: [
                    const TextSpan(text: 'have an account? '),
                    TextSpan(text: 'Sign In',style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold, 
                    ),
                    recognizer: TapGestureRecognizer()..onTap=_onTapSignInButton,
                    )
                  ]
                 )),
               )
            ],
          ),
        ))
    );
  }
  
  void _onTabSubmitButton(){
    // Navigator.push(context, MaterialPageRoute( builder: (context)=> const ResetPasswordScreen(),));
  }

  Future <void> _otpVerification()async{
   

      final bool isSuccess = await _forgotPasswordOtpVerificationController.otpVerification(widget.email, _pinCondeController.text); 
      if(isSuccess){
        
        Navigator.push(context, MaterialPageRoute( builder: (context)=>  ResetPasswordScreen(email:widget.email, otp: _pinCondeController.text,),));
      }else{
        showSnackBarMessage(context, _forgotPasswordOtpVerificationController.errorMessage!, true);
      }
  }
  void _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (pre)=>false,);

  }
  @override
  void dispose() {
    //_pinCondeController.dispose();
    super.dispose();
  }
}