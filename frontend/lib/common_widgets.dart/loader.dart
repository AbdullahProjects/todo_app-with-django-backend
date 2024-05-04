import 'package:frontend/constants/consts.dart';

Widget loadingIndicator({color}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(color),
  );
}
