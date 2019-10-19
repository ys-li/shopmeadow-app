import 'package:flutter/material.dart';
import 'themes.dart';
import '../Utils/lang.dart';
import '../Utils/Favourites.dart';
import '../Utils/UserStat.dart';
import '../Utils/UserPref.dart';
import 'modal_submitNewStore.dart';
import 'modal_about.dart';
import '../Utils/DataVersionControl.dart';
import 'package:url_launcher/url_launcher.dart';

class modal_settings extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: new Text(IBLocale.MENU_SETTINGS, style: HeaderStyle)
        ),
        body: new ListView(
            children: [
              new InkWell(
                  child: new ListTile(
                    leading: new Icon(Icons.clear_all),
                    title: new Text(IBLocale.CLEAR_USER_DATA, style: LightStyle),
                    onTap: () {
                      AlertDialog dialog = new AlertDialog(
                        title: new Text(IBLocale.WARNING),
                        content: new Text(IBLocale.CLEAR_USER_DATA_PROMPT, style: LightStyle),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text(IBLocale.CONFIRM),
                            onPressed: () {
                              Favourites.clear();
                              UserStat.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text(IBLocale.CANCEL),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                      showDialog(context: context, child: dialog);
                    },
                  )
              ),
              new InkWell(
                  child: new ListTile(
                    leading: new Icon(Icons.translate),
                    title: new Text(IBLocale.CHANGE_LANGUAGE, style: LightStyle),
                    onTap: () {
                      AlertDialog dialog = new AlertDialog(
                        title: new Text(IBLocale.WARNING),
                        content: new Text(IBLocale.CHANGE_LANGUAGE_PROMPT, style: LightStyle),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text(IBLocale.CONFIRM),
                            onPressed: () {
                              UserPref.langChinese = !UserPref.langChinese;
                              IBLocale.setLanguage(UserPref.langChinese);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text(IBLocale.CANCEL),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                      showDialog(context: context, child: dialog);
                    },
                  )
              ),
              new InkWell(
                  child: new ListTile(
                    leading: new Icon(Icons.store),
                    title: new Text(IBLocale.MENU_NEWSTORE, style: LightStyle),
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute<Null>(builder: (BuildContext context){
                            return new modal_submitNewStore();
                          })
                      );
                    },
                  )
              ),
              new Divider(),
              new InkWell(
                  child: new ListTile(
                    title: new Text(IBLocale.MENU_FEEDBACK, style: LightStyle),
                    onTap: () {
                        launch("http://ib.enchorhk.tech/feedback");
                    },
                  )
              ),
              new InkWell(
                  child: new ListTile(
                    title: new Text(IBLocale.MENU_TERMS, style: LightStyle),
                    onTap: () {
                        launch("http://ib.enchorhk.tech/feedback");
                    },
                  )
              ),
              new InkWell(
                  child: new ListTile(
                    title: new Text(IBLocale.MENU_ABOUT, style: LightStyle),
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute<Null>(builder: (BuildContext context){
                            return new modal_about();
                          })
                      );
                    },
                  )
              ),
              new Divider(),
              new Container(height: 10.0),
              new Center(
                child: new Text("ShopMeadow v" + DataVersionControl.version + "\n//made with \u{2764}", style: LightStyle.copyWith(color: Colors.black54))
              )
            ]
        )
    );
  }
}