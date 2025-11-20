import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:teeklit/domain/model/enums.dart';
import 'package:teeklit/domain/model/noti.dart';
import 'package:teeklit/domain/model/repeat.dart';
import 'package:teeklit/domain/model/task.dart';
import 'package:teeklit/domain/model/teekle.dart';
import 'package:teeklit/data/repositories/repository_task.dart';
import 'package:teeklit/data/repositories/repository_teekle.dart';

/// 내 티클 관련 상태관리 및 비즈니스 로직까지 한번에 처리.
/// 순서 : Task 생성 → 반복 패턴 계산 → Teekle 자동 생성 → DB 저장

class TeekleSettingViewModel extends ChangeNotifier {
  ///========== Repository ==========
  final TaskRepository _taskRepository = TaskRepository();
  final TeekleRepository _teekleRepository = TeekleRepository();

  ///============= 변수 선언 ============
  DateTime now = DateTime.now();
  static const uuid = Uuid();

  ///투두/운동 이름
  String _title = '';

  ///날짜 설정
  DateTime _selectedDate;

  ///알림 설정
  bool _hasAlarm = false;
  DateTime _selectedAlarmTime;

  ///반복 설정
  bool _hasRepeat = false;
  RepeatUnit? _repeatUnit;
  int? _interval;
  DateTime? _repeatEndDate;
  List<DayOfWeek>? _selectedDaysOfWeek;

  ///태그 설정
  String? _selectedTag;

  TeekleSettingViewModel({DateTime? initDate, DateTime? initAlarmTime})
    : _selectedDate = initDate ?? DateTime.now(),
      _selectedAlarmTime = initAlarmTime ?? DateTime.now(),
      _repeatUnit = null,
      _interval = null,
      _repeatEndDate = null,
      _selectedDaysOfWeek = [],
      _selectedTag = null;

  ///================== 읽기 전용 : getter ==================
  /// 투두/운동 이름 getter
  String get title => _title;

  /// 날짜 getter
  DateTime get selectedDate => _selectedDate;

  /// 알림 getter
  bool get hasAlarm => _hasAlarm;
  DateTime get selectedTime => _selectedAlarmTime;

  ///반복 getter
  bool get hasRepeat => _hasRepeat;
  RepeatUnit? get repeatUnit => _repeatUnit;
  int? get interval => _interval;
  DateTime? get repeatEndDate => _repeatEndDate;
  List<DayOfWeek>? get selectedDaysOfWeek => _selectedDaysOfWeek;

  /// 태그 getter
  String? get selectedTag => _selectedTag;

  ///=============== 상태 변경 메서드 : setter ===============
  ///투두/운동 이름 설정
  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  ///날짜 설정
  void setDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  ///알림 토글 on 일때
  void setAlarm(bool alarmStatus, DateTime newTime) {
    _hasAlarm = alarmStatus;
    _selectedAlarmTime = newTime;
    notifyListeners();
  }

  ///알림 토글 off 일때 부분 초기화
  void clearAlarm() {
    _hasAlarm = false;
    _selectedAlarmTime = DateTime.now();
    notifyListeners();
  }

  ///반복 토글 on 일때
  void setRepeatSetting({
    required bool hasRepeat,
    RepeatUnit? repeatUnit,
    int? interval,
    DateTime? repeatEndDate,
    List<DayOfWeek>? daysOfWeek,
  }) {
    _hasRepeat = hasRepeat;
    _repeatUnit = repeatUnit;
    _interval = interval;
    _repeatEndDate = repeatEndDate;
    _selectedDaysOfWeek = daysOfWeek;
    notifyListeners();
  }

  ///반복 토글 Off 일때 부분 초기화
  void clearRepeatSetting() {
    _hasRepeat = false;
    _repeatUnit = null;
    _interval = null;
    _repeatEndDate = null;
    _selectedDaysOfWeek = [];
    notifyListeners();
  }

  /// 태그 설정
  void setTagSetting(String? selectedTag) {
    _selectedTag = selectedTag;
    notifyListeners();
  }

  void clearAll() {
    ///날짜 설정
    _selectedDate = DateTime.now();

    ///알림 설정
    _hasAlarm = false;
    _selectedAlarmTime = DateTime.now();

    ///반복 설정
    _hasRepeat = false;
    _repeatUnit = null;
    _interval = null;
    _repeatEndDate = null;
    _selectedDaysOfWeek = null;

    ///태그 설정
    _selectedTag = null;
    notifyListeners();
  }

