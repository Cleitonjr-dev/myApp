import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class configuracaoPage extends StatefulWidget {
  const configuracaoPage({super.key});

  @override
  State<configuracaoPage> createState() => _configuracaoPageState();
}

class _configuracaoPageState extends State<configuracaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.deepPurpleAccent,
         elevation: 0,
        title: Text(
          "Configuração",
          style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.w500),
        ),
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