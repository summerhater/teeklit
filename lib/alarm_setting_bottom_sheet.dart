import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';

Future<DateTime?> showTeekleAlarmSetting(context) async {
  DateTime selectedTime = DateTime.now();

  final result = await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: false,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => AlarmBottomSheet(
      onTimeChanged: (t) => selectedTime = t,
    ),
  );

  return result ?? selectedTime; // result가 null이면 마지막 선택된 값 반환
}

class AlarmBottomSheet extends StatefulWidget {
  final ValueChanged<DateTime>? onTimeChanged;
  const AlarmBottomSheet({this.onTimeChanged, super.key});

  @override
  State<AlarmBottomSheet> createState() => _AlarmBottomSheetState();
}

class _AlarmBottomSheetState extends State<AlarmBottomSheet> {
  DateTime time = DateTime.now();

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
                  '알림',
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

        SizedBox(
          height: 220,
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: Colors.white, // 글자색 흰색으로 변경
                  fontSize: 20,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              initialDateTime: time,
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              onDateTimeChanged: (DateTime newTime) {
                setState(() => time = newTime);
                widget.onTimeChanged?.call(time);
              },
            ),
          ),
        ),
          ],
        ),
      );
  }
}
