import 'package:flutter/material.dart';
import 'package:teeklit/tag_setting_bottom_sheet.dart';
import 'package:teeklit/utils/colors.dart';
import 'package:teeklit/alarm_setting_bottom_sheet.dart';
import 'package:teeklit/date_setting_bottom_sheet.dart';
import 'package:teeklit/repeat_setting_bottom_sheet.dart';
import 'package:teeklit/tag_setting_bottom_sheet.dart';
import 'package:intl/intl.dart';

class AddTeekleTodoPage extends StatefulWidget {
  const AddTeekleTodoPage({super.key});

  @override
  State<AddTeekleTodoPage> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTeekleTodoPage> {
  DateTime? _selectedDate;
  bool _isAlarmOn = false;
  DateTime? _selectedAlarmTime;
  String? _selectedTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Bg,
      appBar: AppBar(title: Text('앱바 자리차지용')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '투두 이름',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            //투두 이름 입력
            TextField(
              cursorColor: AppColors.Green,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '할일을 입력해주세요.',
                hintStyle: const TextStyle(color: Color(0xff8E8E93)),
                filled: true,
                fillColor: const Color(0xff3A3A3C),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 설정 박스
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff3A3A3C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 날짜
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    title: const Text(
                      '날짜',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 날짜 표시
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            _selectedDate == null
                                ? DateFormat('MM월 dd일').format(DateTime.now())
                                : DateFormat('MM월 dd일').format(_selectedDate!),
                            style: const TextStyle(
                              color: AppColors.TxtLight,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              letterSpacing: -.2,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white70),
                      ],
                    ),
                    onTap: () async {
                      // 바텀시트 띄우기
                      final pickedDate = await showTeekleDateSetting(context);
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  Divider(color: Color(0xff2C2C2E), height: 1),

                  // 알림 (토글)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    title: const Text(
                      '알림',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 시간 표시
                        if (_isAlarmOn && _selectedAlarmTime != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700, // 배경색
                              borderRadius: BorderRadius.circular(20), // 둥근 모양
                            ),
                            child: Text(
                              DateFormat('h:mm a').format(_selectedAlarmTime!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        const SizedBox(width: 8), // 시간과 스위치 사이 간격

                        Switch.adaptive(
                          value: _isAlarmOn,
                          onChanged: (bool value) async {
                            if (value) {
                              // 스위치를 켤 때
                              final pickedTime = await showTeekleAlarmSetting(
                                context,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _isAlarmOn = true;
                                  _selectedAlarmTime = pickedTime;
                                });
                              }
                            } else {
                              // 스위치를 끌 때
                              setState(() {
                                _isAlarmOn = false;
                              });
                            }
                          },
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xffB1C39F),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xff2C2C2E), height: 1),

                  // 반복 (화살표 아이콘)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    title: const Text(
                      '반복',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                    onTap: () {
                      // 바텀시트 띄우기
                      showTeekleRepeatSetting(context);
                    },
                  ),
                  Divider(color: Color(0xff2C2C2E), height: 1),

                  // 태그 (화살표 아이콘)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    title: const Text(
                      '태그',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // _selectedTag가 있으면 텍스트를 표시, 없으면 표시하지 않음
                        if (_selectedTag != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Text(
                              _selectedTag!,
                              style: const TextStyle(
                                color: AppColors.TxtLight,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        const Icon(Icons.chevron_right, color: Colors.white70),
                      ],
                    ),
                    onTap: () async {
                      final pickedTag = await showTeekleTagSetting(
                        context,
                        currentTag: _selectedTag,
                      );
                      setState(() {
                        _selectedTag = pickedTag;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}