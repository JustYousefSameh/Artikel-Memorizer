import 'package:flutter/material.dart';
import 'package:pomodoro_app/bloc/theme_bloc.dart';
import 'package:pomodoro_app/words_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/table_bloc.dart';
import './tab_navigator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WordsDataBase.instance.getTableNames();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc()..add(InitTheme()),
      child: BlocBuilder<ThemeBloc, bool>(
        builder: ((context, state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state
                ?
                // Dark Theme
                ThemeData(
                    textTheme:
                        TextTheme(bodyMedium: TextStyle(color: Colors.white)),
                    appBarTheme: AppBarTheme(
                      backgroundColor: Color.fromARGB(255, 35, 39, 42),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                    scaffoldBackgroundColor: Color.fromARGB(255, 35, 39, 42),
                    brightness: Brightness.dark,
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      brightness: Brightness.dark,
                      primary: Color.fromARGB(255, 35, 39, 42),
                      secondary: Color.fromARGB(255, 44, 47, 51),
                    ),
                  )

                //Light Theme
                : ThemeData(
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        selectedIconTheme:
                            IconThemeData(color: Colors.blueAccent),
                        unselectedIconTheme:
                            IconThemeData(color: Colors.blueAccent),
                        backgroundColor: Colors.blueAccent),
                    appBarTheme: AppBarTheme(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                    scaffoldBackgroundColor: Colors.white,
                    brightness: Brightness.light,
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      brightness: Brightness.light,
                      primary: Colors.white,
                      secondary: Colors.blueAccent,
                    ),
                  ),
            home: MainWindow())),
      ),
    );
  }
}

class MainWindow extends StatefulWidget {
  const MainWindow();

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  int _selectedIndex = 0;
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(
        () {
          _currentPage = pageKeys[index];
          _selectedIndex = index;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Page1") {
            _selectTab("Page1", 1);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: BlocProvider(
          create: (_) => TableBloc()..add(TableChanged()),
          child: BlocBuilder<TableBloc, List<String>>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  _buildOffstageNavigator("Page1", context),
                  _buildOffstageNavigator("Page2", context),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          // fixedColor: Theme.of(context).colorScheme.primary,
          // fixedColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          iconSize: 30,
          // showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          fixedColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,

          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            BottomNavigationBarItem(
              label: "Sets",
              icon: Icon(Icons.table_rows_rounded),
              activeIcon: Icon(Icons.table_rows_rounded),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            _selectTab(pageKeys[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem, BuildContext context) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        oldContext: context,
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
