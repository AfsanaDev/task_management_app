import 'package:api_class/data/models/user_model.dart';


class PasswordVerifyEmailModel {
  final String status;
  final String data;
  final UserModel userModel;

  PasswordVerifyEmailModel({ required this.userModel,required this.status, required this.data} );

  factory PasswordVerifyEmailModel.fromJson(Map<String, dynamic> jsonData){
   
   return PasswordVerifyEmailModel(

    status: jsonData['status'] ?? '',
    data: jsonData['data'] ?? '',
    userModel: UserModel.fromJson(jsonData['data'] ?? {})

   );
  }

  Map<String, dynamic> toJson(){
    return{
      'status': status,
      'data': data,
      'userModel': userModel
    };
  }
}