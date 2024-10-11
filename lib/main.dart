import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/contact/contact_bloc.dart';
import 'package:aj_autofix/bloc/notifications/Notification_bloc.dart';
import 'package:aj_autofix/bloc/review/review_bloc.dart';
import 'package:aj_autofix/bloc/review/review_event.dart';
import 'package:aj_autofix/bloc/service/selected_services_bloc.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/repositories/admin_repository_impl.dart';
import 'package:aj_autofix/repositories/auth_repository_impl.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/repositories/contact_repository_impl.dart';
import 'package:aj_autofix/repositories/review_repository_impl.dart';
import 'package:aj_autofix/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("7adf71e0-29d4-45cc-be81-e3fd7d04a32d");
  OneSignal.Notifications.requestPermission(true);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(BookingRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => UserBloc(AdminRepositoryImpl())..add(GetUsers()),
        ),
        BlocProvider(
          create: (context) =>
              BookingBloc(BookingRepositoryImpl())..add(GetAllPendingBooking()),
        ),
        BlocProvider(
          create: (context) =>
              BookingBloc(BookingRepositoryImpl())..add(GetUserBooking()),
        ),
        BlocProvider(
          create: (context) =>
              BookingBloc(BookingRepositoryImpl())..add(GetBooking()),
        ),
        BlocProvider(
          create: (context) =>
              BookingBloc(BookingRepositoryImpl())..add(GetBooking()),
        ),
        BlocProvider(
          create: (context) =>
              UserBloc(AdminRepositoryImpl())..add(GetUserByAuthEvent()),
        ),
        BlocProvider(
          create: (context) =>
              ReviewBloc(ReviewRepositoryImpl())..add(FetchReviews()),
        ),
        BlocProvider(
          create: (context) => ContactBloc(ContactRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => SelectedServicesBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
