import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/'); // Navigate to home
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ).animate()
              .scale(duration: 600.ms, curve: Curves.easeOutBack)
              .rotate(duration: 800.ms, begin: -0.2, end: 0)
              .shimmer(delay: 1000.ms, duration: 1000.ms),
            
            const SizedBox(height: AppConstants.p24),
            
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ).animate()
              .fadeIn(delay: 500.ms, duration: 800.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
              
            const SizedBox(height: AppConstants.p12),

             Text(
              'Your thoughts in style.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
