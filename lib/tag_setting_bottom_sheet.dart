import 'package:flutter/material.dart';
import 'package:teeklit/scroll_gradient_overlay.dart';
import 'package:teeklit/utils/colors.dart';

// main.dart에서 현재 태그 값을 받아오도록 파라미터 추가
Future<String?> showTeekleTagSetting(BuildContext context, {String? currentTag}) async {
  //실시간으로 선택된 태그를 추적할 변수
  String? lastSelectedTag = currentTag;

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => TagBottomSheet(
      // 초기 선택값과 콜백 함수를 바텀시트에 전달
      initialTag: currentTag,
      onTagChanged: (tag) {
        lastSelectedTag = tag;
      },
    ),
  );

  // 바깥 영역을 탭해서 result가 null이 되어도 마지막 선택값 반환
  return result ?? lastSelectedTag;
}

class TagBottomSheet extends StatefulWidget {
  // 초기값과 콜백을 받기 위한 파라미터 추가
  final String? initialTag;
  final ValueChanged<String?>? onTagChanged;

  const TagBottomSheet({super.key, this.initialTag, this.onTagChanged});

  @override
  State<TagBottomSheet> createState() => _TagBottomSheetState();
}

class _TagBottomSheetState extends State<TagBottomSheet> {
  String? _selectedTag;
  final ScrollController _scrollController = ScrollController();
  bool _showTopGradient = false;

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 전달받은 초기값으로 상태를 설정
    _selectedTag = widget.initialTag;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showGradient = _scrollController.position.pixels > 0;
    if (showGradient != _showTopGradient) {
      setState(() {
        _showTopGradient = showGradient;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '태그',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context, _selectedTag),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    itemCount: dummyTags.length,
                    itemBuilder: (context, index) {
                      final tag = dummyTags[index];
                      final isSelected = _selectedTag == tag;
                      return Card(
                        elevation: 0,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          title: Text(tag,
                              style: TextStyle(
                                  color: isSelected
                                      ? AppColors.TxtDark
                                      : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          tileColor: isSelected
                              ? AppColors.Green
                              : AppColors.StrokeGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onTap: () {
                            setState(() {
                              if (_selectedTag != null && _selectedTag == tag) {
                                _selectedTag = null;
                              } else {
                                _selectedTag = tag;
                              }
                            });
                            // 탭할 때마다 콜백을 호출하여 부모에게 실시간으로 값 전달
                            widget.onTagChanged?.call(_selectedTag);
                          },
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: _showTopGradient,
                    child: const ScrollGradientOverlay(
                      gradientColor: AppColors.BottomSheetBg,
                      direction: GradientDirection.top,
                    ),
                  ),
                  const ScrollGradientOverlay(
                    gradientColor: AppColors.BottomSheetBg,
                    direction: GradientDirection.bottom,
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

final List<String> dummyTags = [
  '운동하기 🏋',
  '집안일 🧼',
  '습관',
  '공부하기',
  '독서',
  '건강 관리',
  '운동하기 🏋',
  '집안일 🧼',
  '습관',
  '공부하기',
  '독서',
  '건강 관리',
];
