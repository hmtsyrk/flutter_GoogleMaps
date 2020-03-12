import 'package:flutter/material.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Image.asset("assets/images/ic_menu_user.png"),
          title: Text(
            "Profilim",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Image.asset("assets/images/ic_menu_history.png"),
          title: Text(
            "Yol Geçmişi",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Image.asset("assets/images/ic_menu_percent.png"),
          title: Text(
            "Gidilen Mesafe",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Image.asset("assets/images/ic_menu_notify.png"),
          title: Text(
            "Bildirimler",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings, color: Colors.lightBlue,), //Image.asset("assets/images/ic_menu_help.png"),
          title: Text(
            "Ayarlar",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Image.asset("assets/images/ic_menu_logout.png"),
          title: Text(
            "Çıkış",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        )
      ],
    );
  }
}