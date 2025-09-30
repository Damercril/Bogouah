import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/onboarding_model.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController _controller = OnboardingController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => _finishOnboarding(),
                  child: Text(
                    'Passer',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _controller.pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(context, onboardingData[index]);
                },
              ),
            ),
            
            // Page indicator and buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _controller.pageController,
                    count: onboardingData.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: theme.colorScheme.primary,
                      dotColor: theme.colorScheme.primary.withOpacity(0.3),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                      expansionFactor: 3,
                    ),
                  ),
                  
                  // Next/Finish button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == onboardingData.length - 1) {
                        _finishOnboarding();
                      } else {
                        _controller.nextPage();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == onboardingData.length - 1 ? 'Commencer' : 'Suivant',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, OnboardingModel data) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.contain,
              ).animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut),
            ),
          ),
          
          // Title
          Text(
            data.title,
            style: theme.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ).animate()
            .fadeIn(delay: 300.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 500.ms, curve: Curves.easeOut),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            data.description,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ).animate()
            .fadeIn(delay: 500.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0, delay: 500.ms, duration: 500.ms, curve: Curves.easeOut),
          
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _finishOnboarding() async {
    await _controller.completeOnboarding();
    if (mounted) {
      context.go('/login');
    }
  }
}
