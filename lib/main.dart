import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_app/bloc/auth/auth_bloc.dart';
import 'package:task_app/bloc/dashboard/dashboard_bloc.dart';
import 'package:task_app/screens/splash/splash_screen.dart';
import 'package:task_app/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => DashboardBloc()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.purple,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
