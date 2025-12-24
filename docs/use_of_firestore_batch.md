# Firebase Firestore : batch의 사용

# DB Persistence: Firestore WriteBatch의 전략적 채택

> 효율성과 일관성 사이의 교차점: 반복 작업을 성능 저하 없이 수행하기
>
> - [내 티클]의 세부 기능 중 하나인 '반복 티클 생성' 기능에서 데이터 무결성(Data Integrity)을 최우선으로 확보하면서도, 사용자에게 빠른 응답성을 제공하기 위해 Firestore의 **WriteBatch** 패턴을 채택했습니다.

## 1. 과제: 반복 작업의 데이터 무결성 요구

### 1.1. 설계 배경 (Context)

[내 티클] 기능은 **Task**(반복, 태그 등 사용자가 설정한 데이터가 담긴 Template)와 해당 규칙에 따라 생성된 **Teekle**(개별 실행 일정)이라는 두 가지 핵심 Data Model을 중심으로 설계되었습니다. 여기서 사용자가 설정한 반복 패턴을 해석하여 **N개**의 `Teekle` 인스턴스를 생성하고 Firestore DB에 저장하게 됩니다.

### 1.2. 문제 직면: 원자성(Atomicity) 제약 조건

[내 티클]에서 사용자가 반복 설정을 적용하면, 시스템은 계산된 날짜만큼 순회하여 **N개의 Teekle 인스턴스를 생성**합니다. 이때 생성된 Teekle들은 하나의 반복 규칙으로 묶인 하나의 논리적 단위(반복 패턴)를 구성하며, 사용자가 보기에는 “한 번의 생성 작업”으로 인식됩니다.

N개의 Teekle 인스턴스를 생성할 때, 만약 개별 단건 쓰기(`add()`와 같은 single writes)로 처리할 경우 중간에 일부만 저장되는 ‘부분 생성’의 가능성이 존재하며, 이는 반복 패턴의 구조 자체를 무너뜨립니다.

반복 설정된 티클을 사용자가 수정하는 경우에도 동일한 원칙이 적용됩니다. 반복 설정이 적용된 티클을 사용자가 ‘수정하기’ 페이지에서 수정하면, 변경된 설정은 **선택한 Teekle의 날짜 이후의 모든 Teekle에 재적용**되어야 합니다. 이 과정은 실제로는 아래와 같은 복합적인 작업으로 처리됩니다.

<aside>

1. 기존 반복 패턴에 속한 **해당 Teekle 이후의 Teekle들을 모두 삭제**
2. 사용자에 의해 수정된 설정값을 기반으로 **N개의 새로운 Teekle을 다시 생성**
3. 이를 다시 Firestore에 **저장**

</aside>

즉, 사용자는 UI에서 “수정하기”로 인지하지만, 실제 내부적으로는 기존 N개의 문서를 삭제하고 새로운 N개를 재생성하는 복합 작업이 수행되는 구조입니다.

반복 패턴은 경우에 따라 매우 많은 수의 Teekle을 생성할 수 있으므로, 생성과 수정 모두에서 데이터의 일관성(Consistency)과 **반복 패턴의 완전성**을 반드시 보장해야 합니다.

이때 단 하나의 문서라도 저장에 실패한다면, 반복 패턴을 이루는 데이터 집합이 불완전해져 사용자에게 잘못된 일정 목록이 노출됩니다. 즉, **N개의 쓰기 작업은 반드시 원자성(Atomicity)을 보장**해야 합니다.

---

## 2. 구현 전략: WriteBatch를 통한 원자성 확보

**Teekle 생성/수정 과정은 모두 동일하게 다수의 문서를 대상으로 한 대량 쓰기 작업으로 구성됩니다.**

반복 규칙을 해석해 N개의 Teekle 인스턴스를 생성하거나, 수정 시 기존 인스턴스를 모두 삭제한 뒤 동일 규칙으로 다시 생성하는 방식이기 때문에, 기존 문서를 조회(Read)하여 조건을 비교하거나 데이터를 확인하는 단계가 필요하지 않습니다.

즉, 이 작업은 **읽기(Read)를 건너뛰고 순수하게 생성(Create) 또는 삭제(Delete) 작업만 수행하는 구조**이며, 중간에 하나라도 실패하면 데이터가 깨지는 것을 방지하기 위해 **전체 과정을 원자적(All-or-Nothing)으로 처리**해야 합니다.

Firestore에서 원자적 쓰기 작업을 보장하는 `runTransaction`과 `WriteBatch` 중, 프로젝트의 특성을 고려해 `WriteBatch`를 채택했습니다.

