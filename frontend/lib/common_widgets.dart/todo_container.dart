import 'package:frontend/common_widgets.dart/text_style.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/consts.dart';
import 'package:frontend/controllers/home_controller.dart';

class TodoContainer extends StatefulWidget {
  final int id;
  final String title;
  final String desc;
  final bool isDone;
  final String date;
  final Function DeleteOnPress;
  final Function EditOnPress;
  const TodoContainer(
      {super.key,
      required this.id,
      required this.title,
      required this.desc,
      required this.isDone,
      required this.date,
      required this.DeleteOnPress,
      required this.EditOnPress});

  @override
  State<TodoContainer> createState() => _TodoContainerState();
}

class _TodoContainerState extends State<TodoContainer> {
  @override
  Widget build(BuildContext context) {
    // initializing HomeController
    var homeController = Get.put(HomeController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(text: widget.title, color: blackColor, size: 16.0),
                10.heightBox,
                normalText(
                    text: homeController.shortenText(widget.desc, 80),
                    color: lightBlackColor)
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
                onPressed: () => widget.DeleteOnPress(),
                icon: const Icon(
                  Icons.delete,
                  color: lightPurpleColor,
                  size: 22,
                )),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: IconButton(
              onPressed: () {
                homeController.editTitleController.text = widget.title;
                homeController.editDescController.text = widget.desc;
                homeController.checkDone(widget.isDone);
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      width: context.screenWidth,
                      height: context.screenHeight / 1.6,
                      color: purpleColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Column(
                        children: [
                          10.heightBox,
                          boldText(
                              text: "Update your Todo",
                              color: whiteColor,
                              size: 18.0),
                          20.heightBox,
                          TextField(
                            cursorColor: whiteColor,
                            controller: homeController.editTitleController,
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
                            controller: homeController.editDescController,
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
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                    value: homeController.checkDone.value,
                                    onChanged: (bool? value) {
                                      homeController.checkDone(value);
                                    }),
                              ),
                              normalText(
                                  text: "Is Done?",
                                  color: whiteColor,
                                  size: 16.0)
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                            // adding data to database
                            onPressed: () => widget.EditOnPress(),
                            // ignore: sort_child_properties_last
                            child: boldText(text: "Update", color: purpleColor),
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
              icon: const Icon(
                Icons.edit,
                color: lightPurpleColor,
                size: 20,
              ),
            ),
          ),
          widget.isDone
              ? Positioned(
                  bottom: 10,
                  right: 44,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check,
                        color: purpleColor,
                        size: 16,
                      ),
                      5.widthBox,
                      normalText(
                        text: "Done",
                        color: whiteColor,
                      ),
                      5.widthBox
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3))
                      .color(greenColor)
                      .roundedSM
                      .make(),
                )
              : Container(),
          widget.isDone
              ? Container()
              : Positioned(
                  bottom: 10,
                  right: 44,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.close,
                        color: purpleColor,
                        size: 16,
                      ),
                      5.widthBox,
                      normalText(
                        text: "Incomplete",
                        color: whiteColor,
                      ),
                      5.widthBox
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3))
                      .color(redColor)
                      .roundedSM
                      .make(),
                ),
          Positioned(
            bottom: 10,
            left: 10,
            child: normalText(
              text: widget.date.substring(0, 10),
              color: lightBlackColor,
            ),
          )
        ],
      ),
    );
  }
}
