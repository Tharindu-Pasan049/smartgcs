import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smartgcs/models/user.dart';

import '../../scoped_models/main.dart';
import 'package:smartgcs/pages/searchhome.dart';
import 'package:smartgcs/pages/findpath.dart';

import '../../widgets/custom_text.dart' as customText;
import '../../models/update.dart';
import 'package:smartgcs/scoped_models/auth.dart';
import 'package:smartgcs/pages/driverlocation.dart';
import 'package:smartgcs/pages/tracklocation.dart';




import 'package:cloud_firestore/cloud_firestore.dart';

class VendorHomePage extends StatelessWidget {
  final double pad_vertical = 13.0;
   final AuthService _auth=AuthService();
final firestoreInstance = Firestore.instance;
 
  double _targetWidth = 0;

  double _getSize(final double default_1440) {
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 230,
              width: _targetWidth,
              color: Theme.of(context).primaryColor,
              //  child: CircleAvatar(
              //    child: Image(image: AssetImage('assets/profile.png'), fit: BoxFit.fill,),
              //  ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
              selected: true,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                print(Temp.n);
                print(Temp.p);
                print(Temp.e);
                print(Temp.a);
                print(Temp.d);
                Navigator.pop(context);
                Navigator.pushNamed(context, 'profile');
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.account_balance_wallet),
            //   title: Text('Wallet'),
            //   onTap: () {
            //     // Navigator.of(context).push(MaterialPageRoute(
            //     //   builder: (BuildContext context) => WalletPage(false)
            //     // ));
            //     //  Navigator.pushNamed(context, 'profile');
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.shopping_cart),
            //   title: Text('Shop'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     //  Navigator.pushNamed(context, 'profile');
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.supervised_user_circle),
            //   title: Text('Vendors'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     //  Navigator.pushNamed(context, 'profile');
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.markunread_mailbox),
            //   title: Text('Packages'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     //  Navigator.pushNamed(context, 'profile');
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.label_outline),
              title: Text('Logout'),
              onTap: () async{
                await _auth.signOut();/////////////////////////
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('welcome', (Route route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/waste_home.jpg'),
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            fit: BoxFit.cover),
      ),
      child: Column(
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: pad_vertical),
          //   child: Text(
          //     'You earned 50 points just for installation, check your wallet',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // OutlineButton(
          //   child: Text('Search vendor recycler'),
          // ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10, vertical: pad_vertical),
            child: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model){
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 13.5),
                        color: Colors.white,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              bottomLeft: Radius.circular(100),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0)),
                        ),
                        child: Text('View locations of bins'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Findpaths()));
                        },
                      ),
                    ),
                    FlatButton(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      ),
                      color: Theme.of(context).accentColor,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Findpaths()));
                      },
                    )
                  ],
                );
              },
            ),
            /*TextField(
                onTap: () => Navigator.pushNamed(context, 'search'),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Search vendor recycler',
                    suffixIcon: Icon(Icons.search)
                ),
              )*/
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                top: pad_vertical, bottom: 0, left: 10, right: 10),
            child: Text(
              'Make city without waste',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 5, bottom: 18, left: 10, right: 10),
            child: Text(
              'Get access to view locations of garbage bins',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  final List<Update> _messages = [
    Update(
      id: '1',
      icon: Icon(Icons.account_balance_wallet),
      title: 'Clean Environment',
      message: 'Collect all grabage from everywhere',
      action: 'COLLECT',
    ),
    Update(
      id: '2',
      icon: Icon(Icons.done_all),
      title: 'View Bin locations',
      message: 'User\'s created bin locations',
      action: 'VIEW',
    ),
    Update(
      id: '3',
      icon: Icon(Icons.account_balance_wallet),
      title: 'View Path',
      message: 'You can view route to collect garbage',
      action: 'Route',
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
                    print(_messages);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
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
    _targetWidth = MediaQuery.of(context).size.width;
    onpresse();

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text('SmartGCS'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildTopSection(context),
              SizedBox(
                height: 20,
              ),
              _buildMessagesSection()
            ],
          ),
        ),
      ),
    );
  }
void onpresse() async{
   print(IDCardClass.userid);
    firestoreInstance.collection("drivers").document(IDCardClass.userid).get().then((value){
    
  Temp.n=value.data["name"];
   Temp.p=value.data["phone"];
   Temp.e=value.data["email"];
   Temp.a=value.data["address"];   
   Temp.u=value.data["username"];
  Temp.d=value.data["dateCreated"];
  
   });
      

  }


}
