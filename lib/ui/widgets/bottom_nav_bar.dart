import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.onSelected,
    required this.selectedIndex,
  }) : super(key: key);

  final int selectedIndex;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onSelected,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: selectedIndex,
      backgroundColor: AppColors.WHITE1,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          label: 'Dashboard',
          icon: NavItem(icon: Icons.chat_outlined),
          activeIcon: NavItem(active: true, icon: Icons.chat_outlined),
        ),
        const BottomNavigationBarItem(
          label: 'Discussion',
          icon: NavItem(icon: Icons.flag_outlined),
          activeIcon: NavItem(active: true, icon: Icons.flag_outlined),
        ),
        const BottomNavigationBarItem(
          label: 'Guidelines',
          icon: NavItem(icon: Icons.receipt_long_outlined),
          activeIcon: NavItem(active: true, icon: Icons.receipt_long_outlined),
        ),
        const BottomNavigationBarItem(
          label: 'Profile',
          icon: NavItem(icon: Icons.person_outlined),
          activeIcon: NavItem(active: true, icon: Icons.person_outlined),
        ),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  final bool active;
  final IconData? icon;

  const NavItem({Key? key, this.active = false, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? AppColors.DEFAULT : AppColors.WHITE4,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: active ? AppColors.WHITE : AppColors.BLACK3),
    );
  }
}
