import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class pagamentosPage extends StatefulWidget {
  const pagamentosPage({super.key});

  @override
  State<pagamentosPage> createState() => _pagamentosPageState();
}

class _pagamentosPageState extends State<pagamentosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.deepPurpleAccent,
         elevation: 0,
        title: Text(
          "Pagamento",
          style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        /*actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(CupertinoIcons.search),
          ),
        ],*/
      ),
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