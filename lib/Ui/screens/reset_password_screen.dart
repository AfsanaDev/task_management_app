
import 'package:api_class/Ui/screens/login_screen.dart';
import 'package:api_class/Ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/Ui/widgets/screen_background.dart';
import 'package:api_class/Ui/widgets/snack_bar_message.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool _resetPasswordInProgress = false;


  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  bool _isNewHiddenPassword = true;
  bool _isConfirmHiddenPassword = true;


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
                 Text("Set Password",
                style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4,),
                Text("Set a new Password minimum length 8 characters",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24,),
               TextFormField(
                controller: _newPasswordController,
                textInputAction: TextInputAction.next,
                obscureText: _isNewHiddenPassword,
                 decoration: InputDecoration(
                   hintText: "New Password",
                   suffixIcon: IconButton(
                      icon: Icon(
                        _isNewHiddenPassword?Icons.visibility_off:
                        Icons.visibility),
                      onPressed: (){
                        setState(() {
                          _isNewHiddenPassword = !_isNewHiddenPassword;
                        });
                      },
                    ),
                   ),
                    validator: (String ? value){
                    if( (value?.isEmpty ?? true) || (value!.length < 8) ){
                      return ' Enter your password more then 8 letters';
                    }
                    return null;
                  },
               ),
               const SizedBox(height: 24,),
               TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isConfirmHiddenPassword,
                textInputAction: TextInputAction.done,
                 decoration: InputDecoration(
                   hintText: "Confirm Password",
                   suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmHiddenPassword?Icons.visibility_off:
                        Icons.visibility),
                      onPressed: (){
                        setState(() {
                          _isConfirmHiddenPassword = !_isConfirmHiddenPassword;
                        });
                      },
                    ),
                   ),
                    validator: (String ? value){
                    if( (value?.isEmpty ?? true) || (value!.length < 8) ){
                      return ' Enter your password more then 8 letters';
                    }
                    return null;
                  },
               ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: _resetPasswordInProgress ==false,
                  replacement: const CenteredCirculerProgressIndicator(),
                  child: ElevatedButton(
                   
                    onPressed: _onTabSubmitButton,
                   child: const Text('Confirm'),),
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
  
  void _onTabSubmitButton(){

    if( _formKey.currentState!.validate()){
      _resetPassword();
     }
    //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (pre)=>false,);
  }

  Future <void> _resetPassword()async{
    _resetPasswordInProgress == true;
    setState(() {
      
    });

    Map<String, dynamic> requestBody ={
      "email": widget.email.trim(),
      "OTP": widget.otp,
      "password":_newPasswordController.text
    };

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.recoverResetPasswordUrl,body: requestBody);
     _resetPasswordInProgress = false;
    setState(() { 
    });
      if(response.isSuccess){
       showSnackBarMessage(context, 'Reset Password Successfully');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (pre)=>false,);
      }else{
        showSnackBarMessage(context, response.errorMessage, true);
      }
  }
  void _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (pre)=>false,);

  }
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}