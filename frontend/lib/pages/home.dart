import 'package:frontend/common_widgets.dart/loader.dart';
import 'package:frontend/common_widgets.dart/text_style.dart';
import 'package:frontend/common_widgets.dart/todo_container.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/consts.dart';
import 'package:frontend/controllers/home_controller.dart';
import 'package:frontend/models/to_do.dart';
import 'package:frontend/pages/show_todo.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initializing HomeController
  var homeController = Get.put(HomeController());
  // todo list
  // List<Todo> my_todos = [];
  // bool isLoading = true;
  // int done = 0;

  // init state; calls first when home page loads
  // @override
  // void initState() {
  //   homeController.fetchData(context).then((value) {
  //     setState(() {
  //       my_todos = value['todoList'];
  //       done = value['doneCount'];
  //       isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: "Todo's App", color: whiteColor, size: 20.0),
        centerTitle: true,
        backgroundColor: purpleColor,
      ),
      body: StreamBuilder(
          stream: homeController.fetchData(context),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              final Map data = snapshot.data!;
              final List<Todo> todoList = data['todoList'];
              final int doneCount = data['doneCount'];

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.heightBox,
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: boldText(
                              text: "Your Activities Performance:",
                              color: blackColor,
                              size: 20.0),
                        ),
                        10.heightBox,
                        PieChart(dataMap: {
                          "Done": doneCount.toDouble(),
                          "Incomplete": (todoList.length - doneCount).toDouble()
                        })
                      ],
                    )
                        .box
                        .color(whiteColor)
                        .shadowSm
                        .padding(const EdgeInsets.all(8))
                        .make(),
                    20.heightBox,
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: boldText(
                          text: "Your Todo's:", color: blackColor, size: 22.0),
                    ),
                    5.heightBox,
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 20),
                      child: Column(
                        children: todoList.map((todo) {
                          return TodoContainer(
                            id: todo.id,
                            title: todo.title,
                            desc: todo.desc,
                            isDone: todo.isDone,
                            date: todo.date,
                            // delete data from database
                            DeleteOnPress: () {
                              homeController
                                  .delete_todo(todo.id.toString(), context)
                                  .then((value) {
                                setState(() {
                                  homeController.fetchData(context);
                                });
                              });
                            },
                            // update data from database
                            EditOnPress: () {
                              homeController
                                  .put_data(
                                      context: context,
                                      id: todo.id.toString(),
                                      title: homeController
                                          .editTitleController.text,
                                      desc: homeController
                                          .editDescController.text,
                                      isDone: homeController.checkDone.value)
                                  .then((value) {
                                setState(() {
                                  homeController.fetchData(context);
                                });
                                Navigator.pop(context);
                              });
                            },
                          ).onTap(() {
                            Get.to(() => ShowTodo(
                                  title: todo.title,
                                  desc: todo.desc,
                                  date: todo.date,
                                  isDone: todo.isDone,
                                ));
                          });
                        }).toList(),
                      ),
                    ),
                    50.heightBox
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loadingIndicator(color: purpleColor),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: normalText(
                    text: "Something went wrong!",
                    color: blackColor,
                    size: 16.0),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: normalText(
                  text: "No data available",
                  color: blackColor,
                  size: 16.0,
                ),
              );
            }
            return widget;
          }),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AnimatedContainer(
                width: context.screenWidth,
                height: context.screenHeight / 1.8,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                color: purpleColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  children: [
                    10.heightBox,
                    boldText(
                        text: "Add your Todo", color: whiteColor, size: 18.0),
                    25.heightBox,
                    TextField(
                      cursorColor: whiteColor,
                      controller: homeController.titleController,
                      style: const TextStyle(color: whiteColor),
                      decoration: const InputDecoration(
                        focusColor: whiteColor,
                        hintText: "Title",
                        hintStyle: TextStyle(color: whiteColor),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    10.heightBox,
                    TextField(
                      cursorColor: whiteColor,
                      controller: homeController.descController,
                      maxLines: 3,
                      style: const TextStyle(color: whiteColor),
                      decoration: const InputDecoration(
                        focusColor: whiteColor,
                        hintText: "Description",
                        hintStyle: TextStyle(color: whiteColor),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    10.heightBox,
                    const Spacer(),
                    ElevatedButton(
                      // adding data to database
                      onPressed: () {
                        homeController
                            .post_data(
                                context: context,
                                title: homeController.titleController.text,
                                desc: homeController.descController.text)
                            .then((value) {
                          setState(() {
                            homeController.fetchData(context);
                          });
                        });
                        Navigator.pop(context);
                        homeController.titleController.clear();
                        homeController.descController.clear();
                      },
                      // ignore: sort_child_properties_last
                      child: boldText(text: "Save", color: purpleColor),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: whiteColor,
                      ),
                    ),
                    10.heightBox
                  ],
                ),
              );
            },
            isScrollControlled: true,
          );
        },
        backgroundColor: purpleColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }
}
