import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/core/config/local_storage.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/bloc/application_bloc.dart';
import 'package:jobconnect/presentation/screens/employee/job_list_screen.dart';
import 'package:jobconnect/presentation/screens/employee/my_applications_screen.dart';
import 'package:jobconnect/presentation/screens/employee/profile_screen.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const JobListScreen(),
    const MyApplicationsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final userId = await LocalStorage().getUserId();
    if (userId != null && mounted) {
      // Load jobs
      context.read<JobBloc>().add(const FetchAllJobsEvent());
      // Load applications
      context
          .read<ApplicationBloc>()
          .add(FetchApplicationsByApplicantIdEvent(applicantId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Offres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Mes Candidatures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Profil',
          ),
        ],
      ),
    );
  }
}
