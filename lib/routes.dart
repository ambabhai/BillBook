
import 'package:billbook/Pages/Deals/CreateDealPage.dart';
import 'package:billbook/Pages/Deals/DealsPage.dart';
import 'package:billbook/Pages/Home/HomePage.dart';
import 'package:billbook/Widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

import 'Pages/Deals/EditDealPage.dart';

Map<String, WidgetBuilder> routes = {
  // BottomNavBar.routeName: (context) => const BottomNavBar(),
  HomePage.routeName: (context) => const HomePage(),
  CreateDealPage.routeName: (context) => const CreateDealPage(),
  DealsPage.routeName: (context) => const DealsPage(),
  };
