# View Model에서의 Mixin 사용

# Architecture Design: MVVM 최적화 & Logic Separation

> MVVM 아키텍처의 한계(필수적 복잡성)를 극복하기 위한 설계적 결단(Trade-off)
>
> - [내 티클]의 세부 기능 중 하나인 '반복 티클 생성' 과정에서 발생한 **ViewModel 비대화**(Massive ViewModel) 문제를 해결하기 위해, Dart의 **Mixin Pattern**을 활용한 **역할 분리**(Separation of Concerns) 전략을 채택했습니다.

## 1. 과제: ViewModel의 역할과 딜레마

### 1.1. 설계 배경 (Context)

Teeklit은 유지보수성과 테스트 용이성을 확보하기 위해 **MVVM**(Model-View-ViewModel) 아키텍처를 기반으로 설계되었습니다. `TeekleSettingViewModel`은 사용자가 설정한 목표(Task)를 기반으로 실제 수행해야 할 티클(Teekle) 인스턴스를 생성하는 핵심 책임을 가집니다.

### 1.2. 문제 직면: ViewModel 비대화(Massive ViewModel) 근거

개발 초기, `TeekleSettingViewModel`은 다음과 같은 다층적인 책임을 동시에 수행하며 비대해졌습니다.

1. **State Management:** UI 상태 관리 (제목, 날짜, 태그 선택 등)
2. **Data Persistence:** Repository를 통한 DB CRUD 작업 (Task, Teekle 생성/삭제 관리)
3. **Complex Business Logic:** 사용자의 반복 설정(e.g. 주간/월간, 매주 월/수/금, 매월 20일 등)을 해석하여 실제 날짜 리스트를 산출하는 알고리즘 연산

특히, '반복 날짜 계산 로직'은 단순한 상태 변경이 아닌 순수 연산 영역임에도 불구하고 ViewModel 내부에 혼재되어 있었습니다. 이는 코드의 가독성을 저하시킬 뿐만 아니라, ViewModel의 본질인 'View를 위한 상태 매핑' 역할을 모호하게 만들었습니다.

---

## 2. **아키텍처 결정**: Mixin을 통한 로직 분리

저희는 이 문제를 해결하기 위해 **Mixin Pattern**을 도입했습니다.  
별도의 Helper Class나 Utility Class로 분리하는 대신 `mixin`을 선택한 이유는 다음과 같습니다.

- **선택의 근거:**
    - **Readability:** ViewModel이 날짜 계산 기능을 마치 자신의 메서드인 것처럼 자연스럽게 호출할 수 있어 코드의 흐름이 끊기지 않아 가독성을 높이는 장점이 있습니다.
    - **Stateless Logic:** 날짜 계산 로직은 상태를 가지지 않는 순수 Function에 가깝습니다. 상속의 깊이를 늘리지 않으면서 기능을 수평적으로 확장하기에 Mixin이 적합하다고 판단했습니다.
    - **Reusability:** 추후 다른 ViewModel이나 서비스에서 동일한 날짜 계산 로직이 필요할 경우, 손쉽게 재사용이 가능합니다.

### 2.1. System Flow 재정립

Mixin 도입 후, ViewModel 내부에서의 데이터 흐름은 다음과 같이 재구조화 되었습니다.

| **단계** | **주체 (Actor)** | **역할 (Responsibility)** | **비고** |
| --- | --- | --- | --- |
| **Step 1** | User / View | Task 설정 (반복 규칙 정의) | Input |
| **Step 2** | **Mixin (Logic)** | **반복 규칙 해석 및 실행 날짜(N) 산출** | **Pure Calculation** |
| **Step 3** | ViewModel | 산출된 날짜로 Teekle 인스턴스 $N$개 생성 | Instance Mapping |
| **Step 4** | Repository | Task 및 Teekle 리스트 DB 저장 | Persistence |

---

## 3. **구현 상세 설명**

