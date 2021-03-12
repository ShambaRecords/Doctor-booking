import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sp;
  DateTime _sDate = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _details = new TextEditingController(),_diagnosis = new TextEditingController();
  Rect rect;
  int _wordcount = 0;
  String dropdownValue = 'Select',_time = TimeOfDay(hour: 00, minute: 00).toString();
  List<Map<String,String>> docs = new List();
  List <String> spinnerItems = ['Select'];
  double _opac = 0.0;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  bool doc = false;
  List<Map<String,String>> appointmentsList = new List();
  List<Map<String,String>> allList = new List();
  bool history = false;

   @override
   void initState() {
     super.initState();
     _checklogin();
   }

   void _checklogin() async{
     sp = await SharedPreferences.getInstance();
     if (sp.getString('username') == null)
       Navigator.pushReplacementNamed(context, 'login');
     else {
       doc = sp.getString("doc") == 'true';
       doc ? getAppointments() : getDocs();
     }
   }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(doc ? 'Doctor' : 'Patient'),
        ),
        body: Stack(
          children: [
            doc ?
            Column(
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
                  child: appointmentsList.length > 0 ? ListView.builder(
                    itemCount: appointmentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
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
                                                doc ? 'Patient: ': 'Doctor: ',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                doc ? appointmentsList[index]['pname'] : appointmentsList[index]['docname'],
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
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * .8,
                                                  child: TextField(
                                                    style: TextStyle(color: Colors.black87),
                                                    controller: _diagnosis,
                                                    maxLines: 3,
                                                    cursorColor: Theme.of(context).primaryColor,
                                                    decoration: InputDecoration(
                                                      hintText: 'Describe Patient diagnosis ...',
                                                      labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                                      focusedBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                                      enabledBorder: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                                                  child: Builder(
                                                      builder: (btn) => (
                                                          RaisedButton(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child: Text(
                                                                'Update',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0)),
                                                            onPressed: () {
                                                              if( _diagnosis.text == ''){
                                                                final snackBar = SnackBar(
                                                                    content: Text(
                                                                      'fill in diagnosis',
                                                                      textAlign: TextAlign.center,
                                                                    ));
                                                                _scaffoldKey.currentState.showSnackBar(snackBar);
                                                              }else
                                                                updateDiagnosis(appointmentsList[index]['id']);

                                                              Navigator.pop(bc);
                                                            },
                                                            color: Theme.of(context).accentColor,
                                                          )
                                                      )
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
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
                                                doc ? appointmentsList[index]['pname'] : appointmentsList[index]['docname'],
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
                ),
              ],
            )
                :
            Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Book Appointment',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Column(
                            children: [
                              DropdownButton<String>(
                                isExpanded: true,
                                value: dropdownValue,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 8,
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
                                underline: Container(
                                  height: 2,
                                  color: Theme.of(context).accentColor,
                                ),
                                onChanged: (String data) {
                                  setState(() {
                                    dropdownValue = data;
                                  });
                                },
                                items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text( 'Date',
                                            style: TextStyle(color: Colors.black,fontSize: 11)),
                                        InkWell(
                                          onTap: () async {
                                            final DateTime picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(), // Refer step 1
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2025),
                                            );
                                            if (picked != null )
                                              setState(() {
                                                _sDate = picked;
                                                print(_sDate);
                                              });
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text( "${_sDate.toLocal()}".split(' ')[0]
                                                  ,style: TextStyle(color: Colors.black54)),
                                              Spacer(),
                                              Icon(Icons.arrow_drop_down),
                                            ],
                                          ),
                                        ),
                                        Divider(color:  Theme.of(context).accentColor,)
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text( 'Time',
                                            style: TextStyle(color: Colors.black,fontSize: 11)),
                                        InkWell(
                                          onTap: () async {
                                            final TimeOfDay picked = await showTimePicker(
                                              context: context,
                                              initialTime: selectedTime,
                                            );
                                            if (picked != null)
                                              setState(() {
                                                selectedTime = picked;
                                                _time = selectedTime.hour.toString() + ' : ' + selectedTime.minute.toString();
                                              });
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text( checktime(selectedTime.hour.toString()) + ' : '
                                                  + checktime(selectedTime.minute.toString()),
                                                  style: TextStyle(color: Colors.black54,letterSpacing: -1)),
                                              Spacer(),
                                              Icon(Icons.arrow_drop_down),
                                            ],
                                          ),
                                        ),
                                        Divider(color:  Theme.of(context).accentColor,)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '$_wordcount/100',
                                  style: TextStyle(fontSize: 11,
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              TextField(
                                style: TextStyle(color: Colors.black87),
                                controller: _details,
                                maxLines: 3,
                                cursorColor: Theme.of(context).primaryColor,
                                onChanged: (v) {
                                  setState(() {
                                    _wordcount = v.split(" ").length;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Describe your appointment ...',
                                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).accentColor)),
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                          child: Builder(
                              builder: (context) => (
                                  RaisedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)),
                                    onPressed: () {
                                        if(dropdownValue == 'select' || _sDate == new DateTime.now()
                                        ||  _time == TimeOfDay(hour: 00, minute: 00).toString() || _details.text == ''){
                                          final snackBar = SnackBar(
                                              content: Text(
                                                'invalid details',
                                                textAlign: TextAlign.center,
                                              ));
                                        Scaffold.of(context).showSnackBar(snackBar);
                                        }else
                                          Book(context);
                                      },
                                    color: Theme.of(context).accentColor,
                                  )
                              )
                          )
                      ),
                    ],
                  ),
                ]),
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
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/icon.png')),
              ),
              ListTile(
                leading: Icon(Icons.home,color: Theme.of(context).primaryColor),
                title: Text('Home',
                  style: TextStyle(color: Theme.of(context).primaryColor,),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              doc ?
              Container()
                  :
              ListTile(
                leading: Icon(Icons.calendar_today,color: Theme.of(context).primaryColor,),
                title: Text('Appointments',
                  style: TextStyle(color: Theme.of(context).primaryColor,),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'appointments');
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: Theme.of(context).primaryColor),
                title: Text('Logout',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  sp.clear();
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  checktime(String t){
     var char = t.split('');
     if(char.length == 1){
       char.insert(0, '0');
     }
     return char.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', '');
  }

  Book(BuildContext ctx) async {
    try {
      setState(() {
        _opac = 1.0;
      });
      String docid;
      docs.forEach((v) {
        v.forEach((k,v){
          if(v == dropdownValue)
            docid = k;
        });
      });
      Map data = {
        'userid' : sp.getString('userid'),
        'docid': docid,
        'details': _details.text,
        'time': _sDate.toString() + ' ' + _time,
      };
      var jsonData;
      var response = await http.post(
          'https://docbooking254.000webhostapp.com/appointment.php',
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
          setState(() {
            selectedTime = TimeOfDay(hour: 00, minute: 00);
            _sDate = DateTime.now();
            _time = TimeOfDay(hour: 00, minute: 00).toString();
            _details.text = "";
            _wordcount = 0;
            dropdownValue = 'Select';
          });
          Navigator.pushNamed(context, 'appointments');
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
      print('Network Error' + _);
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

  getDocs() async {
    try {
      setState(() {
        _opac = 1.0;
      });
      var jsonData;
      var response = await http.post(
          'https://docbooking254.000webhostapp.com/getdocs.php');
      print(response.body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData['status'] == "200") {
          jsonData['data'].forEach((v) {
            spinnerItems.add(v['doc_name']);
            docs.add({ v['doc_id'] : v['doc_name']});
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
      print('Network Error' + _);
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

  getAppointments() async {
    try {
      setState(() {
        _opac = 1.0;
      });
      Map data = {
        'userid' : sp.getString('userid'),
        'user' : 'doctor',
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
              'id' : v['id'],
              'details' : v['details'],
              'docnotes' : v['docnotes'],
              'time' : v['time'],
              'status' : v['status'],
              'pname' : v['pname'],
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

  updateDiagnosis(String id) async {
    try {
      setState(() {
        _opac = 1.0;
      });
      Map data = {
        'userid' : sp.getString('userid'),
        'user' : 'doctor',
        'id' : id,
        'notes' : _diagnosis.text,
      };
      var jsonData;
      var response = await http.post(
          'https://docbooking254.000webhostapp.com/updatediagnosis.php',
          body: data);
      print(response.body);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData['status'] == "200") {
          List<Map<String,String>> tempList = new List();

          jsonData['data'].forEach((v) {
            Map<String,String> temp = {
              'id' : v['id'],
              'details' : v['details'],
              'docnotes' : v['docnotes'],
              'time' : v['time'],
              'status' : v['status'],
              'pname' : v['pname'],
              'docname' : v['docname'],
              'docphone' : v['docphone'],
            };
            tempList.add(temp);
          });
          setState(() {
            allList.clear();
            appointmentsList.clear();
            allList.addAll(tempList);
            allList.forEach((v) {
              if(v['status'] == (history ? '1' : '0'))
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
