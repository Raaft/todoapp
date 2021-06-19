import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/cubit/states.dart';
import 'package:todoapp/screens/navBarScreens/archivedScreen.dart';
import 'package:todoapp/screens/navBarScreens/doneScreen.dart';
import 'package:todoapp/screens/navBarScreens/tasksScreen.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool fIcon = true;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  int currentIndex = 0;

  Database database;

  List<Widget> bottomNav = [TasksScreen(), DoneScreen(), ArchivedScreen()];

  void changIndex(index) {
    currentIndex = index;
    emit(TodoBottomNavState());
  }

  void changeIcon() {
    fIcon = !fIcon;
    emit(IconBottom());
  }

  createDatabase() {
    openDatabase(
      "contact.db",
      version: 1,
      onCreate: (database, version) {
        print('database crested');
        database
            .execute(
                'CREATE TABLE Test  (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)')
            .then((value) {
          print('table crested');
        }).catchError(
          (error) {
            print('database error $error');
          },
        );
        emit(OnCreateDataBase());
      },
      onOpen: (database) async {
        getFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDataBase());
    });
  }

  insertToDatabase(
      {@required String title, @required date, @required String time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO Test (title , date , time ,status) VALUES("$title", "$date" ,"$time" , "new" )')
          .then((value) {
        print('$value inserted to database');
        emit(InsertDataBase());
        getFromDatabase(database);
      }).catchError((error) {
        print('error $error');
      });

      return null;
    });
  }

  getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database.rawQuery("SELECT * FROM Test ").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == "done") {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(GetFromDataBase());
    });
  }

  void updateData({@required String status, @required int id}) {
    database.rawUpdate('UPDATE Test SET status = ?  WHERE id = ?',
        ["$status", id]).then((value) {
      getFromDatabase(database);
      emit(UpDataDataBase());
    });
  }

  void deleteData({ @required int id}) {
    database..rawDelete('DELETE FROM Test WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(DeleteDataBase());
    });
  }
}
