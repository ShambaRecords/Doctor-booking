import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  SharedPreferences sp;
  DateTime _sDate = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map<String,String>> appointmentsList = new List();
  List<Map<String,String>> allList = new List();
  double _opac = 0.0;
  bool history = false;

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text('Appointments'),
          leading: InkWell(child: Icon(Icons.arrow_back),
            onTap: () => Navigator.pop(context),),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          history = false;
                          appointmentsList.clear();
                          allList.forEach((v) {
                            if(v['status'] == '0')
                              appointmentsList.add(v);
                          });
                        });
                      },
                      child: Container(
                        height: 40.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                          color: history ? Theme.of(context).primaryColor
                              : Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text('Upcoming',style: TextStyle(
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
                            history = true;
                            appointmentsList.clear();
                            allList.forEach((v) {
                              if(v['status'] == '1')
                                appointmentsList.add(v);
                            });
                          });
                        },
                      child: Container(
                        height: 40.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                          color: history ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text('History',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: Stack(
                children: [
                  appointmentsList.length > 0 ? ListView.builder(
                    itemCount: appointmentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if( appointmentsList[index]['status'] == '1'){
                            showModalBottomSheet(
                              backgroundColor: Color(0xFF0000ffff),
                                context: context,
                                builder: (BuildContext bc){
                                  return Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: new Wrap(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Doctor: ',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                appointmentsList[index]['docname'],
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Diagnosis ",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                appointmentsList[index]['docnotes'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Date: ',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                appointmentsList[index]['time'].substring(0,10),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          }
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 50.0,
                                    width: 50.0,
                                      decoration: new BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(appointmentsList[index]['time'].substring(
                                            appointmentsList[index]['time'].length-7,appointmentsList[index]['time'].length).trim(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -1),
                                        ),
                                      ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  appointmentsList[index]['docname'],
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              appointmentsList[index]['status'] == '1' ?
                                              Text('done',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ) :
                                              Text('upcoming' ,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.yellow[800],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${appointmentsList[index]['details']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                    },
                  ) : Center(child: Text('No appointments yet')),
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
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  getAppointments() async {
    try {
      setState(() {
        _opac = 1.0;
      });
      sp = await SharedPreferences.getInstance();
      Map data = {
        'userid' : sp.getString('userid'),
        'user' : 'patient',
      };
      var jsonData;
      var response = await http.post(
          'https://docbooking254.000webhostapp.com/getappointments.php',
          body: data);
      print(response.body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData['status'] == "200") {
          List<Map<String,String>> tempList = new List();

          jsonData['data'].forEach((v) {
            Map<String,String> temp = {
              'details' : v['details'],
              'docnotes' : v['docnotes'],
              'time' : v['time'],
              'status' : v['status'],
              'docname' : v['docname'],
              'docphone' : v['docphone'],
            };
            tempList.add(temp);
          });
          setState(() {
            allList.addAll(tempList);
            allList.forEach((v) {
              if(v['status'] == '0')
                appointmentsList.add(v);
            });
          });
        } else {
          final snackBar = SnackBar(
              content: Text(
                jsonData['message'],
                textAlign: TextAlign.center,
              ));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
        setState(() {
          _opac = 0.0;
        });
      } else {
        final snackBar = SnackBar(
            content: Text(
              'Error fetching data!',
              textAlign: TextAlign.center,
            ));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        setState(() {
          _opac = 0.0;
        });
      }
    } catch (_) {
      print('Network Error' + _.toString());
      final snackBar = SnackBar(
          content: Text(
            'Network Error' ,
            textAlign: TextAlign.center,
          ));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        _opac = 0.0;
      });
    }
  }
}
