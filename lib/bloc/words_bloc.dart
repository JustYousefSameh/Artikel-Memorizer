import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/deutsch_word.dart';
import 'package:pomodoro_app/words_database.dart';

abstract class WordEvent {}

class InitWord extends WordEvent {
  final int index;

  InitWord(this.index);
}

class WordChanged extends WordEvent {}

enum DataState { initialzing, done }

class WordState {
  final List<DeutschWord> words;
  final String tableName;
  final int tableIndex;
  final DataState dataState;

  const WordState(
      {this.words = const <DeutschWord>[],
      this.tableName = "",
      this.tableIndex = 0,
      this.dataState = DataState.initialzing});
}

class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc() : super(const WordState()) {
    on<InitWord>(_onInitWord);
    on<WordChanged>(_onWordChanged);
  }

  Future<void> _onInitWord(
    InitWord event,
    Emitter<WordState> emit,
  ) async {
    final tables = await WordsDataBase.instance.getTableNames();
    final tableName = tables[event.index];
    final words = await WordsDataBase.instance.readAllWords(tableName);

    emit(
      WordState(
          words: words,
          tableName: tableName,
          tableIndex: event.index,
          dataState: DataState.done),
    );
  }

  Future<void> _onWordChanged(
      WordChanged event, Emitter<WordState> emit) async {
    final tables = await WordsDataBase.instance.getTableNames();
    final tableName = tables[state.tableIndex];
    final words = await WordsDataBase.instance.readAllWords(tableName);

    emit(
      WordState(
        words: words,
        tableName: tableName,
        dataState: DataState.done,
      ),
    );
  }
}
