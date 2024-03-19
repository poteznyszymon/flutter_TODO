import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  final TextEditingController _taskname = TextEditingController();

  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitalData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void changeActivity(int index) {
    setState(() {
      if (db.Tasks[index][1]) {
        db.Tasks[index][1] = false;
      } else {
        db.Tasks[index][1] = true;
      }
    });
    db.updateData();
  }

  void deleteTask(int index) {
    setState(() {
      db.Tasks.removeAt(index);
    });
    db.updateData();
  }

  void addTask() {
    setState(() {
      if (_taskname.text != '') {
        db.Tasks.add([_taskname.text, false]);
        db.updateData();
      }
    });
    _taskname.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            actions: [
              Column(
                children: [
                  Text(
                    'Add task',
                    style: GoogleFonts.bebasNeue(fontSize: 20),
                  ),
                  TextField(
                    controller: _taskname,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => addTask(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: Text(
                        'ADD',
                        style: GoogleFonts.inter(),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        hoverColor: Colors.grey,
        hoverElevation: 10,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today",
              style: GoogleFonts.bebasNeue(fontSize: 80),
            ),
            Text(
              '${now.day} ${DateFormat('MMMM').format(now)},${now.year} • ${DateFormat('EEEE').format(now)}',
              style: GoogleFonts.bebasNeue(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.zero,
                itemExtent: 80,
                itemCount: db.Tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => deleteTask(index),
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            db.Tasks[index][0],
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis, // Dodaj overflow
                          ),
                        ),
                        leading: IconButton(
                          onPressed: () => changeActivity(index),
                          icon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Icon(
                              Icons.circle,
                              color: db.Tasks[index][1] == false
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
