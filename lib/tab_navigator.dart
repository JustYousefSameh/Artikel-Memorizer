import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/table_bloc.dart';
import 'ArtikelScreen/artikel_window.dart';
import 'DatabaseScreen/tables_editor.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({
    this.navigatorKey,
    this.tabItem,
    required this.oldContext,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? tabItem;
  final BuildContext oldContext;

  @override
  Widget build(BuildContext context) {
    Widget child = PickATable();
    if (tabItem == "Page1") {
      child = PickATable();
    } else if (tabItem == "Page2") {
      child = TablesShower();
    }

    return BlocProvider.value(
      value: BlocProvider.of<TableBloc>(oldContext),
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => child);
        },
        observers: [
          HeroController(),
        ],
      ),
    );
  }
}
