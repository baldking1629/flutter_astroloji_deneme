import 'package:flutter/material.dart';
import 'package:dreamscope/presentation/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.all(32),
                child: Icon(Icons.nightlight_round, size: 64, color: AppTheme.darkTheme.colorScheme.secondary),
              ),
              const SizedBox(height: 32),
              Text(
                'DreamScope',
                style: AppTheme.darkTheme.textTheme.displayLarge?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 