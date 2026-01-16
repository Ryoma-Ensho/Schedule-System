import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yotei/class_addScreen.dart';
import 'package:yotei/class_database.dart';
import 'package:yotei/class_noti.dart';
import 'package:yotei/class_variable.dart';

class ClassScreem extends StatefulWidget {
  @override
  _ClassScreemState createState() => _ClassScreemState();
}

class _ClassScreemState extends State<ClassScreem> {
  late Database subjectDB;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  //この処理をinitStateに置くことはできない
  Future<void> initDB() async {
    subjectDB = await initSubjectDB();
    loadSubject();
  }

  Future<void> loadSubject() async {
    subjects = await getSubject(subjectDB, selectedMenu.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMenu.name}の予定'),
        actions: <Widget>[
          PopupMenuButton(
            tooltip: '曜日を選択',
            initialValue: selectedMenu,
            onSelected: (MenuItem value) {
              setState(() {
                selectedMenu = value;
              });
              loadSubject();
            },
            itemBuilder: (context) {
              return menuList.map((MenuItem menu) {
                return PopupMenuItem(
                  value: menu,
                  child: ListTile(
                    leading: Icon(menu.icon),
                    title: Text(menu.name),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          var subject_row = subjects[index];
          if (subject_row['day'] == selectedMenu.name) {
            return Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              //@1-3カードの色の設定
              color: Color.fromARGB(255, 150, 200, 247),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    subject_row['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28),
                  ),
                  //時間と教室を表示する
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Text(
                      //8
                      '時間：${subject_row['period']}限 (${subject_row['hour']}時${subject_row['minute']}分)\n教室：${subject_row['classroom']}${subject_row['place']}',
                      style: TextStyle(
                        fontFamily: 'Inter Tight',
                        letterSpacing: 0.0,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await deleteSubject(subjectDB, subject_row['id']);
                      deleteNoti(subject_row['id']);
                      loadSubject();
                    },
                  ),
                ],
              ),
            );
          } else {
            return null;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "授業を追加する",
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddScreen();
              },
            ),
          );
          //pop処理をawaitで待つことで、遷移先から戻ってきたときに処理を実行できます。
          subjects = await getSubject(subjectDB, selectedMenu.name);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
