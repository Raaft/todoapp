import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/cubit/cubit.dart';

Widget buildRowItem(context, task, TodoCubit cubit, Color color) {
  var height= MediaQuery.of(context).size.height;
  var width= MediaQuery.of(context).size.width;
  return Dismissible(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 1, right: 10, left: 10, top: 5),
      child: Card(
        child: Container(
          height:(width>height)?width/2:height/7,
          width: width,
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  radius: 50,
                  backgroundColor: color,
                  child: Text('${task['time']}')),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                   mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(task['title'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),maxLines: 3,),
                    Text('${task['date']}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'done', id: task['id']);
                  },
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'archive', id: task['id']);
                  },
                  icon: Icon(
                    Icons.archive_outlined,
                    color: Colors.black26,
                  ))
            ],
          ),
        ),
      ),
    ),
    key: Key(task['id'].toString()),
    onDismissed: (direction) {
      cubit.deleteData(id: task['id']);
    },
  );
}

Widget bottomSheet(context, cubit) {
  return Container(
    color: Colors.lightGreen.shade50,
    padding: EdgeInsets.all(20),
    child: Form(
      key: cubit.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1,bottom: 5),
            child: Icon(Icons.arrow_downward,color: Colors.red),
          ),
          TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(55),
            ],
            controller: cubit.titleController,
            keyboardType: TextInputType.text,
            validator: (String val) {
              if (val.isEmpty) {
                return "Enter Your Task title";
              } else
                return null;
            },
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.short_text),
                labelText: "Task title",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                    gapPadding: 5)),
          ),
          SizedBox(height: 8),
          TextFormField(
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.parse('2022-05-01'))
                  .then((value) => cubit.dateController.text =
                      DateFormat.yMMMEd().format(value).toString());
            },
            controller: cubit.dateController,
            keyboardType: TextInputType.datetime,
            validator: (String val) {
              if (val.isEmpty) {
                return "Enter Your Task date";
              } else
                return null;
            },
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                labelText: "Task date",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                    gapPadding: 5)),
          ),
          SizedBox(height: 8),
          TextFormField(
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((value) => cubit.timeController.text =
                      value.format(context).toString());
            },
            controller: cubit.timeController,
            keyboardType: TextInputType.datetime,
            validator: (String val) {
              if (val.isEmpty) {
                return "Enter Your Task time";
              } else
                return null;
            },
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.watch),
                labelText: "Task time",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5),
                    gapPadding: 5)),
          )
        ],
      ),
    ),
  );
}
