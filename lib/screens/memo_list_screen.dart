import 'package:flutter/material.dart';
import 'package:memo_app/providers/memo_provider.dart';

class MemoListScreen extends StatelessWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メモ'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Consumer<MemoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.memos.isEmpty) {
            return EmptySate();
          }

          return ListView.builder(
            itemCount: provider.memos.length,
            itemBuilder: (context, index) {
              return MemoCard(memo: provider.memos[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _nabigateToEditor(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
