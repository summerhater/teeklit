# View Model에서의 Mixin 사용

# 설계 방식: MVVM 구조 최적화와 로직 나누기

> MVVM 패턴 구조가 가진 한계(필수적 복잡성)를 해결하기 위한 설계상의 선택
>
> - 앱 '티클릿'의 주요기능인 '반복 티클 생성'을 구현하는 과정에서 뷰모델이 너무 커지는 문제를 마주했습니다 **(ViewModel 비대화)**. 이를 해결하고자 다트(Dart) 언어의 믹스인(Mixin) 기능을 활용해, 각자가 맡은 역할을 명확히 나누는 **역할 분리**(Separation of Concerns) 전략을 세웠습니다.

## 1. 과제: ViewModel의 역할과 고민

### 1.1. 설계 배경 (Context)

Teeklit은 유지보수성과 테스트하기 좋은 환경을 만들고자 **MVVM**(Model-View-ViewModel) 아키텍처를 기반으로 설계되었습니다. TeekleSettingViewModel은 사용자가 정한 목표를 바탕으로 실제 수행할 '티클'을 만들어내는 핵심 역할을 맡습니다.

### 1.2. 문제 상황: ViewModel이 너무 무거워진 이유

개발 초기에는 TeekleSettingViewModel이 너무 많은 일을 한꺼번에 처리했습니다.

1. **상태 관리 :** 화면에 보여줄 제목, 날짜, 태그 선택 같은 상태를 돌봅니다.
2. **데이터 저장 :** Repository를 통한 DB CRUD 작업을 관리합니다 (Task, Teekle 생성/삭제 관리)
3. **복잡한 비즈니스 로직 계산 :** 사용자가 설정한 반복 규칙(매주 월/수/금, 매달 20일 등)을 분석해 실제 날짜 목록을 뽑아내는 계산을 수행합니다.

특히 '반복 날짜 계산'은 단순히 상태를 바꾸는 것이 아니라 순수 연산이 필요한 영역임에도 뷰모델 안에 섞여 있었습니다. 이 때문에 코드의 가독성이 낮아지고, 뷰모델 본연의 역할인 '화면(View)에 보여줄 상태 전달하기'가 흐릿해지는 문제가 생겼습니다.

---

## 2. **아키텍처 결정**: Mixin으로 계산 로직 분리하기

이 문제를 풀기 위해 `mixin`(Mixin) 방식을 도입했습니다. 단순히 도구 모음 클래스를 따로 만드는 대신 `mixin`을 선택한 이유는 다음과 같습니다.

- **선택의 근거:**
    - **읽기 편한 코드 :** ViewModel이 날짜 계산 기능을 마치 자신의 메서드인 것처럼 자연스럽게 호출할 수 있어 코드의 흐름이 끊기지 않아 가독성을 높일 수 있습니다.
    - **상태 없는 로직 :** 날짜 계산은 입력값에 따라 결과만 내보내는 순수한 계산 과정입니다. 복잡한 상속 관계를 만들지 않고도 기능을 옆으로 덧붙이기에 `mixin`이 가장 알맞다고 판단했습니다.
    - **재사용성 :** 나중에 다른 곳에서 날짜 계산 기능이 필요할 때, 언제든 손쉽게 다시 가져다 쓸 수 있습니다.

### 2.1. System Flow 재정립

`mixin`을 도입한 후, 데이터는 다음과 같이 짜임새 있게 흐르게 되었습니다.

| **단계** | **주체 (Actor)** | **역할 (Responsibility)** | **비고** |
| --- | --- | --- | --- |
| **Step 1** | User / View | Task 설정 (반복 규칙 정의) | Input |
| **Step 2** | **Mixin (Logic)** | **반복 규칙 해석 및 실행 날짜(N) 산출** | **Pure Calculation** |
| **Step 3** | ViewModel | 산출된 날짜로 Teekle 인스턴스 $N$개 생성 | Instance Mapping |
| **Step 4** | Repository | Task 및 Teekle 리스트 DB 저장 | Persistence |

---

