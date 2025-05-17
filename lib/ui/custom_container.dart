import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  // final String? imageName;

  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: child,
    );
  }
}
