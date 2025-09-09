import 'package:get/get.dart';

class UserController extends GetxController {
  var userIssues = <String>[].obs;
  var empUnd = 2.obs;
  var lisSol = 3.obs;
  var hoTa = 1.obs;

  var selectedConvMode = 0.obs;

  void addIssue(String issue) {
    if (userIssues.contains(issue)) {
      userIssues.remove(issue);
    } else {
      userIssues.add(issue);
    }
  }

  void updateEmpathy(double value) {
    empUnd.value = value.round();
  }
}