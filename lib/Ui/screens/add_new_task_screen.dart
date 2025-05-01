import 'package:api_class/ui/controllers/add_new_task_controller.dart';
import 'package:api_class/ui/widgets/centered_circuler_progress_indicator.dart';
import 'package:api_class/ui/widgets/screen_background.dart';
import 'package:api_class/ui/widgets/snack_bar_message.dart';
import 'package:api_class/ui/widgets/tm_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
   final TextEditingController _titleController = TextEditingController();
   final TextEditingController _descriptionController = TextEditingController();
   
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final AddNewTaskController _addNewTaskController =Get.find<AddNewTaskController>();
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
                GetBuilder<AddNewTaskController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.addNewTaskInProgress == false,
                      replacement: const CenteredCirculerProgressIndicator(),
                      child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                       child: const Icon(Icons.arrow_circle_right_outlined)),
                    );
                  }
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
    

    final bool isSuccess = await _addNewTaskController.addNewTask(
      _titleController.text.trim(), _descriptionController.text.trim(),);

    //final NetworkResponse response = await NetworkClient.postRequest(url: Urls.createTaskUrl , body: requestBody);

    if(isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, 'New task added successfully');
     // Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewTaskScreen(),));
       
     
    }else{
      showSnackBarMessage(context, _addNewTaskController.errorMessage!);
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


