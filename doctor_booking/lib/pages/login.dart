import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email, _password;
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _error = true,doc = false;
  double _opac = 0.0;
  SharedPreferences sp;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    // _checklogin();
  }

  void _checklogin() async {
    sp = await SharedPreferences.getInstance();
    if (sp.getString('username') != null)
      Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: Center(
                child: Column(children: <Widget>[
                  Text("Doctor Appointments",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontFamily: "bodoniflf")),
                  SizedBox(height: 5),
                  Text("Signin to start",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: "bodoniflf")),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 130.0, 0.0, 0.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0)),
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  doc = false;
                                });
                              },
                              child: Container(
                                height: 40.0,
                                width: 100.0,
                                decoration: new BoxDecoration(
                                  color: doc ? Theme.of(context).primaryColor
                                      : Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text('Patient',style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1,),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  doc = true;
                                });
                              },
                              child: Container(
                                height: 40.0,
                                width: 100.0,
                                decoration: new BoxDecoration(
                                  color: doc ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text('Doctor',style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Form(
                        key: _formkey,
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
                              child: TextFormField(
                                onSaved: (String value) =>
                                    setState(() => _email = value),
                                validator: (value) {
                                  if (value.isEmpty) return 'Field Required';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixText: '+254 ',
                                  prefixStyle: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Phone Number',
                                  errorText: _error ? null : "Check Phone Number",
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                              child: TextFormField(
                                onSaved: (String value) =>
                                    setState(() => _password = value),
                                validator: (value) {
                                  if (value.isEmpty) return 'Field Required';
                                  return null;
                                },
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: _toggle,
                                  ),
                                  labelText: 'Password',
                                  errorText: _error ? null : "Check Password",
                                ),
                              ),
                            ),
                            // Padding(
                            //     padding:
                            //         const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
                            //     child: InkWell(
                            //       child: Text(
                            //         'Forgot Password?',
                            //         textAlign: TextAlign.end,
                            //       ),
                            //       onTap: () {},
                            //     )),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                                child: Builder(
                                    builder: (context) => (RaisedButton(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          onPressed: () {
                                            _formkey.currentState.save();
                                            if (_formkey.currentState.validate()){
                                              signIn(context, _email, _password);}
                                          },
                                          color: Theme.of(context).accentColor,
                                        )))),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(70.0, 15.0, 70.0, 0.0),
                              child: doc ? Center() : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Dont Have an Account? '),
                                  InkWell(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushNamed('register');
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Opacity(
                opacity: _opac,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SpinKitCircle(
                    color: Theme.of(context).accentColor,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void signIn(BuildContext ctx, String email, String password) async {
    try {
      setState(() {
        _opac = 1.0;
      });
      Map data = {'phone': email, 'password': password,'doc' : doc.toString()};
      var jsonData;
      sp = await SharedPreferences.getInstance();
      var response = await http.post('https://docbooking254.000webhostapp.com/login.php',
          body: data);
      print(response.body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData['status'] == '200') {
          setState(() {
            _opac = 0.0;
          });
          sp.setString('username', jsonData['username']);
          sp.setString('userid', jsonData['id']);
          sp.setString('doc', jsonData['doc']);
          Navigator.of(context).pushNamed('home');
        } else {
          final snackBar = SnackBar(
              content: Text(
            jsonData['message'],
            textAlign: TextAlign.center,
          ));
          Scaffold.of(ctx).showSnackBar(snackBar);
          setState(() {
            _opac = 0.0;
            _error = false;
          });
        }
      } else {
        final snackBar = SnackBar(
            content: Text(
          'Error fetching data!',
          textAlign: TextAlign.center,
        ));
        Scaffold.of(ctx).showSnackBar(snackBar);
        setState(() {
          _opac = 0.0;
          _error = false;
        });
      }
    } catch (_) {
      final snackBar = SnackBar(
          content: Text(
        'Network Error',
        textAlign: TextAlign.center,
      ));
      Scaffold.of(ctx).showSnackBar(snackBar);
      setState(() {
        _opac = 0.0;
      });
    }
  }
}
