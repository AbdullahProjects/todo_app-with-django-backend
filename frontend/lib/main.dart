import 'package:frontend/constants/consts.dart';
import 'package:frontend/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: HomePage(),
    );
  }
}