import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yotei/sonota_database.dart';
import 'package:yotei/sonota_variable.dart';
import 'package:yotei/sonota_addScreen.dart';

class SonotaScreem extends StatefulWidget {
  @override
  _SonotaScreemState createState() => _SonotaScreemState();
}

class _SonotaScreemState extends State<SonotaScreem> {
  late Database sonotaDB;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  //この処理をinitStateに置くことはできない
  Future<void> initDB() async {
    sonotaDB = await initSonotaDB();
    loadSonota();
  }

  Future<void> loadSonota() async {
    sonotas = await getSonota(sonotaDB);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('その他の予定')),
      body: ListView.builder(
        itemCount: sonotas.length,
        itemBuilder: (context, index) {
          var sonota_row = sonotas[index];
          var minute = '';
          //0を00にする
          if(sonota_row['minute']==0){
            minute = '00';
          }else{
            minute = sonota_row['minute'].toString();
          }
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            //@1-3カードの色の設定
            color: Color.fromARGB(255, 150, 200, 247),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  sonota_row['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text(
                    'メモ：${sonota_row['memo']}\n日時：${sonota_row['year']}年${sonota_row['month']}月${sonota_row['day']}日${sonota_row['hour']}:$minute',
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
                    await deleteSonota(sonotaDB, sonota_row['id']);
                    loadSonota();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddSonotaScreen();
              },
            ),
          );
          //pop処理をawaitで待つことで、遷移先から戻ってきたときに処理を実行できます。
          sonotas = await getSonota(sonotaDB);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
