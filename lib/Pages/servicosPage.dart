import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:myapp/Pages/atendimentosAgendadoPage.dart';


class ServicosPage extends StatefulWidget {
  const ServicosPage({Key? key}) : super(key: key);

  @override
  _ServicosPageState createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    // Exibe o aviso de confirmação de agendamento
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

    // Limpa os serviços selecionados após um atraso de 1 segundo
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        selectedServices.clear();
        isPurchaseFinished = true;
      });
    }).then((_) {
      setState(() {
        isPurchaseFinished = false;
      });
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
          AtendimentoAgendadoPage(serviceSummary: '',),
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
                      subtitle: Text(
                          'Valor: R\$${service.value.toStringAsFixed(2)}'),
                      trailing: Checkbox(
                        value: selectedServices.contains(service),
                        onChanged: (value) =>
                            toggleServiceSelection(service),
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
                            Center(
                              child: TextButton(
                                onPressed: finishPurchase,
                                child: const Text(
                                  'Confirmar Agendamento',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                              ),
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



class Service {
  final String name;
  final double value;

  Service({required this.name, required this.value});
}