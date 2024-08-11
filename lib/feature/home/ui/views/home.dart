// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate/core/core.dart';
import 'package:real_estate/feature/home/ui/views/home_screen.dart';
import 'package:real_estate/feature/home/ui/views/location_screen.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  static const route = 'home_screen';

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  int _currentIndex = 2;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _tabIconsAnimation;
  late AnimationController _tabIconsController;

  final _screens = [
    (icon: SvgAssets.search, widget: LocationMapScreen()),
    (icon: SvgAssets.message, widget: Text('Messages Screen')),
    (icon: SvgAssets.home, widget: HomeScreen()),
    (icon: SvgAssets.heart, widget: Text('Favorites Screen')),
    (icon: SvgAssets.user, widget: Text('Profile Screen')),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _tabIconsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _tabIconsAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _tabIconsController,
      curve: Curves.easeInOut,
    ));

    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(seconds: 4), () {
        _tabIconsController.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabIconsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_currentIndex].widget,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _tabIconsAnimation,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 40),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kBottomTabColor,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < _screens.length; i++) ...{
                        _tabIcons(i, _screens[i].icon),
                        if (i != _screens.length - 1) ...{
                          const SizedBox(width: 5),
                        }
                      }
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabIcons(int index, String asset) {
    return GestureDetector(
      onTap: () => setState(() {
        _currentIndex = index;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInCirc,
        width: _currentIndex == index ? 50 : 44,
        height: _currentIndex == index ? 50 : 44,
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? kBottomContainerSwicthTabColor
              : kBottomContainerTabColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(asset, width: 24, height: 24),
        ),
      ),
    );
  }
}
