import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class calendarioPage extends StatefulWidget {
  @override
  _calendarioPageState createState() => _calendarioPageState();
}

class _calendarioPageState extends State<calendarioPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: Text(
          "Agendamento",
          style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                child: TableCalendar(
                  locale: 'pt, BR',
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2023, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: {
                    CalendarFormat.month: 'Month',
                    //CalendarFormat.week: 'Week',
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    return _events[day] ?? [];
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.pink.shade200,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(
                    'Eventos:',
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  backgroundColor: Colors.deepPurpleAccent,
                  onPressed: () {
                    _showAddDialog();
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _events[_selectedDay]?.length ?? 0,
                separatorBuilder: (context, index) => SizedBox(height: 0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: ListTile(
                        title: Text(
                          _events[_selectedDay]![index],
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newEventText = '';

        return AlertDialog(
          title: Text(
            'Novo Agendamento:',
            style: GoogleFonts.ubuntu(),
          ),
          content: TextField(
            cursorColor: Colors.deepPurpleAccent,
            onChanged: (value) {
              newEventText = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.ubuntu(color: Colors.deepPurpleAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (newEventText.isNotEmpty) {
                  setState(() {
                    if (_events[_selectedDay] != null) {
                      _events[_selectedDay]!.add(newEventText);
                    } else {
                      _events[_selectedDay] = [newEventText];
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Salvar',
                style: GoogleFonts.ubuntu(),
              ),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Colors.deepPurpleAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
