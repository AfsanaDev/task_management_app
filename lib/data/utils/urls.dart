class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registerUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';
  static const String profileDetailsUrl = '$_baseUrl/ProfileDetails';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String newTaskListUrl = '$_baseUrl/listTaskByStatus/New';
  static const String pogressTaskListUrl = '$_baseUrl/listTaskByStatus/Progress';
  static const String completedTaskListUrl = '$_baseUrl/listTaskByStatus/Completed';
  static const String canceledTaskListUrl = '$_baseUrl/listTaskByStatus/Cancelled';
  static String recoverVerifyEmailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static  String recoverVerifyOtpUrl(String email, String otp) => '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  static const String recoverResetPasswordUrl = '$_baseUrl/RecoverResetPassword';
  
  static String updateTaskStatusUrl(String taskId, String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTaskUrl(String taskId) => '$_baseUrl/deleteTask/$taskId';
}