class TaskModel {
  late final String id;
  late final String title;
  late final String description;
  late final String status;
  late final String email;
  late final DateTime createdDate;

  TaskModel.fromJson(Map<String, dynamic> jsonData){

    id = jsonData['_id'] ?? '' ;
    title = jsonData['title'] ?? '' ;
    description = jsonData['description'] ?? '' ;
    status = jsonData['status'] ?? '' ;
    email = jsonData['email'] ?? '' ;
    createdDate = DateTime.parse(jsonData['createdDate'] ?? '') ;

  }
}



// {
//createdDate: DateTime.parse(json['createdDate'] as String),
//             "_id": "680337c732c08ed3a7c6b0aa",
//             "title": "A",
//             "description": "v",
//             "status": "New",
//             "email": "tarin@gmail.com",
//             "createdDate": "2025-02-22T06:57:26.463Z"
//         },