import 'package:api_class/data/models/profile_details_model.dart';

class UpdateProfileModel {
  late final String status;
  late final ProfileDetailsModel data;

  UpdateProfileModel.fromJson(Map<String, dynamic> jsonData){
    status = jsonData['status'] ?? '';
    data = ProfileDetailsModel.fromJson(jsonData['data'][0] ?? {});
  }
}