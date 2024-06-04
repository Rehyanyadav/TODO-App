import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:todolist/constants/colors.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/widgets/todoitems.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _todoController = TextEditingController();
  List<ToDo> _foundToDo = [];
  List<ToDo> _todosList = [];

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _saveTodoList();
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      _todosList.removeWhere((item) => item.id == id);
      _saveTodoList();
    });
  }

  void _addToDoItem(String toDO) {
    setState(() {
      _todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDO));
      _saveTodoList();
    });
    _todoController.clear();
  }

  void _runfilter(String enteredkeyword) {
    List<ToDo> results = [];
    if (enteredkeyword.isEmpty) {
      results = _todosList;
    } else {
      results = _todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  _loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todoList = prefs.getStringList('todoList');
    if (todoList != null) {
      _todosList = todoList.map((e) => ToDo.fromJson(jsonDecode(e))).toList();
      setState(() {
        _foundToDo = _todosList;
      });
    }
  }

  _saveTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoList =
        _todosList.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('todoList', todoList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Container(
                  child: Column(children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        onChanged: (value) => _runfilter(value),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            prefixIcon: Icon(
                              Icons.search,
                              color: tdblack,
                            ),
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 20, minWidth: 25),
                            border: InputBorder.none,
                            hintText: 'Search here !!',
                            hintStyle: TextStyle(color: tdgrey)),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: const Text(
                          ' All ToDo ',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      for (ToDo todo in _foundToDo)
                        Todoitems(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteTodoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                          hintText: 'Add a new todo item ',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        _addToDoItem(_todoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          iconColor: Colors.blue,
                          minimumSize: const Size(60, 60),
                          elevation: 10),
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 40),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //App bar
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 40,
      backgroundColor: tdblack,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          const Text(
            'ToDo',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/todo.png'),
              )),
        ],
      ),
    );
  }
}



