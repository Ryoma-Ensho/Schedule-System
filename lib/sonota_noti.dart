import 'package:yotei/sys_variable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

void setNoti(Map<String, dynamic> sonota) async {
  await LocalNotificationsPlugin.zonedSchedule(
    //通知id、通知タイトル、通知テキスト、通知の時間、通知のチャンネルなどを設定
    int.parse(sonota['id']),
    '${sonota['title']} (${sonota['hour']}時${sonota['minute']}分)',
    'メモ:${sonota['memo']}',
    //初回の通知する日時を設定
    getNotiTime(sonota),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel',
        'channel sonota',
        channelDescription: 'your channel description',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

tz.TZDateTime getNotiTime(Map<String, dynamic> sonota) {
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    sonota['year'],
    sonota['month'],
    //場合によっては、ここの値が31を超える可能性があるが、notificationプラグインが自動で直してくれるのか？そんなことどこかのwebサイトに書いていたような。
    sonota['day'],
    0,
    0,
  );
  return scheduledDate;
}

void deleteNoti(int id) async {
  await LocalNotificationsPlugin.cancel(id);
}
