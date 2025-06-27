import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memo_app/providers/memo_provider.dart';

class MemoEditScreen extends StatefulWidget {
  final Memo? memo;

  const MemoEditScreen({super.key, this.memo});

  @override
  State<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memo?.title ?? '');
    _contentController =
        TextEditingController(text: widget.memo?.content ?? '');

    // 自動保存の設定
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(Duration(seconds: 2), _autoSave);
  }

  void _autoSave() {
    final provider = Provider.of<MemoProvider>(context, listen: false);

    if (widget.memo == null) {
      // 新規作成
      if (_titleController.text.isNotEmpty ||
          _contentController.text.isNotEmpty) {
        provider.createMemo(_titleController.text, _contentController.text)
      }
    }else{
      // 更新
      provider.updateMemo(
        widget.memo!.id,
        _titleController.text,
        _contentController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo == null ? '新しいメモ' : 'メモを編集'),
        actions: [
          if(widget.memo != null)
          IconButton(icon: Icon(Icons.delete),
          onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'タイトル',
                border: InputBorder.none,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              minLines: 1,
            ),
            Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'メモを入力してください...',
                  border: InputBorder.none,
                ),
                maxLength: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),),
          ],
        ),
      ),
    );
  }
}
