import 'package:flutter/material.dart';
import 'package:memo_app/models/memo.dart';
import 'package:memo_app/service/storage_service.dart';

class MemoProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Memo> _memos = [];
  String _serchQuery = '';
  bool _isLoading = false;

  List<Memo> get memos {
    if (_serchQuery.isEmpty) {
      return _memos;
    }

    return _memos
        .where((memo) =>
            memo.title.toLowerCase().contains(_serchQuery.toLowerCase()) ||
            memo.content.toLowerCase().contains(_serchQuery.toLowerCase()))
        .toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _serchQuery;

  // 初期化
  Future<void> Memos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _memos = await _storageService.getMemos();
    } catch (e) {
      debugPrint('メモの取得に失敗しました: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // メモ作成
  Future<void> createMemo(String title, String content) async {
    final memo = Memo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'タイトルなし' : title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _memos.insert(0, memo);
    await _saveMemos();
    notifyListeners();
  }

  // メモ更新
  Future<void> updateMemo(String id, String title, String content) async {
    final index = _memos.indexWhere((memo) => memo.id == id);
    if (index == -1) return;

    _memos[index] = _memos[index].copyWith(
      title: title.isEmpty ? 'タイトルなし' : title,
      content: content,
      updatedAt: DateTime.now(),
    );
    // 更新されたメモを先頭に移動
    final updatedMemo = _memos.removeAt(index);
    _memos.insert(0, updatedMemo);
    await _saveMemos();
    notifyListeners();
  }

  // メモ削除
  Future<void> deleteMemo(String id) async {
    _memos.removeWhere((memo) => memo.id == id);
    await _saveMemos();
    notifyListeners();
  }

  // メモ検索
  void searchMemo(String query) {
    _serchQuery = query;
    notifyListeners();
  }

  // メモ一覧を保存
  Future<void> _saveMemos() async {
    await _storageService.saveMemo(_memos);
  }
}