## 3. **상세 구현 내용**

### 3.1. 계산 엔진: TeekleSettingUtils(Mixin)

복잡한 날짜 연산 로직을 이 `TeekleSettingUtils` mixin 안에 따로 모아 두었습니다.
주간이나 월간 반복을 처리하는 핵심 알고리즘을 담고 있습니다.

```dart
// 반복 설정 도구 믹스인
// domain/utils/teekle_setting_utils.dart

mixin TeekleSettingUtils {


  /// [핵심 로직] 반복 규칙에 맞춰 실행 날짜 목록을 돌려줍니다.
  /// 시작일, 종료일, 옵션만 넣으면 결과를 바로 계산해내는 함수입니다.
  List<DateTime> calculateRepeatExecutionDates({
    required DateTime startDate,
    required DateTime endDate,
    required RepeatUnit repeatUnit,
    required int interval,
    required List<DayOfWeek>? daysOfWeek,
  }) {
    // 반복 단위(주간/월간)에 따라 계산 방식을 나눕니다.
    if (repeatUnit == RepeatUnit.weekly) {
      return calculateWeeklyRepeatDates(...);
    } else if (repeatUnit == RepeatUnit.monthly) {
      return calculateMonthlyRepeatDates(...);
    }
    return [];
  }

  // 주간 / 월간 날짜를 계산하는 세부 알고리즘들...
  calculateWeeklyRepeatDates() {...}
  calculateMonthlyRepeatDates() {...}
}
```

### 3.2. 기능 활용: TeekleSettingViewModel

ViewModel은 `with TeekleSettingUtils`를 통해 이 mixin 기능을 장착합니다.
이제 뷰모델은 '어떻게 계산할지' 고민하지 않고, '계산된 결과로 무엇을 할지'에만 온전히 집중합니다.

```dart
// 반복 설정 뷰모델
// ui/view_model/teekle_setting_view_model.dart

class TeekleSettingViewModel extends ChangeNotifier with TeekleSettingUtils {
  // ... (화면 상태 변수들)

  /// 티클을 생성하는 메서드
  List<Teekle> _generateTeekles(Task task, Tag? tag){
    List<Teekle> teekles = [];

    // Case 1: 반복이 없을 때 - 단일 티클 생성
    if (!task.repeat.hasRepeat) {...}

    // Case 2: 반복이 있을 때 - 믹스인에게 복잡한 계산을 맡기고 날짜 목록을 받음
    List<DateTime> execDates = calculateRepeatExecutionDates(
      startDate: task.startDate,
      endDate: task.endDate,
      repeatUnit: task.repeat.unit!,
      interval: task.repeat.interval!,
      daysOfWeek: task.repeat.daysOfWeek,
    );

    // 계산된 날짜만큼 순회하며 티클 인스턴스 생성
    for (DateTime execDate in execDates) {
      teekles.add(...);
    }
    return teekles;
  }
}
```

## 4. **맺음말: 이 설계가 주는 가치**
>처음에는 편의를 위해 뷰모델에 모든 코드를 몰아넣기도 했습니다. 하지만 역할의 경계를 분명히 나누는 것이야말로 프로젝트가 단단하게 성장할 수 있는 밑바탕이 된다고 믿습니다. mixin을 도입한 것은 단순히 코드를 옮긴 것이 아니라, 더 효율적인 시스템을 만들기 위한 아키텍처적 투자였습니다.

이 과정을 통해 다음과 같은 성과를 얻었습니다.

- 집중도 향상 (cohension) : ViewModel은 화면 관리에, Mixin은 날짜 계산에만 집중하여 각 모듈이 훨씬 탄탄해졌습니다.
- 테스트하기 좋은 구조 (Testability) : 화면과 상관없이 날짜 계산 기능만 따로 떼어 확인(Unit Test)할 수 있어 로직의 신뢰성을 높였습니다.
- 가독성 (Readability) : ViewModel에서 수십 줄의 복잡한 계산 코드가 사라져, 전체적인 비즈니스 로직의 흐름을 한눈에 파악할 수 있습니다.