### 2.1. WriteBatch vs Transaction 비교 분석
<img width="796" height="521" alt="스크린샷 2025-12-24 오후 3 38 21" src="https://github.com/user-attachments/assets/bfe15d82-aa4d-41ff-8c80-00c4c047d438" />



| **특징** | **WriteBatch** | **Transaction** |
| --- | --- | --- |
| **핵심 목적** | 다수의 쓰기/업데이트/삭제의 **일괄 처리 (Bulk Operations)** | **읽은 데이터 기반 쓰기 (Read-Modify-Write)** |
| **원자성** | **보장:** 커밋 시 모든 작업이 성공하거나 실패 | **보장:** 모든 작업이 성공하거나 실패 |
| **격리성** | **X.** 동시 접근 제어 및 읽기 검증 미제공 | **O.** 동시 변경으로부터 보호 |
| **효율** | **매우 빠름.** 단 1회의 네트워크 왕복(RTT)으로 N개 작업 처리 | **느림.** 읽기 오버헤드 및 충돌 시 재시도 필요 |
| **주 사용처** | 클라이언트에서 생성된 N개의 데이터 일괄 저장 | 카운터, 잔액 등 동시성 제어 필수 로직 |

### 2.2. WriteBatch 채택의 근거 (Rationale)

`WriteBatch`를 선택한 근본적인 이유는 [내 티클] 기능의 Teekle 생성/수정 로직이 **`Transaction`의 핵심 기능인 격리성(Isolation)을 필요로 하지 않기 때문**입니다.

1. **Read-Modify-Write 프로세스 미적용**
    - Teekle 생성 시 문서 ID(`teekleId`)는 클라이언트에서 `uuid.v4()`로 **새로 생성**됩니다.
    - 공유 상태를 읽고 수정해야 할 필요가 없어 동시성 충돌 검증이 불필요합니다.
2. **성능 최적화**
    - N개의 Teekle을 `WriteBatch`로 묶어 **단 1회**의 네트워크 왕복(RTT)으로 처리합니다.
    - 수백 개의 Teekle 생성 시 UX에 결정적인 이점을 제공합니다.
3. **코드 복잡도 감소**
    - 재시도 로직이 없는 단순한 배치 구조로 가독성과 유지보수성이 향상됩니다.

---

## 3. 구현 상세 설명

### 3.1. The Actor: `TeekleService`의 `WriteBatch` 활용

`TeekleService`는 반복 패턴에 따라 생성된 `Teekle` 리스트를 전달받아 `WriteBatch`를 구성하고, 모든 작업을 등록한 뒤 `commit()`을 호출합니다.

```dart
// data/service/teekle_service.dart

class TeekleService {
  // ... (생략)

  /// Teekle 리스트 일괄 저장 메소드
  Future<void> createTeekles(List<Teekle> teekles) async {
    try {
      WriteBatch batch = _firestore.batch(); // 1. Batch 시작

      for (Teekle teekle in teekles) {
        DocumentReference ref = _firestore
            .collection(_collectionName)
            .doc(teekle.teekleId.toString());
        batch.set(ref, teekle.toMap()); // 2. Batch에 쓰기 작업 추가
      }

      await batch.commit(); // 3. 단 한번의 네트워크 호출로 원자적 커밋
    } catch (e) {
      // 실패 시 전체 Rollback으로 Atomicity 보장
      throw Exception('Teekle 생성 실패: $e');
    }
  }

  /// 수정하기 (특정 날짜 이후 Teekle 일괄 삭제)
  Future<void> deleteTeeklesFromDateByTaskId({ ... }) async {
    // ... (쿼리 실행)
    WriteBatch batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
```

## 4. Conclusion: 설계의 가치

`WriteBatch`의 도입은 [내 티클] 기능의 사용자 경험 측면에서 DB 계층의 **안정성과 효율성을 한번에 제공**할 수 있도록 돕습니다.

- **일관된 반복 경험 (Atomicity):** 복잡한 반복 생성 및 수정 로직에서도 데이터가 누락되거나 불완전해지지 않음을 보장합니다.
- **고성능 Persistence (Performance):** N개의 작업을 단 1회 네트워크 호출로 처리함으로써, 수백 개의 일정이 생성될 때에도 사용자가 지연 없이 다음 단계로 넘어갈 수 있는 고성능을 제공합니다.
- **명확한 로직:** 시스템의 요구사항(Bulk Write)에 맞는 적절한 도구(`WriteBatch`)를 사용함으로써, 코드가 의도와 목표를 명확하게 드러냅니다.
