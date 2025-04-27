import 'package:api_class/ui/controllers/login_controller.dart';
import 'package:api_class/ui/screens/forgot_password_verify_email_screen.dart.dart';
import 'package:api_class/ui/screens/register_screen.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/main_bottom_nav_screen.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, });

  


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  bool _isHiddenPassword = true;
  final LoginController _loginController = Get.find<LoginController>();

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
                 Text("Get Started With",
                style: Theme.of(context).textTheme.titleLarge,
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
                 TextFormField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  obscureText: _isHiddenPassword,
                  decoration:  InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isHiddenPassword?Icons.visibility_off:
                        Icons.visibility),
                      onPressed: (){
                        setState(() {
                          _isHiddenPassword = !_isHiddenPassword;
                        });
                      },
                    ),
                   
                  ),
                  validator: (String ? value){
                    if( (value?.isEmpty ?? true) || (value!.length < 6) ){
                      return ' Enter your password more then 6 letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                GetBuilder<LoginController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.loginInProgress == false,
                      replacement: const CenteredCirculerProgressIndicator(),
                      child: ElevatedButton(
                       
                        onPressed: _onTabSignInButton,
                       child: const Icon(Icons.arrow_circle_right_outlined)),
                    );
                  }
                ),
                 const SizedBox(height: 32,),
                 Center(
                   child: Column(
                     children: [
                       TextButton(onPressed: _onTapForgotPasswordButton, 
                       child: const Text('Forgot Password?'),),
                       RichText(text:  TextSpan(
                        style: const TextStyle(
                          color: Color.fromARGB(137, 3, 2, 2),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        
                        ),
                        children: [
                          const TextSpan(text: 'Dont have an account? '),
                          TextSpan(text: 'Sign Up',style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold, 
                          ),
                          recognizer: TapGestureRecognizer()..onTap=_onTapSignUpButton,
                          )
                        ]
                       )),
                     ],
                   ),
                 )
              ],
            ),
          ),
        ))
    );
  }
  void _onTabSignInButton(){
     if( _formKey.currentState!.validate()){
      _login();
     }
  }

  Future<void> _login()async{
    final bool isSuccess = await _loginController.login(_emailController.text.trim(), _passwordController.text);
    if(isSuccess){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainBottomNavScreen()), (pre)=>false,);
    }else{
      showSnackBarMessage(context, _loginController.errorMessage!, true);
    
    }
  }  
  void _onTapForgotPasswordButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ForgotPasswordVerifyEmailScreen(email: _emailController.text,)));
  }
  
  void _onTapSignUpButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen(),));

  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}