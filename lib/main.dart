import 'package:flutter/material.dart';
import 'package:memo_app/memoDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'メモアプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'メモアプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> memos = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMemos();
  }

// ローカルストレージ読込
  void loadMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memos = prefs.getStringList('memos') ?? [];
    });
  }

// メモ保存
  void saveMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('memos', memos);
  }

// メモ追加
  void addMemo(String text) {
    setState(() {
      memos.add(text);
      controller.clear();
      saveMemos();
    });
  }

  // メモ削除
  void deleteMemo(int index) {
    setState(() {
      memos.removeAt(index);
      saveMemos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'メモを入力'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      addMemo(controller.text);
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(memos[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemoDetailPage(
                          memo: memos[index],
                          index: index,
                          onUpdate: (updatedMemo, idx) {
                            setState(() {
                              memos[idx] = updatedMemo;
                              saveMemos();
                            });
                          },
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteMemo(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
