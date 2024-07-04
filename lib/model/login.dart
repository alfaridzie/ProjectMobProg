import 'package:flutter/material.dart';
import 'package:semester4_tugas_akhir_crud/model/list_contact_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _pin = TextEditingController();

  bool checkValid = true;
  bool userName = false;
  bool passwordHidden = true;

  void _login() {
    if (_user.text.isNotEmpty) {
      setState(() {
        if (_user.text == "kelompok6") {
          checkValid = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ListContactPage();
              },
            ),
          );
          const snackBar = SnackBar(
            content: Text('Log In Succesfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          checkValid = false;
          const snackBar = SnackBar(
            content: Text('Something wrong, check your username again'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Oops, something went wrong!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (_pin.text.isNotEmpty) {
      setState(() {
        if (_pin.text == "123456") {
          checkValid = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ListContactPage();
              },
            ),
          );
          const snackBar = SnackBar(
            content: Text('Log In Succesfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          checkValid = false;
          const snackBar = SnackBar(
            content: Text('Something wrong, check your PIN again'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Oops, something went wrong!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _showUsername() {
    setState(() {
      userName = !userName;
    });
  }

  void _showPassword() {
    setState(() {
      passwordHidden = !passwordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: ListView(
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: const Image(image: AssetImage('images/logo.png')),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 236, 178, 1.0),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _user,
                        obscureText: userName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Masukkan Username Anda"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _pin,
                        obscureText: passwordHidden,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Masukkan PIN Anda",
                          suffixIcon: IconButton(
                            onPressed: () {
                              _showPassword();
                            },
                            icon: (passwordHidden)
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () => _login(),
                        child: const Text("Login",style: TextStyle(color: Colors.white), ), 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(243, 144, 74, 1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
