import 'dart:convert';

import 'package:memo_app/models/memo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _memoKey = 'memo';

  // メモ一覧を取得
  Future<List<Memo>> getMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final memoJson = prefs.getStringList(_memoKey) ?? [];

    return memoJson.map((json) => Memo.fromJson(jsonDecode(json))).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // メモを保存
  Future<void> saveMemo(List<Memo> memos) async {
    final prefs = await SharedPreferences.getInstance();
    final memoJson = memos.map((memo) => jsonEncode(memo.toJson())).toList();

    await prefs.setStringList(_memoKey, memoJson);
  }
}
