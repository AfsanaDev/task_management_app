class TaskStatusCountModel {
 late String status;
 late int count;
  TaskStatusCountModel.fromJson(Map<String, dynamic> jsonData){
    status = jsonData['_id'] ?? '';
    count = jsonData['sum'] ??{};
  }
}

//  {
//             "_id": "New",
//             "sum": 1
//         }