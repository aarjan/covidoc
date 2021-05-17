import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
    this.onSelected,
  }) : super(key: key);

  final Function(int)? onSelected;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.WHITE1,
      currentIndex: _selectedIndex,
      onTap: (index) {
        widget.onSelected!(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
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
