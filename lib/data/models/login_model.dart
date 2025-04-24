import 'package:api_class/data/models/user_model.dart';


// Using factory constructor 

class LoginModel {
  final String status;
  final String token;
  final UserModel userModel;

  LoginModel({required this.status, required this.token, required this.userModel});

  factory LoginModel.fromJson(Map<String, dynamic> jsonData){
    return LoginModel(

    status : jsonData['status'] ?? '',
    token: jsonData['token']  ?? '',
    userModel: UserModel.fromJson(jsonData['data'] ?? {})
    );
    
  }

  Map<String, dynamic> toJson(){
    return{
      'status': status,
      'token': token,
      'userModel': userModel
    };
  }

  
}


// class LoginModel {
//   late final String status;
//   late final String token;
//   late final UserModel userModel;

  

//   LoginModel.fromJson(Map<String, dynamic> jsonData){
//     status = jsonData['status'] ?? '';
//     token = jsonData['token'] ?? '';
//     userModel =  UserModel.fromJson(jsonData['data'] ?? {});
//     // lastName = jsonData['lastName'] ?? '';
//     // mobile = jsonData['mobile'] ?? '';
//     // createdDate = jsonData['createdDate'] ?? '';
    
//   }

//   Map<String, dynamic> toJson(){
//     return{
//       'status': status,
//       'token': token,
//       'userModel': userModel
//     };
//   }

  
// }