import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teeklit/domain/model/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'tasks';

  /// Task 저장 메소드 : Task 생성 시 호출되면서 Firestore에 저장됨
  Future<String> createTask(Task task) async {
    try {
      await _firestore.collection(_collectionName).doc(task.taskId).set(
        task.toMap(),
        SetOptions(merge: true),
      );
      return task.taskId;
    } catch (e) {
      throw Exception('Task 생성 실패: $e');
    }
  }

  /// Task 조회
  Future<Task?> getTask(String taskId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(taskId)
          .get();

      if (doc.exists) {
        return Task.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Task 조회 실패: $e');
    }
  }

  /// Task 업데이트
  Future<void> updateTask(Task task) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(task.taskId)
          .update(task.toMap());
    } catch (e) {
      throw Exception('Task 업데이트 실패: $e');
    }
  }

  /// Task 삭제
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection(_collectionName).doc(taskId).delete();
    } catch (e) {
      throw Exception('Task 삭제 실패: $e');
    }
  }
}