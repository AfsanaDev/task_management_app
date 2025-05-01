
import 'package:api_class/data/models/user_model.dart';
import 'package:api_class/ui/controllers/auth_controller.dart';
import 'package:api_class/ui/controllers/new_task_controller.dart';
import 'package:api_class/ui/controllers/update_profile_controller.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/main_bottom_nav_screen.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/tm_app_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, });

  //final VoidCallback refreshUpdateInformation; 

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
 
 XFile? _pickedImage;
 final ImagePicker _imagePicker = ImagePicker();
 
 final UpdateProfileController _updateProfileController = Get.find<UpdateProfileController>();
 final NewTaskController _newTaskController = Get.find<NewTaskController>();

   @override
  void initState() {
    super.initState();
    UserModel userModel = AuthController.userModel!;
    _updateProfileController.emailController.text = userModel.email;
    _updateProfileController.firstNameController.text = userModel.firstName;
    _updateProfileController.lastNameController.text = userModel.lastName;
    _updateProfileController.mobileController.text = userModel.mobile;
    _profileDetailsUpdate();
    
    
  }
  VoidCallback? onUpdate = Get.arguments ?? () {};
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: UpdateProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: const TmAppBar(
            fromProfileSection: true,
           
          ),
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
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
                        controller: controller.emailController,
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
                        controller: controller.firstNameController,
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
                        controller: controller.lastNameController,
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
                        controller: controller.mobileController,
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
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16,),
                    Visibility(
                      visible: controller.updateProfileInProgress == false,
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
    );
  
  }
  void _onTapSubmitButton(){
    //if( formKey.currentState!.validate()){
    _updateUserInformation();
   //}
  }

  Future <void> _updateUserInformation() async{
    bool isSuccess = await _updateProfileController.updateUserInformation(
      _updateProfileController.emailController.text.trim(),
      _updateProfileController.firstNameController.text.trim(), 
      _updateProfileController.lastNameController.text.trim(), 
      _updateProfileController.mobileController.text.trim());
    if( isSuccess){
      await  _profileDetailsUpdate();
      setState(() {
        
      });
      showSnackBarMessage(context, 'User information update Successfull');
    }else{
      showSnackBarMessage(context, _updateProfileController.errorMessage!, true);
    
    }
  }

  Future<void> _profileDetailsUpdate()async{
    bool isSuccess = await _updateProfileController.profileDetailsUpdate();
  
    if(isSuccess){
      if (onUpdate != null) {
      onUpdate!();
     
    }
     showSnackBarMessage(context, 'User details update Successfull');
     
     //Get.to(MainBottomNavScreen());
    }else{
      showSnackBarMessage(context,_updateProfileController.errorMessage!, true);
      
    }
    
  }

  // Future<void> _profileDetailsUpdate()async{
  //   NetworkResponse response = await NetworkClient.getRequest(url: Urls.profileDetailsUrl);

  //   if(response.isSuccess){
  //     UpdateProfileModel updateProfileModel = UpdateProfileModel.fromJson(response.data!);

  //     Map<String, dynamic> profileData ={
  //       '_id':updateProfileModel.data.id,
  //       'email': updateProfileModel.data.email,
  //       'firstName': updateProfileModel.data.firstName,
  //       'lastName': updateProfileModel.data.lastName,
  //       'mobile': updateProfileModel.data.mobile,
  //       'createdDate': updateProfileModel.data.createdDate,
  //       'photo': updateProfileModel.data.photo,
  //       'password': updateProfileModel.data.password
  //     };

  //     UserModel userModel = UserModel.fromJson(profileData);
  //     await AuthController.saveUserInformation(
  //       AuthController.token!, userModel);
  //     await AuthController.getUserInformation();  
  //     setState(() {
        
  //     });
  //   }else{
  //     showSnackBarMessage(context, response.errorMessage, true);
  //   }
    
  // }
  
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

  //  @override
  //    void dispose() {
  //   _emailController.dispose();
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  //   _mobileController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  //   }

}