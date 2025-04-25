import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/tm_app_bar.dart';
import 'package:api_class/data/service/nertwork_client.dart';
import 'package:api_class/data/utils/urls.dart';
import 'package:flutter/material.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
   final TextEditingController _titleController = TextEditingController();
   final TextEditingController _descriptionController = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   bool _addNewTaskInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TmAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key:_formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:32,),
                 Text("Add New Task",
                style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                  ),
                  validator: (String? value){
                    if(value?.trim().isEmpty ?? true){
                      return'Enter your title';
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Description",
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  maxLines: 6,
                  validator: (String? value){
                    if(value?.trim().isEmpty ?? true){
                      return'Enter your description';
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: _addNewTaskInProgress == false,
                  replacement: const CenteredCirculerProgressIndicator(),
                  child: ElevatedButton(
                  onPressed: _onTapSubmitButton,
                   child: const Icon(Icons.arrow_circle_right_outlined)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton(){
    if(_formKey.currentState!.validate()){
      _addNewTask();

    }
  }

  Future<void> _addNewTask()async{
    _addNewTaskInProgress == false;
    setState(() {});

    Map<String, dynamic> requestBody={
       "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "status":"New"
    };

    final NetworkResponse response = await NetworkClient.postRequest(url: Urls.createTaskUrl , body: requestBody);

    if(response.isSuccess){
      showSnackBarMessage(context, 'New task added successfully');
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }

  }

  void _clearTextFields(){
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

}


