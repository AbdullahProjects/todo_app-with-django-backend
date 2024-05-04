import 'dart:convert';
import 'package:frontend/constants/consts.dart';
import 'package:frontend/models/to_do.dart';
import 'package:http/http.dart' as http;

class HomeController {
  var isLoading = false.obs;
  var checkDone = false.obs;
  // add todo controllers
  var titleController = TextEditingController();
  var descController = TextEditingController();
  // update todo controllers
  var editTitleController = TextEditingController();
  var editDescController = TextEditingController();
  // control text limit
  String shortenText(String text, int limit) {
    if (text.length > limit) {
      return "${text.substring(0, limit)}...";
    } else {
      return text;
    }
  }

  // fetching data
  Stream<Map> fetchData(context) async* {
    List<Todo> my_todos = [];
    int done = 0;
    try {
      var path = Uri.parse(api);
      var response = await http.get(path);
      var data = json.decode(response.body);
      data.forEach(
        (todos) {
          Todo t = Todo(
              id: todos['id'],
              title: todos['title'],
              desc: todos['desc'],
              isDone: todos['isDone'],
              date: todos['date']);
          if (todos['isDone'] == true) {
            done += 1;
          }
          my_todos.add(t);
        },
      );
      yield {"todoList": my_todos, "doneCount": done};
    } catch (e) {
      VxToast.show(context, msg: e.toString(), showTime: 5000);
    }
    yield {"todoList": my_todos, "doneCount": done};
  }

  // delete data
  Future<void> delete_todo(String id, context) async {
    try {
      http.Response response = await http.delete(Uri.parse(api + "/" + id));
      fetchData(context);
    } catch (e) {
      VxToast.show(context, msg: e.toString(), showTime: 5000);
    }
  }

  // add data
  Future<void> post_data({String title = "", String desc = "", context}) async {
    try {
      if (titleController.text.trim().isEmpty ||
          descController.text.trim().isEmpty) {
        VxToast.show(context, msg: "Fields should not be empty");
      } else {
        http.Response response = await http.post(
          Uri.parse(api),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, dynamic>{'title': title, 'desc': desc, 'isDone': false}),
        );
        if (response.statusCode == 201) {
          fetchData(context);
        } else {
          VxToast.show(context, msg: "Something went wrong!", showTime: 5000);
        }
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString(), showTime: 5000);
    }
  }

  // update data
  Future<void> put_data(
      {String id = "",
      String title = "",
      String desc = "",
      bool isDone = false,
      context}) async {
    try {
      if (editTitleController.text.trim().isEmpty ||
          editDescController.text.trim().isEmpty) {
        VxToast.show(context, msg: "Fields should not be empty");
      } else {
        http.Response response = await http.put(
          Uri.parse(api + "/" + id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'title': title,
            'desc': desc,
            'isDone': isDone
          }),
        );
        if (response.statusCode == 201) {
          fetchData(context);
        }
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString(), showTime: 5000);
    }
  }
}
