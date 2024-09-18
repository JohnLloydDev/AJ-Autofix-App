import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/repositories/admin_repository_impl.dart';
import 'package:aj_autofix/repositories/auth_repository_impl.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepositoryImpl()),
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
              BookingBloc(BookingRepositoryImpl())..add(GetBooking()),
        ),
        BlocProvider(
          create: (context) =>
              BookingBloc(BookingRepositoryImpl())..add(GetBooking()),
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
