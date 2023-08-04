import 'package:flutter/material.dart';

class BarIcons {
  BottomNavigationBarItem item(double sizew, double sizeh, String label,
      double ic, bool sel, String icon) {
    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        height: sizeh,
        width: sizew,
        child: ImageIcon(
          Image.asset(
            icon,
            width: ic,
            height: ic,
            color: sel ? const Color.fromARGB(255, 53, 131, 192) : Colors.grey,
          ).image,
          size: ic,
          color: sel ? const Color.fromARGB(255, 53, 131, 192) : Colors.grey,
        ),
      ),
    );
  }
}
