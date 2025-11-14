import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';

Future<DateTime?> showTeekleDateSetting(context) async {
  DateTime selectedDate = DateTime.now();

  final result = await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: false,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DateBottomSheet(
      onTimeChanged: (t) => selectedDate = t,
    ),
  );

  return result ?? selectedDate; // result가 null이면 마지막 선택된 값 반환
}

class DateBottomSheet extends StatefulWidget {
  final ValueChanged<DateTime>? onTimeChanged;
  const DateBottomSheet({this.onTimeChanged, super.key});

  @override
  State<DateBottomSheet> createState() => _DateBottomSheetState();
}

class _DateBottomSheetState extends State<DateBottomSheet> {
  DateTime date = DateTime.now();

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
                '날짜',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context, date),
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
        ],
      ),
    );
  }
}


// class CupertinoDatepickerScreen extends StatelessWidget {
//   const CupertinoDatepickerScreen({super.key});
//
//   void _onPickerChanged(DateTime date) {
//     final textDate = date.toString().split(' ').first;
//     print(textDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cupertino Datepicker'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Center(
//           child: SizedBox(
//             width: 400,
//             height: 300,
//             child: CupertinoDatePicker(
//               minimumYear: 1900,
//               maximumYear: DateTime.now().year,
//               initialDateTime: DateTime.now(),
//               maximumDate: DateTime.now(),
//               mode: CupertinoDatePickerMode.date,
//               use24hFormat: true,
//               onDateTimeChanged: _onPickerChanged,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }