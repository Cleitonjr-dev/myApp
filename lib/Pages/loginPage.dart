import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/widgetDrawer.dart';

import 'package:path_provider_android/path_provider_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? value = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    setState(() {
      _emailController.text = savedEmail ?? '';
      _passwordController.text = savedPassword ?? '';
      value = savedEmail != null && savedPassword != null;
    });
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value!) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  String? _validateEmail(value) {
    if (value.isEmpty) {
      return 'Campo obrigatório';
    } else if (!EmailValidator.validate(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validatePassword(value) {
    if (value.isEmpty) {
      return 'Campo obrigatório';
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(value)) {
      return 'A senha deve ter no mínimo 8 caracteres, uma letra maiúscula, uma letra minúscula e um número';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      saveCredentials(); // Save credentials before navigating

      final email = _emailController.text;
      final password = _passwordController.text;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenDrawer(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color.fromARGB(255, 102, 36, 245),
            Color.fromARGB(255, 170, 143, 228),
          ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.ubuntu(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Entre em um lugar bonito",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            cursorColor: Colors.deepPurpleAccent,
                            style: GoogleFonts.ubuntu(),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFE7EDEB),
                              hintText: "E-mail",
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: _validateEmail,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            cursorColor: Colors.deepPurpleAccent,
                            style: GoogleFonts.ubuntu(),
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFE7EDEB),
                              hintText: "Senha",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600],
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _togglePasswordVisibility,
                                child: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility, color: Colors.deepPurpleAccent),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                activeColor: Colors.deepPurpleAccent,
                                value: value,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    value = newValue;
                                  });
                                },
                              ),
                              Text(
                                'Lembrar-me',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Esqueceu a senha ?",
                                textAlign: TextAlign.end,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 102, 36, 245),
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Login'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 102, 36, 245),
                                textStyle: GoogleFonts.ubuntu(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              onPressed: _login,
                            ),
                          ),
                          SizedBox(
                            height: 80.0,
                          ),
                          Text(
                            "Não tem uma conta? registrar agora.",
                            style: GoogleFonts.ubuntu(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
