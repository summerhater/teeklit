import 'package:flutter/material.dart';
import 'package:teeklit/domain/model/enums.dart';
import 'package:teeklit/domain/model/noti.dart';
import 'package:teeklit/domain/model/repeat.dart';
import 'package:teeklit/domain/model/task.dart';
import 'package:teeklit/domain/model/teekle.dart';

class TeekleSettingViewModel extends ChangeNotifier {
  ///=============== 변수 선언 ===============
  DateTime now = DateTime.now();

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
  bool get hasTitle => _title.trim().isNotEmpty;

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
    print('✅ ViewModel updateRepeat() 호출됨');
    notifyListeners();
  }

  ///반복 토글 Off 일때 부분 초기화
  void clearRepeatSetting() {
    _hasRepeat = false;
    _repeatUnit = null;
    _interval = null;
    _repeatEndDate = null;
    _selectedDaysOfWeek = [];
    print('✅ ViewModel clearRepeatSetting() 호출됨');
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

  // /// Task(또는 Teekle) 모델을 받아서 ViewModel의 상태를 초기화하는 메서드
  // void fromTask(Task task) {
  //   // _titleController.text = task.title; // (페이지에서 처리)
  //   _selectedDate = task.date;
  //   _hasAlarm = task.noti.hasNoti;
  //   _selectedAlarmTime = task.noti.notiTime ?? DateTime.now();
  //   _hasRepeat = task.repeat.hasRepeat;
  //   _repeatUnit = task.repeat.unit;
  //   _interval = task.repeat.interval;
  //   _repeatEndDate = task.repeat.endDate;
  //   _selectedDaysOfWeek = task.repeat.daysOfWeek;
  //   _selectedTag = task.tag;
  //   // 상태가 변경되었음을 알려 UI를 갱신합니다.
  //   notifyListeners();
  // }
  //
  // /// ViewModel의 현재 상태를 Task 모델로 변환하여 반환하는 메서드
  // Task toTask(String title) {
  //   return Task(
  //     title: _title,
  //     date: _selectedDate,
  //     noti: Noti(hasNoti: _hasAlarm, notiTime: _hasAlarm ? _selectedAlarmTime : null),
  //     repeat: Repeat(
  //       hasRepeat: _hasRepeat,
  //       unit: _repeatUnit,
  //       interval: _interval,
  //       endDate: _repeatEndDate,
  //       daysOfWeek: _selectedDaysOfWeek,
  //     ),
  //     tag: _selectedTag,
  //     // isCompleted, createdAt 등 다른 필요한 속성들...
  //   );
  // }
}
