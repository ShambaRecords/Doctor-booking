import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _fname, _lname, _email, _password, _phone;
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  double _opac = 0.0;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 30.0, 0.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.subdirectory_arrow_left,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("SignUp",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontFamily: "bodoniflf")),
                  ]),
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
                child: Form(
                  key: _formkey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
                        child: TextFormField(
                          onSaved: (String value) =>
                              setState(() => _fname = value),
                          validator: (value) {
                            if (value.isEmpty) return 'Field Required';
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).accentColor,
                            ),
                            filled: true,
                            labelText: 'Full Name',
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding:
                      //       const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                      //   child: TextFormField(
                      //     onSaved: (String value) =>
                      //         setState(() => _email = value),
                      //     validator: (value) {
                      //       if (value.isEmpty) return 'Field Required';
                      //       return null;
                      //     },
                      //     keyboardType: TextInputType.number,
                      //     decoration: InputDecoration(
                      //       prefixIcon: Icon(
                      //         Icons.credit_card,
                      //         color: Theme.of(context).accentColor,
                      //       ),
                      //       filled: true,
                      //       labelText: 'Email',
                      //     ),
                      //     inputFormatters: <TextInputFormatter>[
                      //       WhitelistingTextInputFormatter.digitsOnly
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                        child: TextFormField(
                          onSaved: (String value) =>
                              setState(() => _phone = value),
                          validator: (value) {
                            if (value.isEmpty) return 'Field Required';
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).accentColor,
                            ),
                            prefixText: '+254 ',
                            prefixStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                            filled: true,
                            labelText: 'Phone Number',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                       child: TextFormField(
                         onSaved: (String value) => setState(() => _email = value),
                         validator: (value) {
                           if (value.isEmpty) return 'Field Required';
                           // if (!RegExp(
                           //         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}"
                           //         r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                           //     .hasMatch(_email)) return 'Invalid Email';
                           return null;
                         },
                         decoration: InputDecoration(
                           prefixIcon: Icon(
                             Icons.email,
                             color: Theme.of(context).accentColor,
                           ),
                           filled: true,
                           labelText: 'Email',
                         ),
                       ),
                     ),
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                        child: TextFormField(
                          onSaved: (String value) =>
                              setState(() => _lname = value),
                          validator: (value) {
                            if (value.isEmpty) return 'Field Required';
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.pin_drop,
                              color: Theme.of(context).accentColor,
                            ),
                            filled: true,
                            labelText: 'Address',
                          ),
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
                            if (value.length < 8)
                              return 'Password Should be greater than 8 letters';
                            return null;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                            filled: true,
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: _toggle,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 50.0),
                          child: Builder(
                              builder: (context) => RaisedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        'Register',
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
                                      if (_formkey.currentState.validate())
                                        signUp(context, _fname, _lname, _email,
                                            _phone, _password);
                                    },
                                    color: Theme.of(context).accentColor,
                                  )))
                    ],
                  ),
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

  signUp(BuildContext ctx, String name, String address, String email,
      String phone, String password) async {
    try {
      setState(() {
        _opac = 1.0;
      });
      Map data = {
        'name': name,
        'address': address,
        'email': email,
        'phone': phone,
        'password': password,
      };
      var jsonData;
      var response = await http.post(
          'https://docbooking254.000webhostapp.com/register.php',
          body: data);
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _opac = 0.0;
        });
        jsonData = json.decode(response.body);
        if (jsonData['status'] == "200") {
          final snackBar = SnackBar(
              content: Text(
                jsonData['message'],
                textAlign: TextAlign.center,
              ));
          Scaffold.of(ctx).showSnackBar(snackBar);
          Navigator.of(context).pushReplacementNamed('login');
        } else {
          final snackBar = SnackBar(
              content: Text(
            jsonData['message'],
            textAlign: TextAlign.center,
          ));
          Scaffold.of(ctx).showSnackBar(snackBar);
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
