import 'dart:convert';

import 'package:api_class/ui/controllers/auth_controller.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/tm_app_bar.dart';
import 'package:api_class/data/models/update_profile_model.dart';
import 'package:api_class/data/models/user_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, });

  //final VoidCallback refreshUpdateInformation; 

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
 
 
  
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;
  

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    UserModel userModel = AuthController.userModel!;
    _emailController.text = userModel.email;
    _firstNameController.text = userModel.firstName;
    _lastNameController.text = userModel.lastName;
    _mobileController.text = userModel.mobile;
    _profileDetailsUpdate();
    
    
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TmAppBar(
        fromProfileSection: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height:32,),
                       Text("Update Profile",
                      style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24,),
                  _photoPickerWidget(),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String ? value){
                      String email = value?.trim() ?? '';
                      if(EmailValidator.validate(email)== false){
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String ? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String ? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Phone',
                      border: OutlineInputBorder(),
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
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16,),
                Visibility(
                  visible: _updateProfileInProgress == false,
                  replacement: const CenteredCirculerProgressIndicator(),
                  child: ElevatedButton(
                  onPressed:_onTapSubmitButton,
                   child: const Icon(Icons.arrow_circle_right_outlined)),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  
  }
  void _onTapSubmitButton(){
    if( _formKey.currentState!.validate()){
    _updateUserInformation();
   }
  }

  Future <void> _updateUserInformation() async{
    _updateProfileInProgress = true;
    setState(() { 
    });
    Map<String, dynamic> requestBody ={
        "email": _emailController.text.trim(),
      "firstName":  _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      
    };
    if( _passwordController.text.isNotEmpty){
      requestBody['password'] = _passwordController.text;
    }
    
    if(_pickedImage != null){
      List<int> imageByte = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageByte);
      requestBody['photo'] = encodedImage;
    }
    NetworkResponse response = await NetworkClient.postRequest(url: Urls.updateProfileUrl, body: requestBody);
     _updateProfileInProgress = false;
    setState(() { 
    });
    if( response.isSuccess){
      await  _profileDetailsUpdate();
      setState(() {
        
      });
      //widget.refreshUpdateInformation; 
      _passwordController.clear();
      showSnackBarMessage(context, 'User information update Successfull');
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    
    }
  }

  Future<void> _profileDetailsUpdate()async{
    NetworkResponse response = await NetworkClient.getRequest(url: Urls.profileDetailsUrl);

    if(response.isSuccess){
      UpdateProfileModel updateProfileModel = UpdateProfileModel.fromJson(response.data!);

      Map<String, dynamic> profileData ={
        '_id':updateProfileModel.data.id,
        'email': updateProfileModel.data.email,
        'firstName': updateProfileModel.data.firstName,
        'lastName': updateProfileModel.data.lastName,
        'mobile': updateProfileModel.data.mobile,
        'createdDate': updateProfileModel.data.createdDate,
        'photo': updateProfileModel.data.photo,
        'password': updateProfileModel.data.password
      };

      UserModel userModel = UserModel.fromJson(profileData);
      await AuthController.saveUserInformation(
        AuthController.token!, userModel);
      await AuthController.getUserInformation();  
      setState(() {
        
      });
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    
  }
  
  Widget _photoPickerWidget() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
                  height:50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    Container(
                      height: 50,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        
                      ),
                      alignment: Alignment.center,
                      child: const Text('Photo',
                      style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(width: 8,),
                    Text(_pickedImage?.name ??'Select your photo')
                  ],),
                ),
    );
  }

  Future<void> _onTapPhotoPicker() async {
   XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
   if(image!= null){
    _pickedImage = image;
    setState(() { });
   }
  }

  //  void _clearTextFields(){
  //   _emailController.clear();
  //   _firstNameController.clear();
  //   _lastNameController.clear();
  //   _mobileController.clear();
  //   _passwordController.clear();
  // }

   void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
    }

}