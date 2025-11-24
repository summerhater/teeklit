import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/domain/model/teekle/workout_video.dart';

class HomeTop5WorkoutCard extends StatelessWidget {
  final List<WorkoutVideo> popularWorkouts;

  const HomeTop5WorkoutCard({
    super.key,
    required this.popularWorkouts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최근 인기 많은 운동 TOP5 💪',
          style: TextStyle(
            color: AppColors.TxtLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularWorkouts.length,
            itemBuilder: (context, index) {
              return _WorkoutCard(workout: popularWorkouts[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutVideo workout;

  const _WorkoutCard({
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = workout.videoUrl.split('/').last;
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(workout.videoUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.RoundboxDarkBg,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                thumbnailUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.BtnDarkBg,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: AppColors.TxtGrey,
                        size: 48,
                      ),
                    ),
                  );
                },
              ),
            ),
            // 그라데이션 오버레이
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // 북마크 아이콘
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  // 북마크 기능
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            // 운동 제목
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: SizedBox(
                width: 140, // 카드의 절반 길이 (280 / 2)
                child: Text(
                  workout.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

