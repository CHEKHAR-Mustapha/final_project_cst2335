import 'package:flutter/material.dart';

/// A widget that builds its child based on the screen size.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isMobile) builder;

  /// Constructor for ResponsiveBuilder, requires a builder function that takes context and a boolean indicating if the screen is mobile-sized.
  const ResponsiveBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isMobile = screenWidth < 600;
    return builder(context, isMobile);
  }
}