import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:google_fonts/google_fonts.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
   final zoomDrawerController = ZoomDrawerController();
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      body: Container(
        child: Center(
          child: Text(
            'EM DESENVOLVIMENTO...',
            style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
