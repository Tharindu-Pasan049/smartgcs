import 'package:flutter/material.dart';

import '../../models/update.dart';

import '../../widgets/custom_text.dart' as customText;
import '../../widgets/bottom_nav.dart';

class InfoPage extends StatefulWidget{
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  

  final List<Update> _messages = [
    Update(
      id: '1',
      icon: Icon(Icons.account_balance_wallet),
      title: 'Drivers',
      message: 'View locations',
      action: 'Driver',
    ),
    Update(
      id: '2',
      icon: Icon(Icons.done_all),
      title: 'Bin location',
      message: 'Set bin location',
      action: 'VIEW',
    ),
    Update(
      id: '3',
      icon: Icon(Icons.account_balance_wallet),
      title: 'Edit profile',
      message: 'check your profile',
      action: 'View',
    ),
  ];

  Widget _buildMessagesSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: List.generate(
        _messages.length,
        (int index) => Dismissible(
          key: Key(_messages[index].id),
          onDismissed: (DismissDirection dir) {
            _messages.removeAt(index);
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.only(top: 15),
              color: Theme.of(context).primaryColor.withAlpha(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: _messages[index].icon,
                    title: Text(_messages[index].title),
                    subtitle: Text(_messages[index].message),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text(_messages[index].action),
                          onPressed: () {},
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'),
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                padding: EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.green.shade700
                    ]
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        customText.TitleText(text: 'Streak', textColor: Theme.of(context).accentColor,),
                        customText.HeadlineText(
                          text: '30',
                          fontSize: 100,
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        customText.TitleText(text: 'Locations', textColor: Theme.of(context).accentColor,),
                        customText.HeadlineText(
                          text: '20',
                          fontSize: 100,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 25,),
              _buildMessagesSection()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(4),
    );
  }
}