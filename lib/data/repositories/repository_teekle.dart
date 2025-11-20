import 'package:teeklit/domain/model/teekle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeekleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'teekles';

  /// Teekle 리스트 일괄 저장 메소드 (task랑 상관없이 한 폴더에 일괄 저장 됩니다)
  Future<void> createTeekles(List<Teekle> teekles) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (Teekle teekle in teekles) {
        DocumentReference ref =
        _firestore.collection(_collectionName).doc(teekle.teekleId.toString());
        batch.set(ref, teekle.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Teekle 생성 실패: $e');
    }
  }

  /// Teekle 단일 저장
  Future<void> createTeekle(Teekle teekle) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(teekle.teekleId.toString())
          .set(teekle.toMap());
    } catch (e) {
      throw Exception('Teekle 생성 실패: $e');
    }
  }

  /// Teekle 조회
  Future<Teekle?> getTeekle(int teekleId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(teekleId.toString())
          .get();

      if (doc.exists) {
        return Teekle.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Teekle 조회 실패: $e');
    }
  }

  /// TaskID로 Teekle 리스트 조회
  Future<List<Teekle>> getTeeklesByTaskId(int taskId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('taskId', isEqualTo: taskId)
          .get();

      return querySnapshot.docs
          .map((doc) => Teekle.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Teekle 목록 조회 실패: $e');
    }
  }

  /// 특정 날짜의 Teekle 리스트 조회
  Future<List<Teekle>> getTeeklesByDate(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('execDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('execDate', isLessThan: endOfDay.toIso8601String())
          .get();

      return querySnapshot.docs
          .map((doc) => Teekle.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('날짜별 Teekle 조회 실패: $e');
    }
  }

  /// Teekle 업데이트
  Future<void> updateTeekle(Teekle teekle) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(teekle.teekleId.toString())
          .update(teekle.toMap());
    } catch (e) {
      throw Exception('Teekle 업데이트 실패: $e');
    }
  }

  /// Teekle 삭제
  Future<void> deleteTeekle(int teekleId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(teekleId.toString())
          .delete();
    } catch (e) {
      throw Exception('Teekle 삭제 실패: $e');
    }
  }

  /// TaskID로 해당 Teekle들 일괄 삭제
  Future<void> deleteTeeklesByTaskId(int taskId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('taskId', isEqualTo: taskId)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('TaskID별 Teekle 삭제 실패: $e');
    }
  }
}
