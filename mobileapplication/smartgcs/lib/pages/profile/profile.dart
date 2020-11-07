import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../../scoped_models/main.dart';
import '../../models/user.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_text.dart' as customText;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgcs/scoped_models/auth.dart';

import './profile_edit.dart';
import './profile_pic_view.dart';
import 'package:smartgcs/scoped_models/main.dart';



class ProfilePage extends StatefulWidget {
 
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
final firestoreInstance = Firestore.instance;


  Container _buildProfile(BuildContext context) {
        String t;
        if(IDCardClass.type=='client'){t='client';}else{t='Driver';}
    return Container(
      margin: EdgeInsets.symmetric(vertical: 36, horizontal: 18),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 18),
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePicViewPage()
                ));
              },
              child: Hero(
                tag: 'profile_pic',
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                  radius: 70,
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 18),
            child: Column(
              children: <Widget>[
                customText.HeadlineText(
                  text:Temp.n,
                  textColor: Theme.of(context).primaryColor,
                ),
               
              ],
            ),
          ),
          
          Container(
            margin: EdgeInsets.only(top: 18),
            child: Column(
              children: <Widget>[
                ListTile(
                 title: Text('email'),
                 subtitle: Text(Temp.e),
                ),
                Divider(),
                ListTile(
                  title: Text('phone number'),
                  subtitle: Text(Temp.p),
                ),
                Divider(),
                ListTile(
                 title: Text('account type'),
                subtitle: Text(t),
                ),
                Divider(),
                ListTile(
                  title: Text('location'),
                  subtitle: Temp.a =='null' ? Text('No Address',
                  style: TextStyle(color: Colors.red),) : Text(Temp.a),
                ),
                
                Divider(),
                ListTile(
                  title: Text('Date Created'),
                  subtitle: Text(Temp.d),
                ),
                
              ],
            ),
         )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ProfileEditPage();
              }))
              
             
              
              ;
            },
          )
        ],
      ),
      body: Container(
        width: deviceWidth,
        child: SingleChildScrollView(
          child: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model){
             return _buildProfile(context);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
