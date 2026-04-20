import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppTheme.primaryBlue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'J',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontSize: 80,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'JobConnect',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppTheme.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Trouvez votre emploi idéal',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 64),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
            ),
          ],
        ),
      ),
    );
  }
}
