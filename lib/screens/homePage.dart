import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/states.dart';

import '../compontants.dart';

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(listener: (context, state) {
      if (state is InsertDataBase) Navigator.pop(context);
    }, builder: (context, state) {
      var cubit = TodoCubit.get(context);
      return Scaffold(
        key: cubit.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: Text('Remind Me',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.lightGreen)),
          centerTitle: true,
        ),
        body: TodoCubit.get(context).bottomNav[cubit.currentIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: !cubit.fIcon ? Icon(Icons.add) : Icon(Icons.edit),
          onPressed: () {
            if (!cubit.fIcon) {
              if (cubit.formKey.currentState.validate()) {
                cubit.insertToDatabase(
                    title: cubit.titleController.text,
                    date: cubit.dateController.text,
                    time: cubit.timeController.text);

                cubit.titleController.clear();
                cubit.dateController.clear();
                cubit.timeController.clear();
              }
            } else {
              cubit.scaffoldKey.currentState
                  .showBottomSheet<dynamic>(
                      (context) => bottomSheet(context, cubit))
                  .closed
                  .then((value) => cubit.changeIcon());
              cubit.changeIcon();
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightGreen,
          onTap: (value) {
            TodoCubit.get(context).changIndex(value);
          },
          currentIndex: TodoCubit.get(context).currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: "Tasks",
              backgroundColor: Colors.lightBlueAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_done_rounded),
              label: "Done",
              backgroundColor: Colors.lightBlueAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: "Archived",
              backgroundColor: Colors.lightBlueAccent,
            ),
          ],
        ),
      );
    });
  }
}
