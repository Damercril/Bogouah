import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';
import '../layouts/web_layout.dart';
import '../utils/responsive_helper.dart';

class MainScreenWrapper extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScreenWrapper({
    Key? key,
    required this.child,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(MainScreenWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _currentIndex = widget.currentIndex;
    }
  }

  void _onNavTap(int index, BuildContext context) {
    if (_currentIndex == index) return;
    
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/operators');
        break;
      case 2:
        context.go('/dashboard');
        break;
      case 3:
        context.go('/tickets');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  String _getCurrentRoute() {
    switch (_currentIndex) {
      case 0:
        return '/';
      case 1:
        return '/operators';
      case 2:
        return '/dashboard';
      case 3:
        return '/tickets';
      case 4:
        return '/profile';
      default:
        return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sur web (tablette/desktop), utiliser le WebLayout
    if (ResponsiveHelper.isWeb(context)) {
      return WebLayout(
        currentRoute: _getCurrentRoute(),
        child: widget.child,
      );
    }

    // Sur mobile, utiliser le layout standard avec bottom navigation
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(index, context),
      ),
    );
  }
}
