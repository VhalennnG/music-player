import 'package:flutter/material.dart';
import 'package:musicplayer/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;

  const NeuBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // is dark mode
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // darker shadow on bottom right
            BoxShadow(
                color: isDarkMode ? Colors.black : Colors.grey.shade300,
                blurRadius: 15,
                offset: const Offset(4, 4)),

            // lighter shadow on top left
            BoxShadow(
                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                blurRadius: 15,
                offset: const Offset(-4, -4))
          ]),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
