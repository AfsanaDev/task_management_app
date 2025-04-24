import 'package:flutter/material.dart';

class CenteredCirculerProgressIndicator extends StatefulWidget {
  const CenteredCirculerProgressIndicator({super.key});

  @override
  State<CenteredCirculerProgressIndicator> createState() => _CenteredCirculerProgressIndicatorState();
}

class _CenteredCirculerProgressIndicatorState extends State<CenteredCirculerProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}