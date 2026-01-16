import 'package:yotei/class_variable.dart';
import 'package:yotei/sys_variable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

void setNoti(Map<String, dynamic> subject) async {
  await LocalNotificationsPlugin.zonedSchedule(
    //通知id、通知タイトル、通知テキスト、通知の時間、通知のチャンネルなどを設定
    subject['id'],
    subject['title'],
    '場所:${subject['classroom']}${subject['place']}   開始時間:${subject['hour']}時${subject['minute']}分',
    //初回の通知する日時を設定
    getNotiTime(subject['day'], subject['hour'], subject['minute']),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel',
        'channel subject', //チャンネルID
        channelDescription: 'your channel description',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //2回目以降に毎週（同じ曜日の）同じ時間に通知を行う設定
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

tz.TZDateTime getNotiTime(String day, int hour, int minute) {
  int after = 0;
  var nowtime = DateTime.now();
  var weekday = nowtime.weekday;
  int notiDay = dayNumber[day]!;
  //今日が月曜日のとき
  if (weekday == 1) {
    after = notiDay - 1;
  } else if (weekday == 2) {
    if (notiDay >= 2) {
      after = notiDay - 2;
    } else {
      after = notiDay + 5;
    }
  } else if (weekday == 3) {
    if (notiDay >= 3) {
      after = notiDay - 3;
    } else {
      switch (notiDay) {
        case 1:
          after = 5;
        case 2:
          after = 6;
      }
    }
  } else if (weekday == 4) {
    if (notiDay >= 4) {
      after = notiDay - 4;
    } else {
      after = notiDay + 3;
    }
  } else if (weekday == 5) {
    if (notiDay >= 5) {
      after = notiDay - 5;
    } else {
      after = notiDay + 2;
    }
  } else if (weekday == 6) {
    after = notiDay + 1;
  } else if (weekday == 7) {
    after = notiDay + 0;
  }

  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    //場合によっては、ここの値が31を超える可能性があるが、notificationプラグインが自動で直してくれるのか？そんなことどこかのwebサイトに書いていたような。
    now.day + after,
    0,
    0,
  );
  return scheduledDate;
}

void deleteNoti(int id) async {
  await LocalNotificationsPlugin.cancel(id);
}

void deleteAllNoti() async {
  await LocalNotificationsPlugin.cancelAll();
}

void checkNoti() async {
  final List<PendingNotificationRequest> pendingNotificationRequests =
      await LocalNotificationsPlugin.pendingNotificationRequests();
  for (var pendingNotificationRequest in pendingNotificationRequests) {
    //予定された通知の情報を表示
    debugPrint(
      '予約済みの通知: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]',
    );
  }
}
