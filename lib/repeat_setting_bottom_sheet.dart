import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';
import 'package:intl/intl.dart';

Future<DateTime?> showTeekleRepeatSetting(context) async {
  DateTime? selectedDate;

  final result = showModalBottomSheet<DateTime> (
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.BottomSheetBg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
    builder: (_) => RepeatBottomSheet(
      onTimeChanged: (t) => selectedDate = t,
    ),
  );

  return result ?? selectedDate; // result가 null이면 마지막 선택된 값 반환
}

class RepeatBottomSheet extends StatefulWidget {
  final ValueChanged<DateTime>? onTimeChanged;
  const RepeatBottomSheet({this.onTimeChanged, super.key});

  @override
  State<RepeatBottomSheet> createState() => _RepeatBottomSheetState();
}

class _RepeatBottomSheetState extends State<RepeatBottomSheet> {
  bool _hasRepeat = false;
  String? _repeatUnit;
  List<String> selectedDays = [];

  bool showRepeatPicker = false;
  bool showRepeatEndPicker = false;
  DateTime date = DateTime.now();
  int selectedPickerIndex = 0;

  final List<String> _daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '반복',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 반복 없음 버튼
          GestureDetector(
            onTap: () => setState(() {
              _hasRepeat = !_hasRepeat;
              _repeatUnit = !_hasRepeat ? null : 'weekly';
              selectedDays = [];
            }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: _hasRepeat ? AppColors.TxtGrey : AppColors.LightGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '반복 없음',
                style: TextStyle(
                  color: _hasRepeat ? Colors.white : AppColors.TxtDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 주간/월간 슬라이드 토글
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.TxtGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: _hasRepeat ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _repeatUnit == 'weekly'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    curve: Curves.easeInOut,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: AppColors.LightGreen,
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                  ),
                ),

                // 주간/월간 버튼
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque, // 터치 영역 확대
                        onTap: () => setState(() {
                          _hasRepeat = true;
                          _repeatUnit = 'weekly';
                        }),
                        child: Center(
                          child: Text(
                            '주간',
                            style: TextStyle(
                              color: _repeatUnit == 'weekly'
                                  ? AppColors.TxtDark
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() {
                          _hasRepeat = true;
                          _repeatUnit = 'monthly';
                        }),
                        child: Center(
                          child: Text(
                            '월간',
                            style: TextStyle(
                              color: _repeatUnit == 'monthly'
                                  ? AppColors.TxtDark
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. 비활성화 될 섹션을 IgnorePointer와 AnimatedOpacity로 감쌉니다.
          IgnorePointer(
            ignoring: !_hasRepeat,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _hasRepeat ? 1.0 : 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //반복 종료
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '반복 종료',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showRepeatEndPicker = !showRepeatEndPicker;
                            if (showRepeatEndPicker) {
                              showRepeatPicker = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).viewInsets.left + 60,
                              // 1. DateTime.now() 대신 date 상태 변수를 사용합니다.
                              child: Text(
                                DateFormat('MM월 dd일').format(date),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  //반복 종료 날짜 picker
                  if (showRepeatEndPicker)
                    SizedBox(
                      height: 220,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          minimumYear: 2025,
                          maximumYear: 2030,
                          initialDateTime: date,
                          minimumDate: DateTime(2025, 11, 1),
                          maximumDate: DateTime(2030, 12, 31),
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() => date = newDate);
                            widget.onTimeChanged?.call(date);
                          },
                        ),
                      ),
                    ),

                  // 반복 주기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '반복 주기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showRepeatPicker = !showRepeatPicker;
                            if (showRepeatPicker) {
                              showRepeatEndPicker = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).viewInsets.left + 48,
                              child: Text(
                                !_hasRepeat && _repeatUnit == null
                                    ? ''
                                    : _hasRepeat && _repeatUnit == 'weekly'
                                    ? '${selectedPickerIndex + 1}주마다'
                                    : _hasRepeat && _repeatUnit == 'monthly'
                                    ? '${selectedPickerIndex + 1}달마다'
                                    : '',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 반복 주기 picker
                  if (showRepeatPicker)
                    SizedBox(
                      height: 110,
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedPickerIndex,
                        ),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedPickerIndex = index;
                          });
                        },
                        children: List.generate(
                          3,
                          (index) => Center(
                            child: Text(
                              _repeatUnit == 'weekly'
                              ? '${index + 1}주마다'
                              : '${index + 1}달마다',
                              style: const TextStyle(color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // 요일 선택
                  const Text(
                    '요일 선택',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _daysOfWeek.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_hasRepeat) {
                              if (isSelected) {
                                selectedDays.remove(day);
                              } else {
                                selectedDays.add(day);
                              }
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: isSelected
                              ? AppColors.LightGreen
                              : AppColors.TxtGrey,
                          child: Text(
                            day,
                            style: TextStyle(
                              color: isSelected ? AppColors.TxtDark : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
