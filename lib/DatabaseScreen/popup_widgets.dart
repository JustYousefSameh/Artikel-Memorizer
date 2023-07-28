import 'package:flutter/material.dart';
import 'package:pomodoro_app/bloc/table_bloc.dart';
import 'package:pomodoro_app/bloc/words_bloc.dart';
import 'package:pomodoro_app/deutsch_word.dart';
import 'package:pomodoro_app/words_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCardPopup extends StatelessWidget {
  void editWordInDatebase(String text) {
    if (text == "") return;
    var artikle = text.substring(0, 3).toLowerCase();
    if (artikle == 'der' || artikle == 'das' || artikle == 'die') {
      var word =
          text.toLowerCase().replaceAll(artikle, "").trim().toCapitalized();
      WordsDataBase.instance.update(DeutschWord(id, artikle, word), tableName);
    }
  }

  final String tableName;
  final String heroTag;
  final int id;

  EditCardPopup(
      {required this.heroTag, required this.id, required this.tableName});
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: heroTag,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    TextField(
                      controller: controller,
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                      decoration: InputDecoration(
                        hintText: 'edit word',
                        border: InputBorder.none,
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          editWordInDatebase(controller.text);
                          context.read<WordBloc>().add(WordChanged());
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Material(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            child: Center(
                              child: Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class AddWordPopup extends StatelessWidget {
  AddWordPopup({
    required this.addToList,
    required this.tableName,
  });
  final String tableName;
  final Function(DeutschWord) addToList;
  final myController = TextEditingController();

  DeutschWord? addWordToDatebase(String text) {
    if (text == "") return null;
    var artikle = text.substring(0, 3).toLowerCase();
    if (artikle == 'der' || artikle == 'das' || artikle == 'die') {
      var word =
          text.toLowerCase().replaceAll(artikle, "").trim().toCapitalized();

      if (word.length >= 2) {
        return DeutschWord(null, artikle, word);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'add-word-popup',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    TextField(
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                      controller: myController,
                      decoration: InputDecoration(
                        hintText: 'add word',
                        border: InputBorder.none,
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          var word = addWordToDatebase(myController.text);
                          if (word != null) {
                            WordsDataBase.instance.create(word, tableName);
                            addToList(word);
                            context.read<WordBloc>().add(WordChanged());
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Error',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              "Not a valid word",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Material(
                          elevation: 10,
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
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

class EditTablePopup extends StatelessWidget {
  const EditTablePopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Center(
      child: Hero(
        tag: 'edit-table-popup',
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    TextField(
                      controller: controller,
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                      decoration: InputDecoration(
                        hintText: 'edit title',
                        border: InputBorder.none,
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          WordsDataBase.instance.alterTableName(
                              context.read<WordBloc>().state.tableName,
                              controller.text);
                          // tableName = controller.text;
                          context.read<WordBloc>().add(WordChanged());
                          context.read<TableBloc>().add(TableChanged());
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Material(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            child: Center(
                              child: Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
