import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instergram_flutter/provider/user_provider.dart';
import 'package:instergram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instergram_flutter/responsive/web_screen_layout.dart';
import 'package:instergram_flutter/utilities/global_ver.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {Key? key,
      required this.mobileScreenLayout,
      required this.webScreenLayout})
      : super(key: key);
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    if (kDebugMode) {
      print("This is getting Called");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return const WebScreenLayout();
        }
        return const MobileScreenLayout();
      },
    );
  }
}
