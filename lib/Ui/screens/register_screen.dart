import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHiddenPassword = true;
  bool _resigtrationInProgress = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ScreenBackground(
        child: SingleChildScrollView(
          
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height:80,),
                   Text("Join With Us",
                  style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24,),
                  TextFormField(
                    controller:  _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    
                    decoration: const InputDecoration(
                      hintText: "Email",
                      
                    ),
                    validator: (String ? value){
                      String email = value?.trim() ?? '';
                      if(EmailValidator.validate(email)== false){
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24,),
                  TextFormField(
                    controller:  _firstNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                      
                    ),
                    validator: (String ? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24,),
                  TextFormField(
                    controller:  _lastNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                      
                    ),
                    validator: (String ? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24,),
                  TextFormField(
                    controller:  _mobileController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Mobile Number",
                      
                    ),
                    validator: (String? value) {
                      String phone = value?.trim() ?? '';
                      RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                      if (regExp.hasMatch(phone) == false) {
                        return 'Enter your valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                   TextFormField(
                    controller:  _passwordController,
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
                      if((value?.isEmpty ?? true) || (value!.length < 6)){
                        return 'Enter your password more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                  Visibility(
                    visible: _resigtrationInProgress ==false,
                    replacement: const CenteredCirculerProgressIndicator(),
                    child: ElevatedButton(
                     
                      onPressed:_onTapSubmitButton,
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
                        const TextSpan(text: 'Already have an account? '),
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
          ),
        ))
    );
  }

  void _onTapSignInButton(){
    Navigator.pop(context);
  }
   void _onTapSubmitButton(){
   if( _formKey.currentState!.validate()){
    _registerUser();
   }
  }

  Future <void> _registerUser() async{
    _resigtrationInProgress = true;
    setState(() { 
    });
    Map<String, dynamic> requestBody ={
        "email": _emailController.text.trim(),
      "firstName":  _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "password": _passwordController.text
    };
    NetworkResponse response = await NetworkClient.postRequest(url: Urls.registerUrl, body: requestBody);
     _resigtrationInProgress = false;
    setState(() { 
    });
    if( response.isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, 'User Registration Successfull');
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    
    }
  }

  void _clearTextFields(){
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
    }
}