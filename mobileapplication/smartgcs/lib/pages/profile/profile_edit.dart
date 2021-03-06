import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

import '../../scoped_models/main.dart';

import '../../models/user.dart';

import '../../widgets/custom_text.dart' as customText;

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final double _textInputBorderRadius = 10;
final firestoreInstance = Firestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'name': '',
    'phone': '',
    'location': ''
  };

  TextEditingController _locationFieldController = TextEditingController();

  Form _buildForm(BuildContext context, MainModel model) {

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: Temp.n,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'full name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_textInputBorderRadius)),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Your full name is required';
              }
            },
            onSaved: (String value) {
              _formData['name'] = value;
            },
          ),
          SizedBox(height: 20,),
          TextFormField(
            initialValue: Temp.p,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'phone',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_textInputBorderRadius)),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Your phone number is required';
              } else if (!RegExp(r'^[0-9]+$')
                  .hasMatch(value.toLowerCase())||value.length!=10) {
                return 'Please enter a valid phone number';
              }
            },
            onSaved: (String value) {
              _formData['phone'] = value;
            },
          ),
          SizedBox(height: 20,),
          TextFormField( 
            controller: _locationFieldController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              suffixIcon: ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return model.gettingLocation
                      ? Container(
                        padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        )
                      : GestureDetector(
                          child: Icon(Icons.my_location),
                          onTap: () {
                            model.getLocation().then((String location){
                              setState(() {
                                _locationFieldController.text = location;
                              });
                            });
                          },
                        );
                },
              ),
              labelText: 'location',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_textInputBorderRadius)),
            ),
            validator: (String value) {
              
            },
            onSaved: (String value) {
              _formData['location'] = value;
            },
          ),
          SizedBox(height: 20,),
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model){
              return model.isLoading ? CircularProgressIndicator() : RaisedButton(
                child: customText.BodyText(text: 'SAVE', textColor: Colors.white,),
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    // model.client.update(
                    //   name: _formData['name'],
                    //   phone: _formData['phone'],
                    //   address: _formData['location'],
                    // );
                      Temp.n= _formData['name'];
                      Temp.p=_formData['phone'];
                      if(_formData['location']!=''){
                      Temp.a=_formData['location'];
                      }
                      Temp.d= DateTime.now().toIso8601String();

                      _onPressed(_formData['name'],_formData['phone'],Temp.a);
                  //  model.updateUser('clients', client: model.client).then((done){
                      Navigator.of(context).pop();
                  //  });
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
        child: SingleChildScrollView(
          child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model){
              return _buildForm(context, model);
            },
          ),
        )
      ),
    );
  }


void _onPressed(String n,String p,String a) async{
//  var firebaseUser = await FirebaseAuth.instance.currentUser();
if(IDCardClass.type=='client'){
  firestoreInstance.collection("users").document(IDCardClass.userid).updateData({
    "name": n,
    "phone": p,
    "address": a,
    "dateCreated":Temp.d
  }).then((_) {
    print("success!");
  });
  }
  else{
     firestoreInstance.collection("drivers").document(IDCardClass.userid).updateData({
    "name": n,
    "phone": p,
    "address": a,
    "dateCreated":Temp.d

  }).then((_) {
    print("success!");
  });
  }
  
}
}
