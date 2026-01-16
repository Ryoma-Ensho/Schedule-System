//通知idを曜日、時限によって生成するメソッド
Future<int> getId(String day, int period) async {
  int id = 0;
  //月曜日なら：1～5
  if (day == "月曜日") {
    id = period;
    //火曜日なら6~10
  } else if (day == "火曜日") {
    id = period + 5;
    //水曜日なら11～15
  } else if (day == "水曜日") {
    id = period + 10;
  } else if (day == "木曜日") {
    id = period + 15;
  } else if (day == "金曜日") {
    id = period + 20;
  }
  return id;
}

Future<(int, int)> getSubjectTime(int period) async {
  int hour = 0;
  int minute = 0;
  //1時限なら、9時に設定
  if (period == 1) {
    hour = 9;
    minute = 0;
  } else if (period == 2) {
    hour = 11;
    minute = 0;
  } else if (period == 3) {
    hour = 13;
    minute = 40;
  } else if (period == 4) {
    hour = 15;
    minute = 40;
  } else {
    hour = 17;
    minute = 30;
  }
  return (hour, minute);
}

Future<String> getPlace(String classroom) async {
  String place = "";

  List<RegExp> building = <RegExp>[
    RegExp(r'[SN].'),
    RegExp(r'OA.'),
    RegExp(r'2.'),
    RegExp(r'3.'),
    RegExp(r'8.'),
    RegExp(r'12.'),
    RegExp(r'パソコン教室.'),
    RegExp(r'パソコン演習室.'),
    RegExp(r'42.'),
    RegExp(r'5.'),
    RegExp(r'アリーナ.'),
  ];

  if (classroom.startsWith(building[0])) {
    //例：N203
    place = "(1号館${classroom.substring(0, 1)}棟${classroom.substring(1, 2)}階)";
  }
  
  if (classroom.startsWith(building[1])) {
    //例：OA教室1
    place = "(1号館S棟6階)";
  }
  
  if (classroom.startsWith(building[2])) {
    place = "(2号館${classroom.substring(1, 2)}棟${classroom.substring(2, 3)}階)";
  }

  if (classroom.startsWith(building[3])) {
    //例：3403
    place = "(3号館${classroom.substring(1, 2)}階)";
  }
  
  if (classroom.startsWith(building[4])) {
    place = "(8号館${classroom.substring(2, 3)}階)";
  } 

  if (classroom.startsWith(building[5])) {
    place = "(12号館${classroom.substring(2, 3)}階)";
  } 
  
  if (classroom.startsWith(building[6])) {
    if (classroom == "パソコン教室4") {
      place = "中央会館3階";
    } else {
      place = "中央会館4階";
    }
  }

  if (classroom.startsWith(building[7])) {
    place = "中央会館3階";
  } 

  if (classroom.startsWith(building[8])) {
    place = "中央会館4階";
  } 

  if (classroom.startsWith(building[9])) {
    place = "中央会館5階";
  }

  if (classroom.startsWith(building[10])) {
    place = "大楠アリーナ2022";
  }

  return place;
}
