import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/domain/model/teekle.dart';

class HomeMyTeekleCard extends StatelessWidget {
  final List<Teekle> todayTeekles;
  final Function(Teekle) onTeekleToggle;

  const HomeMyTeekleCard({
    super.key,
    required this.todayTeekles,
    required this.onTeekleToggle,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateStr = DateFormat('M월 d일', 'ko_KR').format(today);
    final doneCount = todayTeekles.where((t) => t.isDone).length;
    final totalCount = todayTeekles.length;
    final progress = totalCount > 0 ? doneCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.RoundboxDarkBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '내 티클',
                style: const TextStyle(
                  color: AppColors.TxtLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                  '$dateStr',
                style: const TextStyle(
                  color: AppColors.TxtLight,
                  fontSize: 12,

                ),
              ),
              TextButton(
                onPressed: () {
                  context.go('/teekle');
                },
                child: const Text(
                  '더보기',
                  style: TextStyle(
                    color: AppColors.Green,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 진행 바
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.BtnDarkBg,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.Green),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                totalCount > 0 ? '$doneCount/$totalCount' : '0/0',
                style: const TextStyle(
                  color: AppColors.TxtGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 티클 목록
          if (totalCount == 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '오늘 예정된 티클이 없어요🧐',
                  style: TextStyle(
                    color: AppColors.TxtGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...todayTeekles.map((teekle) => _TeekleItem(
                  teekle: teekle,
                  onTap: () => onTeekleToggle(teekle),
                )),
        ],
      ),
    );
  }
}

class _TeekleItem extends StatelessWidget {
  final Teekle teekle;
  final VoidCallback onTap;

  const _TeekleItem({
    required this.teekle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: SvgPicture.asset(
              teekle.isDone
                  ? 'assets/icons/check_with_logo_active.svg'
                  : 'assets/icons/check_with_logo_inactive.svg',
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teekle.title,
              style: TextStyle(
                color: teekle.isDone ? AppColors.TxtGrey : AppColors.TxtLight,
                fontSize: 14,
                decoration: teekle.isDone ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

