import 'package:aj_autofix/models/booking_confirmation_arguments.dart';
import 'package:aj_autofix/screens/admin_completed_bookings_screen.dart';
import 'package:aj_autofix/screens/admin_panel_screen.dart';
import 'package:aj_autofix/screens/admin_screen.dart';
import 'package:aj_autofix/screens/admin_services_screen.dart';
import 'package:aj_autofix/screens/admin_update_details_screen.dart';
import 'package:aj_autofix/screens/admin_user_screen.dart';
import 'package:aj_autofix/screens/booking_confirmation_screen.dart';
import 'package:aj_autofix/screens/booking_screen.dart';
import 'package:aj_autofix/screens/contact_us_screen.dart';
import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/screens/main_screen.dart';
import 'package:aj_autofix/screens/notification_screen.dart';
import 'package:aj_autofix/screens/onboaring_screen.dart';
import 'package:aj_autofix/screens/pending_screen.dart';
import 'package:aj_autofix/screens/profile_screen.dart';
import 'package:aj_autofix/screens/profile_update_screen.dart';
import 'package:aj_autofix/screens/shopmap.dart';
import 'package:aj_autofix/screens/show_reviews_screen.dart';
import 'package:aj_autofix/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const SplashScreen(),
            ),
            GoRoute(
              path: '/onBoarding',
              builder: (context, state) => const OnBoardingScreen(),
            ),
            //for users
            GoRoute(
              path: '/mainscreen',
              builder: (context, state) => const MainScreen(),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/booking',
              builder: (context, state) => const BookingScreen(
                userId: '',
              ),
            ),
            GoRoute(
              path: '/map',
              builder: (context, state) => const ShopMap(),
            ),
            GoRoute(
              path: '/notification',
              builder: (context, state) => const NotificationScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: '/confirmBooking',
              builder: (context, state) {
                final args = state.extra as BookingConfirmationArguments;

                return BookingConfirmationScreen(
                  selectedServices: args.selectedServices,
                  selectedServiceCount: args.selectedServiceCount,
                  selectedTimeSlot: args.selectedTimeSlot,
                  bookingDate: args.bookingDate,
                  vehicleType: args.vehicleType,
                );
              },
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(
                userId: '',
              ),
            ),
            GoRoute(
              path: '/updateProfile',
              builder: (context, state) => const ProfileUpdateScreen(
                userId: '',
              ),
            ),
            GoRoute(
              path: '/reviews',
              builder: (context, state) => const ShowReviewsScreen(),
            ),
            GoRoute(
              path: '/pendingRequest',
              builder: (context, state) => const UserPendingRequest(),
            ),
            GoRoute(
              path: '/contact',
              builder: (context, state) => ContactUsScreen(),
            ),
            // for admin
            GoRoute(
              path: '/adminScreen',
              builder: (context, state) => const AdminScreen(),
            ),
            GoRoute(
              path: '/adminPanel',
              builder: (context, state) => const AdminPanelScreen(),
            ),
            GoRoute(
              path: '/adminUsers',
              builder: (context, state) => const AdminUsersScreen(),
            ),
            GoRoute(
              path: '/adminServices',
              builder: (context, state) => const AdminServicesScreen(),
            ),
            GoRoute(
              path: '/adminComplete',
              builder: (context, state) => const AdminCompletedBookingsScreen(),
            ),
            GoRoute(
              path: '/admin/update/:id',
              builder: (context, state) {
                final id = state.pathParameters['id'];
                return AdminUpdateDetailsScreen(id: id!);
              },
            ),
          ],
        );
}
