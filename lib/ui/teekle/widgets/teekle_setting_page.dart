import 'package:flutter/material.dart';
import 'package:teeklit/ui/teekle/view_model/view_model_teekle_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_alarm_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_date_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_repeat_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_tag_setting.dart';
import 'package:teeklit/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:teeklit/domain/model/enums.dart';
import 'package:provider/provider.dart';

class TeekleSettingPage extends StatefulWidget {
  final TeeklePageType? type;

  const TeekleSettingPage({super.key, required this.type});

  @override
  State<TeekleSettingPage> createState() => _TeekleSettingPage();
}

class _TeekleSettingPage extends State<TeekleSettingPage> {
  final _titleController = TextEditingController();
  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  /// 날짜 편집
  void _handleDate(TeekleSettingViewModel viewModel) async {
    final pickedDate = await showTeekleDateSetting(
      context,
      viewModel.selectedDate,
    );
    viewModel.setDate(pickedDate);
    print('날짜설정 : ${pickedDate}');
  }

  /// 알림 토글 상태 관리
  void _handleAlarmToggle(
    bool hasAlarm,
    TeekleSettingViewModel viewModel,
  ) async {
    if (hasAlarm) {
      final pickedAlarmTime = await showTeekleAlarmSetting(
        context,
        selectedAlarmTime: viewModel.selectedTime,
      );

      if (pickedAlarmTime != null) {
        viewModel.setAlarm(true, pickedAlarmTime);
      }
    } else {
      viewModel.clearAlarm();
    }
  }

  /// 선택된 알림 시간이 있는 상태에서 시간 재편집
  void _handleAlarmTime(TeekleSettingViewModel viewModel) async {
    if (viewModel.hasAlarm) {
      final pickedTime = await showTeekleAlarmSetting(
        context,
        selectedAlarmTime: viewModel.selectedTime,
      );
      if (pickedTime != null) {
        viewModel.setAlarm(true, pickedTime);
      }
    }
  }

  /// 반복 토글 상태 관리
  void _handleRepeatToggle(
    bool hasRepeat,
    TeekleSettingViewModel viewModel,
  ) async {
    if (hasRepeat) {
      print('hasrpeat: true 입니다');
      _handleRepeat(viewModel);
    } else {
      viewModel.clearRepeatSetting();
      print('hasrpeat: false 입니다');
    }
  }

  /// 반복이 on인 상태에서 반복 재편집
  void _handleRepeat(TeekleSettingViewModel viewModel) async {
    final result = await showTeekleRepeatSetting(
      context,
      hasRepeat: viewModel.hasRepeat,
      repeatUnit: viewModel.repeatUnit,
      interval: viewModel.interval,
      repeatEndDate: viewModel.repeatEndDate ?? viewModel.selectedDate,
      daysOfWeek: viewModel.selectedDaysOfWeek,
    );
    if (result != null) {
      viewModel.setRepeatSetting(
        hasRepeat: result['hasRepeat'],
        repeatUnit: result['repeatUnit'],
        interval: result['interval'],
        repeatEndDate: result['repeatEndDate'],
        daysOfWeek: result['daysOfWeek'],
      );
    }
  }

  void _handleTag(TeekleSettingViewModel viewModel) async {
    final pickedTag = await showTeekleTagSetting(
      context,
      pickedTag: viewModel.selectedTag,
    );
    viewModel.setTagSetting(pickedTag);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      /// 기존: multiprovider 생성 -> 뷰모델 1개로 통합 변경
      create: (_) => TeekleSettingViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.Bg,
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: AppColors.Bg,
          foregroundColor: Colors.white,
          shape: Border(
            bottom: BorderSide(color: AppColors.StrokeGrey, width: 1),
          ),
          title: Text(
            widget.type == TeeklePageType.addTodo
                ? '투두 추가하기'
                : widget.type == TeeklePageType.editTodo
                ? '투두 수정하기'
                : widget.type == TeeklePageType.addWorkout
                ? '운동 추가하기'
                : widget.type == TeeklePageType.editWorkout
                ? '운동 수정하기'
                : '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left, color: AppColors.TxtGrey, size: 24),
          ),
        ),