### 3.1. The Engine: `TeekleSettingUtils` (Mixin)

복잡한 날짜 연산 로직을 `TeekleSettingUtils`로 완벽하게 격리했습니다.  
아래 코드는 주간/월간 반복의 계산을 처리하는 핵심 알고리즘의 요약입니다.

```dart
// domain/utils/teekle_setting_utils.dart

mixin TeekleSettingUtils {

  /// [Core Logic] 반복 규칙에 따른 실행 날짜 리스트 반환
  /// 순수 입력(startDate, endDate, options)만으로 결과를 도출하는 함수입니다.
  List<DateTime> calculateRepeatExecutionDates({
    required DateTime startDate,
    required DateTime endDate,
    required RepeatUnit repeatUnit,
    required int interval,
    required List<DayOfWeek>? daysOfWeek,
  }) {
    // RepeatUnit(월간/주간)에 따라 계산 로직 분기
    if (repeatUnit == RepeatUnit.weekly) {
      return calculateWeeklyRepeatDates(...);
    } else if (repeatUnit == RepeatUnit.monthly) {
      return calculateMonthlyRepeatDates(...);
    }
    return [];
  }

  /// [Algorithm] 주간 / 월간 반복 날짜 계산
  calculateWeeklyRepeatDates() {...}
  calculateMonthlyRepeatDates() {...}
}
```

### 3.2. The Consumer: TeekleSettingViewModel

ViewModel은 with TeekleSettingUtils를 통해 해당 기능을 장착합니다.
이제 ViewModel은 '어떻게 계산하는가'를 고민하지 않고, '계산된 결과로 무엇을 할 것인가'에만 집중합니다.

```dart
// ui/view_model/teekle_setting_view_model.dart

class TeekleSettingViewModel extends ChangeNotifier with TeekleSettingUtils {
  // ... (State 변수들)

  /// Teekle 생성 메서드
  List<Teekle> _generateTeekles(Task task, Tag? tag){
    List<Teekle> teekles = [];

    // Case 1: 반복 없음(단일 Teekle 생성)
    if (!task.repeat.hasRepeat) {...}

    // Case 2: 반복 있음(Mixin의 메서드를 호출하여 복잡한 계산을 위임)
    List<DateTime> execDates = calculateRepeatExecutionDates(
      startDate: task.startDate,
      endDate: task.endDate,
      repeatUnit: task.repeat.unit!,
      interval: task.repeat.interval!,
      daysOfWeek: task.repeat.daysOfWeek,
    );

    // 계산된 날짜만큼 순회하며 Teekle 인스턴스 생성 (Mapping)
    for (DateTime execDate in execDates) {
      teekles.add(...);
    }
    return teekles;
  }
}
```

## 4. **Conclusion: 설계의 가치**
>초기 개발 단계에서의 편의성을 위해 ViewModel에 모든 로직을 작성하게 되었습니다. 하지만, '역할의 경계'를 명확히 하는 것이야말로 프로젝트가 장기적으로 생존하고 확장될 수 있는 기반이 됩니다. Mixin의 도입은 단순한 코드 이동이 아닌, 시스템의 최적화를 갖추기 위한 아키텍처적 투자였습니다.

위와 같은 로직 분리 과정을 통해 다음과 같은 이점을 확보했습니다.

- Cohesion (응집도 향상): ViewModel은 UI 상태 관리에, Mixin은 날짜 연산에 집중함으로써 각 모듈의 응집도가 높아졌습니다.
- Testability (테스트 용이성): UI 의존성이 없는 TeekleSettingUtils에 대해 독립적인 Unit Test 작성이 가능해져, 복잡한 날짜 연산의 신뢰성을 확보했습니다.
- Readability (가독성): ViewModel 코드에서 수십 줄의 연산 로직이 제거되어, 비즈니스 로직의 흐름을 한눈에 파악할 수 있게 되었습니다.