import 'package:billbook/Constant/app_theme.dart';
import 'package:billbook/Widgets/bottomNavBar.dart';
import 'package:billbook/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'Model/deal_model.dart';
import 'Pages/Password/PasswordPage.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DealModelAdapter());
  Hive.registerAdapter(DealItemModelAdapter());
  await Hive.openBox<DealModel>('deals');



  SystemChrome.setSystemUIOverlayStyle(

    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360.0, 690.0),
      builder: (context, wi) {
        return MaterialApp(
          title: 'Bill Book',
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          color: AppTheme.background,
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          routes: routes,
          home: PasswordPage(),
        );
      },
    );
  }
}
