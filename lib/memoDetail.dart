import 'package:flutter/material.dart';

class MemoDetailPage extends StatefulWidget {
  final String memo;
  final int index;
  final Function(String, int) onUpdate;
  MemoDetailPage(
      {required this.memo, required this.index, required this.onUpdate});

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.memo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('メモ詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'メモ内容',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('保存'),
              onPressed: () {
                widget.onUpdate(controller.text, widget.index);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
