
import 'package:api_class/Ui/controllers/auth_controller.dart';
import 'package:api_class/Ui/screens/forgot_password_otp_verification_screen.dart';
import 'package:api_class/Ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/Ui/widgets/screen_background.dart';
import 'package:api_class/Ui/widgets/snack_bar_message.dart';
import 'package:api_class/data/models/password_verify_email_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/models/user_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  

   ForgotPasswordVerifyEmailScreen({super.key, required this.email,
    
  });

  final String email;
  //final String otp;


  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {

  final TextEditingController _emailController = TextEditingController();
  
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVerifyEmailInProgress = false;

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
                Visibility(
                  visible: _passwordVerifyEmailInProgress == false,
                  replacement: const CenteredCirculerProgressIndicator(),
                  child: ElevatedButton(
                   
                    onPressed:_onTabSubmitButton,
                   child: const Icon(Icons.arrow_circle_right_outlined)),
                   
                   
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


  void _passwordVerifyEmail()async{
    _passwordVerifyEmailInProgress = true;
    setState(() {
    });

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyEmailUrl(_emailController.text),  );
       _passwordVerifyEmailInProgress = false;
    setState(() {
    });

      if(response.isSuccess){
        showSnackBarMessage(context, 'Email sent successfully');
       // print(response.data);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  ForgotPasswordOtpVerificationScreen(email: _emailController.text,)), (pre)=>false,);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordOtpVerificationScreen(otp: 0,)),);
      }else{
        
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
      }

    // Map<String, dynamic> requestBody ={
    //   "email": _emailController.text.trim(),
    // };

    // NetworkResponse response = await NetworkClient.getRequest(
    //   url: Urls.recoverVerifyEmailUrl(widget.taskModel.email),);

    // _passwordVerifyEmailInProgress = false;
    // setState(() {
      
    // });

    // if(response.isSuccess){
    //   PasswordVerifyEmailModel passwordVerifyEmailModel = PasswordVerifyEmailModel.fromJson(response.data!);

    //   AuthController.saveUserEmailInformation(_emailController.text);
    //    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPinVerificationScreen()),);
    // }

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