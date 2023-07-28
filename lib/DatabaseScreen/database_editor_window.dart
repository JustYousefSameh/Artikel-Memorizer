import 'package:flutter/material.dart';
import 'package:pomodoro_app/deutsch_word.dart';
import 'package:pomodoro_app/hero_dialog_route.dart';
import '../bloc/table_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../words_database.dart';
import './popup_widgets.dart';
import '../bloc/words_bloc.dart';

// String tableName = '';

class DatabaseWindow extends StatelessWidget {
  final String passedTableName;
  final int passedIndex;

  const DatabaseWindow({
    super.key,
    required this.passedTableName,
    required this.passedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordBloc()..add(InitWord(passedIndex)),
      child: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.tableName),
              actions: [
                addWordButton(context),
                SizedBox(width: 10),
                editTableButton(context),
                deleteAllButton(context),
              ],
            ),
            body: SafeArea(
              child: WordsEditor(),
            ),
          );
        },
      ),
    );
  }

  Widget editTableButton(BuildContext context) {
    return Hero(
      tag: 'edit-table-popup',
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              HeroDialogRoute(
                builder: (newContext) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<WordBloc>(),
                    ),
                    BlocProvider.value(
                      value: context.read<TableBloc>(),
                    )
                  ],
                  child: EditTablePopup(),
                ),
              ),
            );
          },
          child: Icon(
            Icons.edit,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }

  Widget deleteAllButton(BuildContext context) {
    return TextButton(
      child: Icon(
        Icons.delete_forever,
        color: Theme.of(context).iconTheme.color,
        size: 30,
      ),
      onPressed: () {
        while (_list._items.isNotEmpty) {
          WordsDataBase.instance
              .delete(_list[0].id!, context.read<WordBloc>().state.tableName);
          _list.removeAt(0);
        }
      },
    );
  }

  Widget addWordButton(BuildContext context) {
    return Hero(
      tag: 'add-word-popup',
      child: Center(
        child: GestureDetector(
          child: Icon(
            Icons.add,
            color: Theme.of(context).iconTheme.color,
            size: 32,
          ),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              HeroDialogRoute(
                builder: (newContext) => BlocProvider.value(
                  value: context.read<WordBloc>(),
                  child: AddWordPopup(
                    tableName: context.read<WordBloc>().state.tableName,
                    addToList: (word) {
                      _list.insert(_list.length, word);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

late ListModel<DeutschWord> _list;

class WordsEditor extends StatefulWidget {
  const WordsEditor({super.key});

  @override
  State<WordsEditor> createState() => _WordsEditorState();
}

class _WordsEditorState extends State<WordsEditor> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<DeutschWord> words = [];

  @override
  void initState() {
    super.initState();
    _list = ListModel<DeutschWord>(
      listKey: _listKey,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordBloc, WordState>(
      listener: ((context, state) {
        _list._items = state.words;
      }),
      builder: ((context, state) {
        if (state.dataState == DataState.done) {
          return AnimatedList(
            key: _listKey,
            itemBuilder: _buildItem,
            initialItemCount: _list.length,
          );
        } else {
          return Center();
        }
      }),
    );
  }

  Widget _buildRemovedItem(
    DeutschWord item,
    BuildContext context,
    Animation<double> animation,
  ) {
    return WordTile(
      word: item,
      animation: animation,
      shouldEnable: false,
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return WordTile(
      word: _list[index],
      index: index,
      animation: animation,
    );
  }
}

class WordTile extends StatelessWidget {
  WordTile({
    required this.word,
    required this.animation,
    this.index,
    this.shouldEnable,
  });

  final Animation<double> animation;
  final bool? shouldEnable;

  final DeutschWord word;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'popup-$index',
      child: SlideTransition(
        position: animation.drive(
            Tween(begin: Offset(1, 0.0), end: Offset(0.0, 0.0))
                .chain(CurveTween(curve: Curves.elasticInOut))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          child: Material(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: Theme.of(context).colorScheme.secondary,
            child: ListTile(
              title: Text(
                ("${word.artikel} ${word.word}"),
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 45,
                      child: GestureDetector(
                        //Edit word button
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onTap: () {
                          if (shouldEnable == false) {
                            Null;
                          } else {
                            Navigator.of(context, rootNavigator: true).push(
                              HeroDialogRoute(
                                builder: (newContext) => BlocProvider.value(
                                  value: context.read<WordBloc>(),
                                  child: EditCardPopup(
                                    tableName: context
                                        .read<WordBloc>()
                                        .state
                                        .tableName,
                                    id: word.id!,
                                    heroTag: 'popup-$index',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 2),
                    SizedBox(
                      width: 45,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onTap: () {
                          if (shouldEnable == false) {
                            Null;
                          } else {
                            _list.removeAt(_list.indexOf(word));
                            WordsDataBase.instance.delete(word.id!,
                                context.read<WordBloc>().state.tableName);
                          }
                        },
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

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index, duration: Duration(milliseconds: 750));
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        duration: Duration(milliseconds: 750),
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
