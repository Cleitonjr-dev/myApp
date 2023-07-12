import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Pages/calendarioPage.dart';
import 'package:myapp/Pages/configuracaoPage.dart';
import 'package:myapp/Pages/homePage.dart';
import 'package:myapp/Pages/loginPage.dart';
import 'package:myapp/Pages/pagamentosPage.dart';
import 'package:myapp/Pages/servicosPage.dart';


class ScreenDrawer extends StatefulWidget {
  ScreenDrawer({required this.email});

  final String email;

  @override
  State<ScreenDrawer> createState() => _ScreenDrawerState();
}

class _ScreenDrawerState extends State<ScreenDrawer> {
  final zoomDrawerController = ZoomDrawerController();

  // Menu Drawer lateral
  List<String> menuItens = [
    "Home",
    "Serviços",
    //"Calendário",
    //"Agendamentos",
    "Pagamentos",
    "Configurações",
  ];
  List<IconData> menuIcon = [
    Icons.apps,
    Icons.design_services,
    //Icons.date_range_outlined,
    //Icons.person_search_outlined,
    Icons.wallet_outlined,
    Icons.settings,
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuBackgroundColor: Colors.white,
      shadowLayer1Color: const Color.fromARGB(255, 245, 245, 245),
      shadowLayer2Color:
          const Color.fromARGB(255, 230, 230, 230).withOpacity(0.3),
      menuScreen: _menuScreen(context),
      borderRadius: 50.0,
      showShadow: true,
      angle: -16.0,
      drawerShadowsBackgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      mainScreen: _mainScreen(context),
    );
  }

  Container _menuScreen(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                zoomDrawerController.toggle?.call();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "User Name",
                        style: GoogleFonts.ubuntu(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("${menuItens[index]} Tapped");
                          _navigateToScreen(context, index);
                        },
                        splashColor: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          leading: Icon(
                            menuIcon[index],
                            color: Theme.of(context).primaryColor,
                            size: 27,
                          ),
                          title: Text(
                            menuItens[index],
                            style: GoogleFonts.ubuntu(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 70),
                  child: TextButton.icon(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor.withOpacity(0.5)),
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _logout(context);
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.ubuntu(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Scaffold _mainScreen(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "My App",
          style: GoogleFonts.ubuntu(),
        ),
        leading: IconButton(
          onPressed: () => zoomDrawerController.toggle?.call(),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: homePage(),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        zoomDrawerController.toggle?.call(); // Close the drawer
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServicosPage()),
        );
        break;
      /*case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => calendarioPage()),
        );
        break;*/
      /*case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => atendimentoPage()),
        );
        break;*/
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pagamentosPage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => configuracaoPage()),
        );
        break;
    }
  }
}