  Future<bool> saveTask({
    required TaskType taskType,
    required String? tag,
  }) async {
    // _isLoading = true;
    notifyListeners();

    try {
      /// 반복이 없는 경우: endDate == startDate
      DateTime endDate = _hasRepeat
          ? (_repeatEndDate ?? _selectedDate)
          : _selectedDate;

      /// Task 객체 생성
      Task task = Task(
        taskId: uuid.v4(),
        type: taskType,
        title: _title,
        startDate: _selectedDate,
        endDate: endDate,
        repeat: Repeat(
          hasRepeat: _hasRepeat,
          unit: _repeatUnit,
          interval: _interval,
          daysOfWeek: _selectedDaysOfWeek,
        ),
        noti: Noti(
          hasNoti: _hasAlarm,
          notiTime: _hasAlarm ? _selectedAlarmTime : null,
        ),
        url: null,
      );

      /// Task를 Repository를 통해 DB에 저장
      await _taskRepository.createTask(task);

      /// Task를 기준으로 반복 패턴에 따라 Teekle n개 생성
      List<Teekle> teekles = _generateTeekles(task, tag);

      /// 생성된 Teekles를 Repository를 통해 DB에 저장
      if (teekles.isNotEmpty) {
        await _teekleRepository.createTeekles(teekles);
      }

      // _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ============ 반복 패턴에 따라 Teekle 생성 ============
  List<Teekle> _generateTeekles(Task task, String? tag) {
    // print('_generateTeekles() 호출 : Task 저장 후 반복패턴에 맞게 teekle 리스트 생성');
    List<Teekle> teekles = [];

    // 반복이 없는 경우
    if (!task.repeat.hasRepeat) {
      print('here1');
      teekles.add(
        Teekle(
          teekleId: uuid.v4(),
          taskId: task.taskId,
          type: task.type,
          execDate: task.startDate,
          title: task.title,
          tag: tag,
          isDone: false,
          noti: task.noti,
          url: task.url,
        ),
      );
      return teekles;
    }

    // print('생성된 날짜 list===================');
    /// 반복이 있는 경우 execDate 계산
    List<DateTime> execDates = _calculateRepeatExecutionDates(
      startDate: task.startDate,
      endDate: task.endDate,
      repeatUnit: task.repeat.unit!,
      interval: task.repeat.interval!,
      daysOfWeek: task.repeat.daysOfWeek,
    );
    // print(execDates.toList());
    // print(execDates.length);

    // print('생성된 teekle list===================');
    /// 계산된 각 날짜를 가진 Teekle 생성
    for (DateTime execDate in execDates) {
      teekles.add(
        Teekle(
          teekleId: uuid.v4(),
          taskId: task.taskId,
          type: task.type,
          execDate: execDate,
          title: task.title,
          tag: tag,
          isDone: false,
          noti: task.noti,
          url: task.url,
        ),
      );
    }
    // print(teekles.map((t) => t.toMap()).toList());
    // print(teekles.map((t) => t.toMap()).length);
    return teekles;
  }

  /// ============ 반복 규칙에 따라 실행 날짜 계산 ============
  List<DateTime> _calculateRepeatExecutionDates({
    required DateTime startDate,
    required DateTime endDate,
    required RepeatUnit repeatUnit,
    required int interval,
    required List<DayOfWeek>? daysOfWeek,
  }) {
    // print('_calculateRepeatExecutionDates() 호출 : 반복 패턴에 맞는 실행날짜 계산');
    List<DateTime> execDates = [];

    if (repeatUnit == RepeatUnit.weekly) {
      execDates = _calculateWeeklyRepeatDates(
        startDate: startDate,
        endDate: endDate,
        interval: interval,
        daysOfWeek: daysOfWeek ?? [],
      );
    } else if (repeatUnit == RepeatUnit.monthly) {
      execDates = _calculateMonthlyRepeatDates(
        startDate: startDate,
        endDate: endDate,
        interval: interval,
      );
    }

    return execDates;
  }

  /// ============ 주간 반복 날짜 계산 ============
  /// 로직
  /// 1. startDate가 속한 주(week 0) 찾기. 한주의 시작은 월요일로 계산(==월~일)
  /// 2. week 0에서 startDate 이후의 선택된 요일에 해당되는 날짜 추가
  /// 3. interval주마다 반복되는 주(week0 + n*interval)에서 선택된 요일 추가
  List<DateTime> _calculateWeeklyRepeatDates({
    required DateTime startDate,
    required DateTime endDate,
    required int interval,
    required List<DayOfWeek> daysOfWeek,
  }) {
    List<DateTime> dates = [];

    DateTime week0Start = _getMonday(startDate);

    /// startDate 이후의 week0에서만 선택된 요일들 찾기
    /// e.g) 선택요일 : 월수금, startDate는 목요일일때 week0에서 선택되는 요일은 금. (월,수는 버려짐)
    for (DayOfWeek dayOfWeek in daysOfWeek) {
      DateTime candidateDate = _getDateFromDayOfWeek(week0Start, dayOfWeek);

      if ((candidateDate.isAfter(startDate) ||
              candidateDate.isAtSameMomentAs(startDate)) &&
          (candidateDate.isBefore(endDate) ||
              candidateDate.isAtSameMomentAs(endDate))) {
        dates.add(candidateDate);
      }
    }

    /// n주마다 반복 될때 해당 주에서 선택된 요일들 찾기
    int weekOffset = interval;
    while (true) {
      DateTime currentWeekStart = week0Start.add(
        Duration(days: 7 * weekOffset),
      );

      if (currentWeekStart.isAfter(endDate)) {
        break;
      }

      for (DayOfWeek dayOfWeek in daysOfWeek) {
        DateTime candidateDate = _getDateFromDayOfWeek(
          currentWeekStart,
          dayOfWeek,
        );

        if (candidateDate.isBefore(endDate) ||
            candidateDate.isAtSameMomentAs(endDate)) {
          dates.add(candidateDate);
        }
      }

      weekOffset += interval;
    }

    dates.sort();
    return dates;
  }

  /// ============ 월간 반복 날짜 계산 ============
  /// 로직
  /// 1. startDate의 일(day) 고정 (11월 20일이면, 20일 고정)
  /// 2. interval개월마다 같은 특정 일자 반복 (12월 20일, 1월 20일, ...)
  /// 3. 해당 월에 그 날이 없으면 월의 마지막 날로 조정 (28~31일 한정)
  List<DateTime> _calculateMonthlyRepeatDates({
    required DateTime startDate,
    required DateTime endDate,
    required int interval,
  }) {
    List<DateTime> dates = [];

    int dayOfMonth = startDate.day; ///특정 날짜 고정

    int currentYear = startDate.year;
    int currentMonth = startDate.month;

    while (true) {
      int lastDayOfMonth = _getLastDayOfMonth(currentYear, currentMonth);
      int adjustedDay = dayOfMonth > lastDayOfMonth
          ? lastDayOfMonth
          : dayOfMonth;

      DateTime candidateDate = DateTime(currentYear, currentMonth, adjustedDay);

      if ((candidateDate.isAfter(startDate) ||
              candidateDate.isAtSameMomentAs(startDate)) &&
          (candidateDate.isBefore(endDate) ||
              candidateDate.isAtSameMomentAs(endDate))) {
        dates.add(candidateDate);
      }

      if (candidateDate.isAfter(endDate)) {
        break;
      }

      currentMonth += interval;
      while (currentMonth > 12) {
        currentMonth -= 12;
        currentYear += 1;
      }
    }

    dates.sort();
    return dates;
  }

  ///============ utils ============
  DateTime _getMonday(DateTime date) {
    int daysToMonday = (date.weekday - 1) % 7;
    return date.subtract(Duration(days: daysToMonday));
  }

  DateTime _getDateFromDayOfWeek(DateTime weekMonday, DayOfWeek dayOfWeek) {
    int targetWeekday = dayOfWeek.index + 1;
    int daysToAdd = (targetWeekday - weekMonday.weekday) % 7;
    return weekMonday.add(Duration(days: daysToAdd));
  }

  int _getLastDayOfMonth(int year, int month) {
    DateTime nextMonth = DateTime(year, month + 1, 1);
    return nextMonth.subtract(Duration(days: 1)).day;
  }
}
