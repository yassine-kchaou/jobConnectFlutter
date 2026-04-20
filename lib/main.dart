import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jobconnect/config/service_locator.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/presentation/bloc/auth_bloc.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/bloc/application_bloc.dart';
import 'package:jobconnect/presentation/bloc/resume_bloc.dart';
import 'package:jobconnect/presentation/screens/auth/login_screen.dart';
import 'package:jobconnect/presentation/screens/company/company_home_screen.dart';
import 'package:jobconnect/presentation/screens/company/create_job_screen.dart';
import 'package:jobconnect/presentation/screens/employee/employee_home_screen.dart';
import 'package:jobconnect/presentation/screens/splash_screen.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await LocalStorage().initialize();

  // Setup service locator
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              GetIt.instance<AuthBloc>()..add(const AuthCheckStatusEvent()),
        ),
        BlocProvider<JobBloc>(create: (_) => GetIt.instance<JobBloc>()),
        BlocProvider<ApplicationBloc>(
            create: (_) => GetIt.instance<ApplicationBloc>()),
        BlocProvider<ResumeBloc>(create: (_) => GetIt.instance<ResumeBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JobConnect',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.light,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              if (state.role == 'entreprise') {
                return const CompanyHomeScreen();
              } else {
                return const EmployeeHomeScreen();
              }
            } else if (state is AuthUnauthenticated) {
              return const LoginScreen();
            }
            return const SplashScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/employee-home': (context) => const EmployeeHomeScreen(),
          '/company-home': (context) => const CompanyHomeScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/create-job') {
            return MaterialPageRoute(
              builder: (_) => const CreateJobScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}
