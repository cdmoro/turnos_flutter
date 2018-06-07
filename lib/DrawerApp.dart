import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final Icon icon;
  final String to;
  final int notify;

  MenuItem(this.title, this.icon, this.to, [this.notify = 0]);
}

class DrawerApp extends StatelessWidget {
  final String current;

  DrawerApp([this.current = '']);

  final List<MenuItem> menu = [
    new MenuItem("Mis turnos", new Icon(Icons.home), "/"),
    new MenuItem("Historial", new Icon(Icons.history), "/historial", 4),
    new MenuItem("Configuración", new Icon(Icons.settings), "/configuracion"),
  ];

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: new CircleAvatar(child: new Text("C")),
              accountName: new Text("Cosme Fulanito"),
              accountEmail: new Text("cfulanito@gmail.com"),
            ),
            new Expanded(
              child: new ListView.builder(
                itemCount: menu.length,
                itemBuilder: (context, i) =>
                  new ListTile(
                    title: Text(menu[i].title),
                    leading: menu[i].icon,
                    selected: current == menu[i].to,
                    trailing: menu[i].notify != 0 ? 
                      new Text(menu[i].notify.toString()) : null,
                  )
              ),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Cerrar sesión"),
              leading: new Icon(Icons.lock),
            ),
          ]
        )
    );
  }
}
