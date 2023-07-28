import 'package:flutter/material.dart';

/// {@template hero_dialog_route}
/// Custom [PageRoute] that creates an overlay dialog (popup effect).
///
/// Best used with a [Hero] animation.
/// {@endtemplate}
class CustomPageRoute<T> extends MaterialPageRoute {
  /// {@macro hero_dialog_route}
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  CustomPageRoute({builder}) : super(builder: builder);
}
