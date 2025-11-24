import 'package:go_router/go_router.dart';
import 'package:teeklit/ui/My/my_page.dart';
import 'package:teeklit/ui/community/community_main_page.dart';
import 'package:teeklit/ui/community/community_post_view_page.dart';
import 'package:teeklit/ui/community/community_post_write_page.dart';
import 'package:teeklit/ui/home/home_page.dart';
import 'package:teeklit/ui/home/navigation_view.dart';
import 'package:teeklit/ui/teekle/teekle_main.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, shellChild) {
        return NavigationView(child: shellChild);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/teekle',
          name: 'teekle',
          builder: (context, state) => const TeekleMainScreen(),
        ),
        GoRoute(
          path: '/community',
          name: 'communityMain',
          builder: (context, state) => const CommunityMainPage(),
        ),
        GoRoute(
          path: '/my',
          name: 'my',
          builder: (context, state) => const MyPage(), // MyPage로 변경
        ),
      ],
    ),
    GoRoute(
      path: '/community/write',
      name: 'communityWrite',
      builder: (context, state) => const CommunityPostWritePage(),
    ),
    GoRoute(
      path: '/community/view',
      name: 'communityView',
      builder: (context, state) => const CommunityPostViewPage(),
    ),
  ],
);