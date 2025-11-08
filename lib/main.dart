import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/data/user_provider.dart';
import 'package:puzzlers/router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Puzzlers',
      routerConfig: router,
    );
  }
}
