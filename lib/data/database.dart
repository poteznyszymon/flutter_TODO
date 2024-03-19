import 'package:hive/hive.dart';

class ToDoDataBase {
  List Tasks = [];

  final _myBox = Hive.box('mybox');

  void createInitalData() {
    Tasks = [
      ['Do exercise', false],
      ['Make project', false],
      ['Do loundry', false],
      ['Make dinner', false],
      ['Read book', false],
    ];
  }

  void loadData() {
    Tasks = _myBox.get('TODOLIST');
  }

  void updateData() {
    _myBox.put('TODOLIST', Tasks);
  }
}
