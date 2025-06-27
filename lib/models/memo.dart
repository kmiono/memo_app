class Memo {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Memo({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON変換（shared_preferences用）
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      );

  Memo copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
  }) =>
      Memo(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
