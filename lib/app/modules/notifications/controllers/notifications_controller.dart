import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationItem>[
    NotificationItem(
      title: 'Task Due Soon',
      desc: 'Team standup meeting is starting in 15 minutes.',
      time: '15m ago',
      isRead: false,
    ),
    NotificationItem(
      title: 'New Comment',
      desc: 'Rohit commented on "Review design mockups".',
      time: '1h ago',
      isRead: false,
    ),
    NotificationItem(
      title: 'Project Update',
      desc: 'G5tc project was updated by the team.',
      time: '2h ago',
      isRead: true,
    ),
  ].obs;

  void markAsRead(int index) {
    notifications[index] = NotificationItem(
      title: notifications[index].title,
      desc: notifications[index].desc,
      time: notifications[index].time,
      isRead: true,
    );
  }
}

class NotificationItem {
  final String title;
  final String desc;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.desc,
    required this.time,
    this.isRead = false,
  });
}
