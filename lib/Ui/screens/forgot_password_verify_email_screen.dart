
import 'package:api_class/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:api_class/ui/screens/forgot_password_otp_verification_screen.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  

   const ForgotPasswordVerifyEmailScreen({super.key, required this.email,
    
  });

  final String email;
  //final String otp;


  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {

  final TextEditingController _emailController = TextEditingController();
  
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  
  final ForgotPasswordVerifyEmailController _forgotPasswordVerifyEmailController = Get.find<ForgotPasswordVerifyEmailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
         
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:80,),
                 Text("Your Email Address",
                style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4,),
                Text("A 6 digit code will be sent to your email address",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    
                  ),
                   validator: (String ? value){
                    String email = value?.trim() ?? '';
                    if(EmailValidator.validate(email) == false){
                      return ' Enter your valid email address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16,),
                GetBuilder<ForgotPasswordVerifyEmailController>(
                  builder: (controller) {
                    return Visibility(
                      visible:controller.passwordVerifyEmailInProgress == false,
                      replacement: const CenteredCirculerProgressIndicator(),
                      child: ElevatedButton(
                       
                        onPressed:_onTabSubmitButton,
                       child: const Icon(Icons.arrow_circle_right_outlined)),
                       
                       
                    );
                  }
                ),
                
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
          ),
        ))
    );
  }
  
  void _onTapSignInButton(){
    //Navigator.pop(context);
    if(_formKey.currentState!.validate()){
      _passwordVerifyEmail();
    }

  }


  Future<void> _passwordVerifyEmail()async{
   

    final bool isSuccess = await _forgotPasswordVerifyEmailController.passwordVerifyEmail(_emailController.text.trim());
   

      if(isSuccess){
        showSnackBarMessage(context, 'Email sent successfully');
       // print(response.data);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  ForgotPasswordOtpVerificationScreen(email: _emailController.text,)), (pre)=>false,);
      
      }else{
        
      setState(() {});
      showSnackBarMessage(context, _forgotPasswordVerifyEmailController.errorMessage!, true);
      }

  

  }

  void _onTabSubmitButton(){
    if(_formKey.currentState!.validate()){
      _passwordVerifyEmail();
    }
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>  ForgotPasswordOtpVerificationScreen(email: _emailController.text, ),));
  }
  @override
  void dispose() {
   // _emailController.dispose();
    super.dispose();
  }
}