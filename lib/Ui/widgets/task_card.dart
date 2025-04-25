import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/data/models/password_verify_email_model.dart';
import 'package:api_class/data/models/task_model.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshList, 
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _inProgress = false;
  DateTime now = DateTime.now();

  //final dateTimeFormate = DateFormat('dd-MM-yyyy');
  final DateFormat _formatter = DateFormat('dd-MM-yyyy hh:mm a');
  
  @override
  Widget build(BuildContext context) {
    final formatted = _formatter.format(widget.taskModel.createdDate);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(widget.taskModel.description),
            // TODO: Format it with DateFormatter (intl)
           
           Text('Date: $formatted'),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Visibility(
                  visible: _inProgress == false,
                  replacement: const CenteredCirculerProgressIndicator(),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed:_deleteTask,
                        icon: const Icon(Icons.delete, color: Colors.red,),
                      ),
                      IconButton(
                          onPressed:_showUpdateStatusDialog,
                          icon: const Icon(Icons.edit, color: Colors.blue,)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    late Color color;
    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }

  


  void _showUpdateStatusDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Update status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('New')) return;
                _changeTaskStatus('New');
              },
              title: const Text('New'),
                  trailing: isSelected('New')
                      ? const Icon(Icons.done)
                      : null,
                ),
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('Progress')) return;
                _changeTaskStatus('Progress');
              },
              title: const Text('Progress'),
              trailing: isSelected('Progress')
                  ? const Icon(Icons.done)
                  : null,
            ),
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('Completed')) return;
                _changeTaskStatus('Completed');
              },
              title: const Text('Completed'),
              trailing: isSelected('Completed')
                  ? const Icon(Icons.done)
                  : null,
            ),
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('Cancelled')) return;
                _changeTaskStatus('Cancelled');
              },
              title: const Text('Cancelled'),
              trailing: isSelected('Cancelled')
                  ? const Icon(Icons.done)
                  : null,
            ),
          ],
        ),
      );
    });
  }

  void _popDialog() {
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;
  
  Future<void> _changeTaskStatus(String status) async {
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));
        print(widget.taskModel.id);

    _inProgress = false;
    setState(() {
      
    });
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  Future<void> _deleteTask() async {
    _inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.deleteTaskUrl(widget.taskModel.id));

    _inProgress = false;
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }
}



// import 'package:api_class/data/models/task_model.dart';
// import 'package:flutter/material.dart';

// enum TaskStatus {
//    sNew,
//    progress, 
//    completed,
//    canceled
//     }
// class TaskCard extends StatelessWidget {
//    const TaskCard({super.key, required this.taskStatus, required this.taskModel});

//   final TaskModel taskModel;
//   final TaskStatus taskStatus;
//   @override
//   Widget build(BuildContext context) {
//     return  Card(
//             elevation: 0,
//             color: Colors.white,
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                    Text(taskModel.title, style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600
//                   ),),
//                    Text(taskModel.description),
//                    Text('Date:${taskModel.createdDate}'),
                  
//                   Row(
//                   children: [
//                   Chip(label:  Text(taskModel.status, style: TextStyle(
//                     color: Colors.white,
//                   ),
                  
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   backgroundColor:_getStatusChipColor(),
//                   side: BorderSide.none,),
//                   const Spacer(),
//                   IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
//                   IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
//                   ],)
//                 ],
//               ),
//             ),
//           );
//   }

//   Color _getStatusChipColor(){
//     late Color color;
//     switch(taskStatus){
//       case TaskStatus.sNew:
//       color = Colors.blue;
//       case TaskStatus.progress:
//        color = Colors.purple;
//       case TaskStatus.completed:
//        color = Colors.green;
//       case TaskStatus.canceled:
//        color = Colors.red;
//     }
//     return color;
//   }
// }