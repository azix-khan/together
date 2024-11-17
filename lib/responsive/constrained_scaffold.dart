/* 
this is normal scaffold but the width is constrained so that it 
is behaves consistantly on larger screens ( particullarly on browsers) 
*/

import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;

  const ConstrainedScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430, // custom width
          ),
          child: body,
        ),
      ),
    );
  }
}
