import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/words_database.dart';

abstract class TableEvent {}

class TableChanged extends TableEvent {}

class TableBloc extends Bloc<TableEvent, List<String>> {
  TableBloc() : super(const <String>[]) {
    on<TableChanged>(_onWordChanged);
  }

  Future<void> _onWordChanged(
    TableChanged event,
    Emitter<List<String>> emit,
  ) async {
    final tables = await WordsDataBase.instance.getTableNames();
    Future.delayed(Duration.zero);
    emit(tables);
  }
}
