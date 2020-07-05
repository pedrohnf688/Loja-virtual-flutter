import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Criar Conta"), centerTitle: true),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if(model.isLoading){
          return Center(child: CircularProgressIndicator());
        }
        return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: "Nome Completo"),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Nome inválido!";
                    }
                    return null;
                  },
                  controller: _nomeController,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                    decoration: InputDecoration(hintText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@")) {
                        return "Email inválido!";
                      }
                      return null;
                    },
                    controller: _emailController),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: "Senha"),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6) {
                      return "Senha inválida!";
                    }
                    return null;
                  },
                  controller: _senhaController,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(hintText: "Endereço"),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Endereço inválido!";
                    }
                    return null;
                  },
                  controller: _enderecoController,
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "nome" : _nomeController.text,
                            "email" : _emailController.text,
                            "endereco" : _enderecoController.text
                          };
                          model.signUp(
                              userData: userData,
                              pass: _senhaController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        }
                      },
                      child:
                      Text("Criar Conta", style: TextStyle(fontSize: 18)),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor),
                )
              ],
            ));
      }),
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text("Usuário Cadastrado com Sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2)
      )
    );

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text("Falha ao Criar Usuário!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2)
        )
    );

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });

  }

}