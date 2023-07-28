import 'package:flutter/material.dart';
import 'package:pomodoro_app/DatabaseScreen/database_editor_window.dart';
import 'package:pomodoro_app/bloc/table_bloc.dart';
import 'package:pomodoro_app/bloc/theme_bloc.dart';
import 'package:pomodoro_app/custom_rect_tween.dart';
import 'package:pomodoro_app/hero_dialog_route.dart';
import '../words_database.dart';
import '../custom_page_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablesShower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artikel Memorizer"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(
                Icons.dark_mode_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () {
                context.read<ThemeBloc>().add(ThemeChanged());
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<TableBloc, List<String>>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.length,
                itemBuilder: ((context, index) {
                  return tableTile(context, index);
                }),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Hero(
                tag: 'add-table-popup',
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    //Add table button bottom-right corner.
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        HeroDialogRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: context.read<TableBloc>(),
                            child: AddTablePopup(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.add,
                      color: context.read<ThemeBloc>().state
                          ? Theme.of(context).textTheme.bodyMedium!.color
                          : Theme.of(context).colorScheme.secondary,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tableTile(BuildContext context, int index) {
    return Material(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: GestureDetector(
                //Takes you to the words screen
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CustomPageRoute(
                      builder: (newContext) => BlocProvider.value(
                        value: context.read<TableBloc>(),
                        child: DatabaseWindow(
                          passedIndex: index,
                          passedTableName: WordsDataBase.tables[index],
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    WordsDataBase.tables[index],
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ),
              ),
            ),
            GestureDetector(
              //Delete Table Button
              onTap: () {
                WordsDataBase.instance.deleteTable(WordsDataBase.tables[index]);
                context.read<TableBloc>().add(TableChanged());
              },
              child: Icon(
                Icons.delete,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTablePopup extends StatelessWidget {
  const AddTablePopup({
    super.key,
  });
//add-table-popup
  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Hero(
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            tag: 'add-table-popup',
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: TextStyle(
                            fontSize: 25,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        decoration: InputDecoration(
                          hintText: 'lesson name, unit number..',
                          border: InputBorder.none,
                        ),
                        cursorColor:
                            Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    ElevatedButton(
                      //Add table to database
                      onPressed: () {
                        WordsDataBase.instance.addTable(controller.text);
                        context.read<TableBloc>().add(TableChanged());
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(45, 45),
                          shape: CircleBorder(),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      child: Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
