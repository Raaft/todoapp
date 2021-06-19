import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/states.dart';
import 'package:todoapp/screens/homePage.dart';

import 'cubit/bloc_obsirve.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoCubit>(
        create: (BuildContext context) => TodoCubit()..createDatabase(),
        child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(primaryColor: Colors.lightGreen,accentColor: Colors.lightGreen,primarySwatch: Colors.lightGreen  ),
                home: HomePageScreen(),
              );
            }));
  }
}