        body: Consumer<TeekleSettingViewModel>(
          builder: (context, viewModel, child) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 26,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.type == TeeklePageType.addTodo ||
                                widget.type == TeeklePageType.editTodo
                            ? '투두 이름'
                            : '운동 선택',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        focusNode: _titleFocusNode,
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        cursorColor: AppColors.Green,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          context.read<TeekleSettingViewModel>().setTitle(
                            value.trim(),
                          );
                        },
                        decoration: InputDecoration(
                          hintText:
                              widget.type == TeeklePageType.addTodo ||
                                  widget.type == TeeklePageType.editTodo
                              ? '할일을 입력해주세요.'
                              : '운동을 선택해주세요.',
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
                      const SizedBox(height: 32),

                      /// 설정 박스
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff3A3A3C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            /// 날짜
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
                                  Text(
                                    DateFormat(
                                      'MM월 dd일',
                                    ).format(viewModel.selectedDate),
                                    style: const TextStyle(
                                      color: AppColors.TxtLight,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      letterSpacing: -.2,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                /// 텍스트필드에 포커스가 있으면 실행 안 함
                                if (_titleFocusNode.hasFocus) return;
                                final pickedDate = await showTeekleDateSetting(
                                  context,
                                  viewModel.selectedDate,
                                );
                                viewModel.setDate(pickedDate);
                              },
                            ),
                            const Divider(color: Color(0xff2C2C2E), height: 1),

                            /// 알림 (토글)
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
                                  if (viewModel.hasAlarm)
                                    GestureDetector(
                                      onTap: () {
                                        /// 이름 텍스트필드에 포커스가 있으면 실행 안 함
                                        if (_titleFocusNode.hasFocus) {
                                          return;
                                        }
                                        _handleAlarmTime(viewModel);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          DateFormat(
                                            'h:mm a',
                                          ).format(viewModel.selectedTime),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  Switch.adaptive(
                                    value: viewModel.hasAlarm,
                                    onChanged: (value) {
                                      /// 텍스트필드에 포커스가 있으면 실행 안 함
                                      if (_titleFocusNode.hasFocus) return;
                                      _handleAlarmToggle(value, viewModel);
                                    },
                                    activeThumbColor: Colors.white,
                                    activeTrackColor: const Color(0xffB1C39F),
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),

                            const Divider(color: Color(0xff2C2C2E), height: 1),

                            /// 반복 (토글 스위치)
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (viewModel.hasRepeat)
                                    GestureDetector(
                                      ///투명 컨테이너 탭 작동하도록 설정
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        /// 텍스트필드에 포커스가 있으면 실행 안 함
                                        if (_titleFocusNode.hasFocus) return;
                                        _handleRepeat(viewModel);
                                      },
                                      child: Container(width: 60, height: 30),
                                    ),
                                  Switch.adaptive(
                                    value: viewModel.hasRepeat,
                                    onChanged: (bool value) {
                                      /// 텍스트필드에 포커스가 있으면 실행 안 함
                                      if (_titleFocusNode.hasFocus) return;
                                      _handleRepeatToggle(value, viewModel);
                                    },
                                    activeThumbColor: Colors.white,
                                    activeTrackColor: const Color(0xffB1C39F),
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),

                            const Divider(color: Color(0xff2C2C2E), height: 1),

                            /// 태그 (화살표 아이콘)
                            if (widget.type == TeeklePageType.addTodo ||
                                widget.type == TeeklePageType.editTodo)
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
                                    if (viewModel.selectedTag != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6.0,
                                        ),
                                        child: Text(
                                          viewModel.selectedTag!,
                                          style: const TextStyle(
                                            color: AppColors.TxtLight,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  /// 텍스트필드에 포커스가 있으면 실행 안 함
                                  if (_titleFocusNode.hasFocus) return;
                                  _handleTag(viewModel);
                                },
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32,),
                      /// 삭제버튼
                      if (widget.type == TeeklePageType.editTodo ||
                          widget.type == TeeklePageType.editWorkout)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.WarningRed,
                              padding: EdgeInsets.all(16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<TeekleSettingViewModel>(
            builder: (context, viewModel, child) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 92,
                  decoration: BoxDecoration(
                    color: viewModel.title.isNotEmpty ? AppColors.Green : AppColors
                        .InactiveGreyBg,
                  ),
                  child: Center(
                    child: Text(
                      '저장하기',
                      style: TextStyle(
                        color: viewModel.title.isNotEmpty ? AppColors.TxtDark : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
