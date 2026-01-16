import 'package:flutter/material.dart';

List<Map<String, dynamic>> subjects = [];

Map<String, dynamic> subject = {
  "id": 1,
  "title": '',
  "place": '',
  "classroom": '',
  "day": '月曜日',
  "period": 1,
  "hour": 9,
  "minute": 0,
};

const List<String> day = <String>['月曜日', '火曜日', '水曜日', '木曜日', '金曜日'];
const List<int> period = <int>[1, 2, 3, 4, 5];
Map<String, int> dayNumber = {"月曜日": 1, "火曜日": 2, "水曜日": 3, "木曜日": 4, "金曜日": 5};
const List<int> hour = <int>[9, 11, 13, 15, 17];
const List<int> minute = <int>[0, 0, 40, 40, 20];

class MenuItem {
  String name;
  IconData icon;
  MenuItem(this.name, this.icon);
}

List<MenuItem> menuList = <MenuItem>[
  MenuItem('月曜日', Icons.filter_1),
  MenuItem('火曜日', Icons.filter_2),
  MenuItem('水曜日', Icons.filter_3),
  MenuItem('木曜日', Icons.filter_4),
  MenuItem('金曜日', Icons.filter_5),
];

MenuItem selectedMenu = menuList[0];
