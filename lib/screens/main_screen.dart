import 'package:flutter/material.dart';
import 'package:shopify_admin/utils/constant.dart';
import 'package:shopify_admin/widgets/custom_drawer_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,

        title: Text("Admin Panel",style: TextStyle(color: AppConstant.appTextColor,fontWeight: FontWeight.bold),),
        centerTitle: true,
      iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      drawer: CustomDrawerWidget(),
      body: Container(

      ),
    );
  }
}