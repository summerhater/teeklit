import 'enums.dart';
import 'noti.dart';

///==================== Teekle 모델 정의 ====================
class Teekle {
  final String userId;
  final String teekleId;
  final String taskId;
  final TaskType type;
  final DateTime execDate;
  final String title;
  String? tag;
  bool isDone;
  final Noti noti;
  final String? url;

  Teekle({
    required this.userId,
    required this.teekleId,
    required this.taskId,
    required this.type,
    required this.execDate,
    required this.title,
    required this.tag,
    this.isDone = false,
    required this.noti,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId' : userId,
      'teekleId' : teekleId,
      'taskId' : taskId,
      'type' : type.name,
      'execDate' : execDate.toIso8601String(),
      'title' : title,
      'tag' : tag,
      'isDone' : isDone,
      'noti' : noti.toMap(),
      'url' : url,
    };
  }

  factory Teekle.fromMap(Map<String, dynamic> map) {
    // ✏️ userId를 선택적 필드로 변경 (null 허용)
    if (map['teekleId'] == null ||
        map['taskId'] == null ||
        map['type'] == null ||
        map['execDate'] == null ||
        map['title'] == null ||
        map['noti'] == null) {
      throw Exception('필수 필드 누락: $map');
    }

    return Teekle(
      userId: map['userId'] as String? ?? 'guest',  // ✏️ userId는 선택적
      teekleId: map['teekleId'] as String? ?? '',
      taskId: map['taskId'] as String? ?? '',
      type: TaskType.values.firstWhere(
            (e) => e.name == map['type'],
        orElse: () => TaskType.todo,
      ),
      execDate: DateTime.tryParse(map['execDate'] as String? ?? '') ?? DateTime.now(),
      title: map['title'] as String? ?? '제목 없음',
      tag: map['tag'] as String?,
      isDone: (map['isDone'] as bool?) ?? false,
      noti: map['noti'] != null
          ? Noti.fromMap(map['noti'] as Map<String, dynamic>)
          : Noti(hasNoti: false),
      url: map['url'] as String?,
    );
  }

}

