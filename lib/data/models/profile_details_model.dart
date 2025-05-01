
//  class ProfileDetailsModel {
//  late final String id;
//  late final String email;
//  late final String firstName;
//  late final String lastName;
//  late final String mobile;
//  late final String createdDate;
//  late final String photo;
//  late final String password;

//   ProfileDetailsModel({
//     required this.id,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.mobile,
//     required this.createdDate,
//     required this.photo,
//     required this.password
//   });

//    ProfileDetailsModel.fromJson(Map<String, dynamic> jsonData){

//     return ProfileDetailsModel(
//       id = jsonData['_id'] ?? '',
//       email= jsonData['email'] ?? '',
//       firstName= jsonData['firstName'] ?? '',
//       lastName= jsonData['lastName'] ?? '',
//       mobile= jsonData['mobile'] ?? '',
//       createdDate= jsonData['createdDate'] ?? '',
//       photo= jsonData['photo'] ?? '', 
//       password= jsonData['password'] ?? '',
//     );

//   }
//    Map<String, dynamic> toJson(){

//     final Map<String, dynamic> data = <String, dynamic>{};

       
//           data['_id'] = id;
//           data['email'] = email;
//           data['firstName'] = firstName;  
//           data['lastName'] = lastName;
//           data['mobile'] = mobile;
//           data['createdDate'] = createdDate;  
//           data['photo'] = photo;
//           data['password'] = password;
//           return data;
//         //   'email': email,
//         //   'firstName': firstName,
//         //   'lastName': lastName,
//         //   'mobile': mobile,
//         //   'createDate': createdDate,
//         //   'photo': photo,
//         //   'password': password
//         // };
//       }

   
// }
class ProfileDetailsModel{
  late final String id;
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String mobile;
  late final String password;
  late final String createdDate;
  late final String photo;

  ProfileDetailsModel.fromJson(Map<String,dynamic>jsonData){
    id=jsonData['_id'] ?? '';
    email=jsonData['email'] ?? '';
    firstName=jsonData['firstName'] ?? '';
    lastName = jsonData['lastName'] ?? '';
    mobile = jsonData['mobile'] ?? '';
    password= jsonData['password']?? '';
    createdDate =jsonData['createdDate'] ?? '';
    photo =jsonData['photo']?? '';


  }
 Map<String,dynamic>toJson(){
   final Map<String,dynamic>data= <String,dynamic> {};


     data['_id'] =id;
      data['email']=email;
     data['firstName']=firstName;
      data['lastName']=lastName;
      data['mobile']=mobile;
      data['password']=password;
      data['createdDate']=createdDate;
      data['photo']=photo;
      return data; }

}