import 'dart:convert';

import 'package:api_class/data/models/update_profile_model.dart';
import 'package:api_class/data/models/user_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:api_class/ui/controllers/auth_controller.dart';
import 'package:api_class/ui/controllers/new_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController{

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   GlobalKey<FormState> get formKey => _formKey;
   
   XFile? _pickedImage;
   XFile? get pickedImage => _pickedImage;

  final ImagePicker _imagePicker = ImagePicker();
  ImagePicker get imagePicker => _imagePicker;
 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  

   bool _updateProfileInProgress = false;
   bool get updateProfileInProgress => _updateProfileInProgress;

   String? _errorMessage;
   String? get errorMessage => _errorMessage; 

   void _loadUserData() {
    UserModel userModel = AuthController.userModel!;
    emailController.text = userModel.email;
    firstNameController.text = userModel.firstName;
    lastNameController.text = userModel.lastName;
    mobileController.text = userModel.mobile;
  }

   //@override
  // void onInit() {
  //   super.onInit();
  //    if (AuthController.userModel != null) {
  //   _loadUserData();
  //  // profileDetailsUpdate();
  // } else {
  //   // Optionally redirect to login or show error
  //   Get.snackbar('Error', 'User not logged in');
  // }
  // }
  Future <bool> updateUserInformation(String email, String firstName, String lastName, String mobile) async{
    bool isSuccess = false;
    _updateProfileInProgress = true;
    update();
    Map<String, dynamic> requestBody ={
        "email": email,
      "firstName":  firstName,
      "lastName": lastName,
      "mobile": mobile,
      
    };
    if( passwordController.text.isNotEmpty){
      requestBody['password'] = passwordController.text;
    }
    
    if(_pickedImage != null){
      List<int> imageByte = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageByte);
      requestBody['photo'] = encodedImage;
    }
    NetworkResponse response = await NetworkClient.postRequest(url: Urls.updateProfileUrl, body: requestBody);
     _updateProfileInProgress = false;
    update();
    if( response.isSuccess){
      //await  profileDetailsUpdate();
      update();
      //widget.refreshUpdateInformation; 
      passwordController.clear();
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage= response.errorMessage;
    
    }
    _updateProfileInProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> profileDetailsUpdate()async{
    bool isSuccess = false;
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
      //await _newTaskController.getNewTaskList();
      update();
       isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage;
    }
    _updateProfileInProgress = false;
    update();
    return isSuccess;
  }
}