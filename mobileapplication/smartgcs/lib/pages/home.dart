import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smartgcs/models/user.dart';
import 'package:smartgcs/scoped_models/main.dart';

import '../scoped_models/main.dart';

import '../widgets/custom_text.dart' as customText;
import '../widgets/bottom_nav.dart';
import 'package:smartgcs/scoped_models/database.dart';
import '../utils/responsive.dart';
import 'package:smartgcs/scoped_models/auth.dart';
import 'package:smartgcs/pages/feedbacks/feedback.dart';
import 'package:smartgcs/pages/loc.dart';
import 'package:smartgcs/pages/location.dart';
import 'package:provider/provider.dart';
import '../pages/info_center/info.dart';
import './dispose/dispose_waste.dart';
import './recycle/recycle_waste.dart';
import './decluster/decluster.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth=AuthService();
final firestoreInstance = Firestore.instance;
  String satisfaction;
  final List<String> opinion= ['Enable','Disable'];

  final double pad_vertical = 13.0;

  final List<Map<String, dynamic>> _smartGCSUserOptions = [
    {
      'name': 'Dispose Waste',
      'imageUrl': 'assets/dispose.jpg',
      'summary': 'Get rid of waste with ease',
      'page': DisposeWastePage()
    },
    {
      'name': 'Recycle Waste',
      'imageUrl': 'assets/dispose.jpg',
      'summary': 'Make money from recycling waste',
      'page': DisposeWastePage()
    },
    {
      'name': 'Dispose Waste',
      'imageUrl': 'assets/dispose.jpg',
      'summary': 'Get rid of waste with ease',
      'page': DisposeWastePage()
    },
  ];
  
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
          SizedBox(
            height: 30,
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10, vertical: pad_vertical),
            child: Row(
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
                    child: Text('Search Truck driver location'),
                    onPressed: () {
                      Navigator.pushNamed(context, 'loc');
                    },
                  ),
                ),
                FlatButton(
                  child: Icon(Icons.search),
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
                    Navigator.pushNamed(context, 'loc');
                  },
                )
              ],
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
              'The type of waste collected today: Recycle_waste',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 5, bottom: 18, left: 10, right: 10),
            child: Text(
              'Get access to view locations of Truck drivers',
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

  Widget _buildSlidingSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: pad_vertical, horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                _smartGCSUserOptions.length,
                (int index) => Card(
                        child: Column(
                      children: <Widget>[
                        Image(
                          width: 130,
                          image: AssetImage(
                              _smartGCSUserOptions[index]['imageUrl']),
                        ),
                        ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text(_smartGCSUserOptions[index]['name']),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          _smartGCSUserOptions[index]['page']));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    )))),
      ),
    );
  }

  Widget _buildCategoryWidget(
      BuildContext context, String title, String imageUrl,
      [dynamic route]) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
      padding: EdgeInsets.symmetric(horizontal: getSize(context, 30), vertical: getSize(context, 30)),
      child: Column(
        children: <Widget>[
          Image(
            width: getSize(context, 70),  //? previously 110
            height: getSize(context, 70), //? previously 110
            image: AssetImage(imageUrl),
          ),
          SizedBox(
            height: getSize(context, 20),
          ),
          Container(
            width: getSize(context, 130),
            alignment: Alignment.center,
            // child: customText.BodyText(
            //   text: title,
            //   textColor: Theme.of(context).primaryColor,
            //   fontSize: 18,
            //   fontWeight: FontWeight.w700,
            // ),
            child: RichText(
              textAlign: TextAlign.center,

              text: TextSpan(
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                  color: Theme.of(context).primaryColor
                ),),
                children: [
                  TextSpan(
                    text: title + "\n",
                    style: Theme.of(context).textTheme.title.merge(TextStyle(
                      color: Theme.of(context).primaryColor
                    ))
                  ),
                  TextSpan(
                    text: title == "Info" ? "Center" : "Waste"
                  )
                ]
              ),
            ),
          )
        ],
      ),
      onPressed: () {
        if (route == null) return;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) => route));
      },
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildCategoryWidget(context, 'Dispose',
                  'assets/recycling-bin.png', DisposeWastePage()),
              _buildCategoryWidget(context, 'Recycle',
                  'assets/eco-factory.png', RecycleWastePage())
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildCategoryWidget(
                  context, 'De-cluster', 'assets/target.png', DeclusterPage()),
              _buildCategoryWidget(
                  context, 'Info', 'assets/analysis.png',InfoPage())
             //  _buildCategoryWidget(context, 'Sewage', 'assets/sewage.png',InfoPage())
            ],
          ),
          // SizedBox(
          //   height: 30,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Widget>[
          //     // _buildCategoryWidget(context, 'Upcycling', 'assets/creative.png'),
          //     _buildCategoryWidget(
          //         context, 'Info', 'assets/analysis.png')
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 230,
              width: double.infinity,
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
            // ScopedModelDescendant<MainModel>(
            //   builder: (BuildContext context, Widget child, MainModel model){
            //     return ListTile(
            //       leading: Icon(Icons.format_list_bulleted),
            //       title: Text('Transactions'),
            //       onTap: () {
            //         Navigator.of(context).pop();
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (BuildContext context) => TransactionsPage(model)));
            //         //  Navigator.pushNamed(context, 'profile');
            //       },
            //     );
            //   },
            // ),
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
             ListTile(
              leading: Icon(Icons.add_comment),
              title: Text('Feedback'),
              onTap: () {
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return FeedbackPage();
              }));
                // Navigator.pop(context);
                // Navigator.pushNamed(context, 'feedback');
              },
            ),
            // ScopedModelDescendant<MainModel>(
            //   builder: (BuildContext context, Widget child, MainModel model){
            //     return ListTile(
            //       leading: Icon(Icons.account_balance_wallet),
            //       title: Text('Wallet'),
            //       onTap: () {
            //         Navigator.of(context).pop();
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (BuildContext context) => WalletPage(model, false)));
            //         //  Navigator.pushNamed(context, 'profile');
            //       },
            //     );
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
              onTap: () async {            
                await _auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('welcome', (Route route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
  onpresse();
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text('Smart GCS'),
        actions: <Widget>[

            DropdownButton<String>(
              hint: Text('Bin state'),
              onChanged: (String value) {

                  satisfaction = value;

              },
              value: satisfaction,
              items: opinion.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // ScopedModelDescendant(
            //   builder: (BuildContext context, Widget child, MainModel model){
            //     print(jsonEncode(model.client.toMap()));
            //     return Container();
            //   },
            // ),
                

            _buildTopSection(context),
            // _buildBottomSection(),
            _buildCategoriesSection(context),
            // SizedBox(height: 20,),
            // _buildMessagesSection()
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }

void onpresse() async{
 
    firestoreInstance.collection("users").document(IDCardClass.userid).get().then((value){
    
  Temp.n=value.data["name"];
   Temp.p=value.data["phone"];
   Temp.e=value.data["email"];
   Temp.a=value.data["address"];   
   Temp.u=value.data["username"];
  Temp.d=value.data["dateCreated"];
  
   });
      

  }



}
