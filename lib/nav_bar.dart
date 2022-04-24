import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: PageList(),
    );
  }
}

class NavList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return Container(
        width: 0,
      );
    } else {
      return SizedBox(width: 100, child: PageList());
    }
  }
}

class PageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: [
        (ModalRoute.of(context)?.settings.name != '/home')
            ? ListTile(
                title: Text("Home Page"),
                onTap: () {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushNamed(context, '/home');
                },
              )
            : Container(),
        (ModalRoute.of(context)?.settings.name != '/input')
            ? ListTile(
                title: Text("Input"),
                onTap: () {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushNamed(context, '/input');
                },
              )
            : Container(),
      ],
    );
  }
}
