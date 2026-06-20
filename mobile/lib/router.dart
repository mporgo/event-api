import 'package:go_router/go_router.dart';
import 'screens/event_list_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/create_event_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const EventListScreen(),
    ),
    GoRoute(
      path: '/events/new',
      builder: (_, __) => const CreateEventScreen(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (_, state) => EventDetailScreen(
        eventId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
