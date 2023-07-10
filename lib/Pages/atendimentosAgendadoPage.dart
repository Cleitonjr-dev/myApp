/*

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtendimentoAgendadoPage extends StatefulWidget {
  final String serviceSummary;

  const AtendimentoAgendadoPage({required this.serviceSummary});

  @override
  _AtendimentoAgendadoPageState createState() =>
      _AtendimentoAgendadoPageState();
}

class _AtendimentoAgendadoPageState extends State<AtendimentoAgendadoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serviços Agendados',
              style: GoogleFonts.ubuntu(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                // color: Colors.amber,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0.3,
                      child: ExpansionTile(
                        title: Text('Agendamento ${index + 1}'),
                        children: <Widget>[
                          ListTile(
                            title: Text('Detalhe do Item ${index + 1}'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/