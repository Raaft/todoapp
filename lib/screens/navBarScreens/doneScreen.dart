import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/states.dart';

import '../../compontants.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TodoCubit.get(context);
          List tasks = cubit.doneTasks;
          return tasks.length == 0
              ? Center(child:  Text('No done yet'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) =>
                      buildRowItem(context, tasks[index], cubit, Colors.green),
                );
        });
  }
}
