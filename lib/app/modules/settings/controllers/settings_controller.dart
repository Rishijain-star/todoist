import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxInt layout = 0.obs; // 0=List, 1=Board, 2=Calendar
  final RxBool showCompleted = true.obs;
  final RxString grouping = 'None'.obs;
  final RxString sorting = 'Manual'.obs;
  final RxString dateFilter = 'All'.obs;
  final RxString priorityFilter = 'All'.obs;
  final RxString labelFilter = 'Any'.obs;

  void setLayout(int value) => layout.value = value;
  void setShowCompleted(bool value) => showCompleted.value = value;
  void setGrouping(String value) => grouping.value = value;
  void setSorting(String value) => sorting.value = value;
  void setDateFilter(String value) => dateFilter.value = value;
  void setPriorityFilter(String value) => priorityFilter.value = value;
  void setLabelFilter(String value) => labelFilter.value = value;

  void resetDisplaySettings() {
    layout.value = 0;
    showCompleted.value = true;
    grouping.value = 'None';
    sorting.value = 'Manual';
    dateFilter.value = 'All';
    priorityFilter.value = 'All';
    labelFilter.value = 'Any';
  }
}
