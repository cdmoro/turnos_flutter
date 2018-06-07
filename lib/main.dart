import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import './DrawerApp.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Turnos',
      theme: new ThemeData(primarySwatch: Colors.teal),
      home: new MyHomePage(title: 'Mis turnos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = "";
  List<String> turnos = new List();

  @override
  initState() {
    super.initState();
    this.turnos.add("Institución");
    this.turnos.add("Negocio");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mis turnos ${turnos.length == 0 ? '' : '(' + turnos.length.toString() + ')'}"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.done_all),
            onPressed:
              this.turnos.length == 0 ? 
                null :
                () {
                  setState(() => this.turnos.clear());
                },
          ),
          new IconButton(

            icon: new Icon(Icons.search),
            onPressed: () {
            },
          )
        ],
      ),
      drawer: new DrawerApp("/"),
      body: 
        turnos.length == 0 ?
        new Center(child: new Text("No hay turnos todavía"),) :
        new ListView.builder(
          itemCount: turnos.length,
          itemBuilder: (context, i) => new Dismissible(
            key: new Key(turnos[i]),
            background: new Container(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.done, color: Colors.white,),
                ],
              ),
              color: Colors.green
            ),
            onDismissed: (direction) {
              setState(() {
                turnos.removeAt(i);
              });

              Scaffold.of(context).showSnackBar(
                  new SnackBar(content: new Text("Turno completado")));
            },
            child: new Column(
              children: <Widget>[
                new ListTile(
                  leading: new CircleAvatar(
                    child: new Text((i+1).toString()),
                  ),
                  title: new Text(turnos[i]),
                  subtitle: new Text("${((i+1)*3).toString()} personas adelante"),
                  trailing: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("07/06/2018", style: new TextStyle(fontSize: 12.0)),
                      new Text("45 min."),
                    ]
                  )
                ),
                new Divider(height: 10.0,)
              ]
            )
          )
        ),
      floatingActionButton: new FloatingActionButton(
        onPressed: scan,
        tooltip: "Nuevo turno",
        child: new Icon(Icons.photo_camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.turnos.add(barcode));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
