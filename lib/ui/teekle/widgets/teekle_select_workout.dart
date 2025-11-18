import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class Workout {
  final String url;
  final String title;

  Workout({required this.url, required this.title});
}

List<Workout> workoutList = [
  Workout(
    url: 'https://youtu.be/6AiSi3E3ifs',
    title: '집중력 버프가 필요할 때? (ep1. 뇌를 자극시키는 집중력 향상 운동) 집콕운동',
  ),
  Workout(
    url: 'https://youtu.be/6AiSi3E3ifs',
    title: '집중력 버프가 필요할 때? (ep1. 뇌를 자극시키는 집중력 향상 운동) 집콕운동',
  ),
  Workout(
    url: 'https://youtu.be/6AiSi3E3ifs',
    title: '집중력 버프가 필요할 때? (ep1. 뇌를 자극시키는 집중력 향상 운동) 집콕운동',
  ),
  Workout(
    url: 'https://youtu.be/6AiSi3E3ifs',
    title: '집중력 버프가 필요할 때? (ep1. 뇌를 자극시키는 집중력 향상 운동) 집콕운동',
  ),
  Workout(
    url: 'https://youtu.be/6AiSi3E3ifs',
    title: '집중력 버프가 필요할 때? (ep1. 뇌를 자극시키는 집중력 향상 운동) 집콕운동',
  ),
  Workout(
    url: 'https://youtu.be/6AiSi3E3ifs',
    title: '집중력 버프가 필요할 때? (ep1. 뇌를 자극시키는 집중력 향상 운동) 집콕운동',
  ),
];

class TeekleSelectWorkoutScreen extends StatefulWidget {
  const TeekleSelectWorkoutScreen({super.key});

  @override
  State<TeekleSelectWorkoutScreen> createState() =>
      _TeekleSelectWorkoutScreenState();
}

class _TeekleSelectWorkoutScreenState extends State<TeekleSelectWorkoutScreen> {
  bool _isBookmarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
          color: AppColors.txtGray,
        ),
        title: Text(
          '운동 선택하기',
          style: TextStyle(
            fontFamily: 'Paperlogy',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBookmarkMode = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: !_isBookmarkMode
                                ? AppColors.green
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        '전체',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Paperlogy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: !_isBookmarkMode
                              ? AppColors.green
                              : AppColors.txtGray,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBookmarkMode = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isBookmarkMode
                                ? AppColors.green
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        '북마크',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Paperlogy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: _isBookmarkMode
                              ? AppColors.green
                              : AppColors.txtGray,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: workoutList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.txtGray),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            'https://img.youtube.com/vi/${workoutList[index].url.split('/').last}/default.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 6.0,
                              ),
                              child: Text(
                                workoutList[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Paperlogy',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/flowbite_link-outline.svg',
                                ),
                                const SizedBox(width: 4.0),
                                SvgPicture.asset(
                                  'assets/icons/bookmark_uncheck.svg',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
