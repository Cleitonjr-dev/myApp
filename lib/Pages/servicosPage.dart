import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:myapp/Pages/calendarioPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ServicosPage extends StatefulWidget {
  const ServicosPage({Key? key}) : super(key: key);

  @override
  _ServicosPageState createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Appointment> appointments = [];
  List<Service> services = [
    Service(name: 'Pé', value: 25.0),
    Service(name: 'Mão', value: 30.0),
    Service(name: 'Pé e Mão', value: 50.0),
    Service(name: 'Aplicação', value: 30.0),
    Service(name: 'Manutenção', value: 80.0),
    Service(name: 'Pintura em Gel', value: 45.0),
    Service(name: 'Pintura Normal', value: 30.0),
    Service(name: 'Unha', value: 120.0),
    Service(name: 'Lixamento', value: 20.0),
    Service(name: 'Banho de Lua', value: 95.0),
    Service(name: 'Spa dos Pés', value: 75.0),
    Service(name: 'Cabelo', value: 110.0),
    Service(name: 'Outros', value: 10.0),
  ];
  List<Service> selectedServices = [];
  bool isPurchaseFinished = false;
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    _preferences = await SharedPreferences.getInstance();
    final appointmentsJson = _preferences.getString('appointments');
    if (appointmentsJson != null) {
      final List<dynamic> appointmentsData = jsonDecode(appointmentsJson);
      final List<Appointment> loadedAppointments =
          appointmentsData.map((data) => Appointment.fromJson(data)).toList();
      setState(() {
        appointments = loadedAppointments;
      });
    }
  }

  Future<void> _saveAppointments() async {
    final appointmentsJson = jsonEncode(
        appointments.map((appointment) => appointment.toJson()).toList());
    await _preferences.setString('appointments', appointmentsJson);
  }

  double getTotalValue() {
    double total = 0.0;
    for (var service in selectedServices) {
      total += service.value;
    }
    return total;
  }

  void toggleServiceSelection(Service service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  void finishPurchase() {
    Navigator.of(context).pop();
    appointments.add(Appointment(selectedServices.toList()));

    showToast(
      'Agendamento Realizado com sucesso!',
      context: context,
      backgroundColor: Colors.grey[700],
      textStyle: TextStyle(color: Colors.white),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      duration: Duration(seconds: 3),
      animDuration: Duration(milliseconds: 200),
    );

    setState(() {
      selectedServices.clear();
      isPurchaseFinished = false;
      _saveAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: Text(
          "Escolha seu serviço",
          style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white54,
          indicatorWeight: 3,
          controller: _tabController,
          tabs: [
            Tab(text: 'Serviços'),
            Tab(text: 'Agendamentos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ServicosPageContent(
            services: services,
            selectedServices: selectedServices,
            isPurchaseFinished: isPurchaseFinished,
            toggleServiceSelection: toggleServiceSelection,
            getTotalValue: getTotalValue,
            finishPurchase: finishPurchase,
          ),
          AtendimentoAgendadoPage(appointments: appointments),
        ],
      ),
    );
  }
}

class ServicosPageContent extends StatelessWidget {
  final List<Service> services;
  final List<Service> selectedServices;
  final bool isPurchaseFinished;
  final Function(Service) toggleServiceSelection;
  final double Function() getTotalValue;
  final VoidCallback finishPurchase;

  const ServicosPageContent({
    required this.services,
    required this.selectedServices,
    required this.isPurchaseFinished,
    required this.toggleServiceSelection,
    required this.getTotalValue,
    required this.finishPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Container(
                  height: 100,
                  width: 100,
                  child: Card(
                    child: ListTile(
                      title: Text(service.name),
                      subtitle:
                          Text('Valor: R\$${service.value.toStringAsFixed(2)}'),
                      trailing: Checkbox(
                        value: selectedServices.contains(service),
                        onChanged: (value) => toggleServiceSelection(service),
                        activeColor: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedServices.isNotEmpty && !isPurchaseFinished
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Resumo do Serviço:'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Itens Selecionados:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              for (var service in selectedServices)
                                Text(service.name),
                              const SizedBox(height: 10),
                              Text(
                                  'Valor Total: R\$${getTotalValue().toStringAsFixed(2)}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // navegação para tela de calendário.
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              calendarioPage()),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      Text(
                                        'Calendário',
                                        style: TextStyle(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: finishPurchase,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Color.fromARGB(255, 97, 170, 13),
                                      ),
                                      Text(
                                        'Confirmar',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 97, 170, 13),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
            ),
            child: const Text('Criar Agendamento'),
          ),
        ],
      ),
    );
  }
}

class AtendimentoAgendadoPage extends StatelessWidget {
  final List<Appointment> appointments;

  const AtendimentoAgendadoPage({required this.appointments});

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
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (BuildContext context, int index) {
                  final appointment = appointments[index];
                  return Card(
                    elevation: 0.3,
                    child: ExpansionTile(
                      title: Text('Agendamento ${index + 1}'),
                      children: <Widget>[
                        for (var service in appointment.services)
                          ListTile(
                            title: Text(service.name),
                            subtitle: Text(
                              'Valor: R\$${service.value.toStringAsFixed(2)}',
                            ),
                          ),
                      ],
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
}

class Service {
  final String name;
  final double value;

  Service({required this.name, required this.value});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      value: json['value'],
    );
  }
}

class Appointment {
  final List<Service> services;

  Appointment(this.services);

  Map<String, dynamic> toJson() {
    return {
      'services': services.map((service) => service.toJson()).toList(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final List<dynamic> servicesData = json['services'];
    final List<Service> loadedServices =
        servicesData.map((data) => Service.fromJson(data)).toList();

    return Appointment(loadedServices);
  }
}
