import 'dart:io';

import 'package:desafio1/pages/login.page.dart';
import 'package:flutter/material.dart';

import 'package:desafio1/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _verSenha = true;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _senhaController = TextEditingController();

  File? _image;
  
  Future<void> _pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await prefs.setString('user_image', pickedFile.path);
    } else {
      await prefs.setString('user_image', " ");
    }
  }

  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_nomeController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&        
        _senhaController.text.isNotEmpty != Null) {
      await prefs.setString(Tema().nome, _nomeController.text);
      await prefs.setString(Tema().email, _emailController.text);          
      await prefs.setString(Tema().senha, _senhaController.text);          
      await prefs.setString(Tema().image, _image!.path);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro completado com sucesso!'),));

      String? email = prefs.getString('email');
      String? senha = prefs.getString('senha');

      bool emailCorreto = _emailController.text == email;
      bool senhaCorreta = _senhaController.text == senha;

      if (emailCorreto && senhaCorreta) {
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email ou senha incorretos!')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Por favor, preencha todos os campos!')));
    }
  }

  @override
  void initState() {
    super.initState();
    _verSenha = false;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 181, 204),
        title: const Text("Criar sua Conta",
            style: TextStyle(
                color: Color.fromARGB(255, 37, 37, 37),
                fontFamily: 'OpenSans',
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 153, 181, 204),
              Color.fromARGB(255, 203, 223, 253)
            ], // Ajuste as cores conforme desejado
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(0, 0, 0, 0), width: 3),
                        borderRadius: BorderRadius.circular(50.5),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!), fit: BoxFit.cover)
                            : null,
                        color: Colors.grey[200],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.camera_enhance,
                            color: Colors.green, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    width: 315.0,
                    child: TextField(
                      controller: _nomeController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 40.0),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 2.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 2.5)),
                        prefixIcon: const Icon(
                          Icons.person_search_outlined,
                          color: Colors.purple,
                        ),
                        label: const Text("Nome Completo"),
                        hintText: "Digite seu nome",
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(137, 255, 255, 255),
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    width: 315.0,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 40.0),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 2.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 2.5)),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.purple,
                        ),
                        label: const Text("E-mail"),
                        hintText: "Digite seu e-mail",
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(137, 255, 255, 255),
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 315.0,
                    child: TextField(
                      controller: _senhaController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_verSenha,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 40.0),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 2.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.purple, width: 2.5)),
                        prefixIcon: const Icon(
                          Icons.password_rounded,
                          color: Colors.purple,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_verSenha
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _verSenha = !_verSenha;
                            });
                          },
                        ),
                        label: const Text("Password"),
                        hintText: "Digite sua senha",
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: (registerUser),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(width - 100, 60),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF002266)),
                  ),
                  child: const Text(
                    "Fazer Cadastro",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 17),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
