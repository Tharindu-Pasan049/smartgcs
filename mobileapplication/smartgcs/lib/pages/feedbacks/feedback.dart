import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

import '../../scoped_models/main.dart';
import '../../scoped_models/constants.dart';

import '../../models/user.dart';

import '../../widgets/custom_text.dart' as customText;

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final double _textInputBorderRadius = 5;
  final Firestore fb = Firestore.instance;

final firestoreInstance = Firestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'message': ''
  };
String satisfaction;
final List<String> opinion= ['SATISFY','NOT SATISFY'];
  Form _buildForm(BuildContext context, MainModel model) {

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //  Text('Your opinion of our service'),
          // DropdownButtonFormField(
          //   decoration: textInputDecoration,
          //  value:satisfaction ?? opinion[0],
          //   items: opinion.map((opinions){
          //     return DropdownMenuItem(
          //       value: opinions,
          //       child: Text(opinions),
          //     );
          //   }).toList(),
          //   onChanged: (value)=> setState(()=> satisfaction=value),
          // ),
  DropdownButton<String>(
          hint: Text('Choose Your opinion'),
          onChanged: (String value) {
            setState(() {
              satisfaction = value;
            });
          },
          value: satisfaction,
          items: opinion.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
           ),


          SizedBox(height: 20,),
          TextFormField(  
            maxLines: 4,
            minLines: 2,       
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.add_comment),
              labelText: 'comment',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_textInputBorderRadius)),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Type your comment of our service';
              } 
            },
            onSaved: (String value) {
              _formData['message'] = value;
            },
          ),
          SizedBox(height: 30,),
          
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model){
              return model.isLoading ? CircularProgressIndicator() : RaisedButton(
                child: customText.BodyText(text: 'SEND', textColor: Colors.white,),
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    _formKey.currentState.save();
                   
                      String d= DateTime.now().toIso8601String();
                    

                      _onPressed(satisfaction,_formData['message'],d);
           
                      Navigator.of(context).pop();
                  
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
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback of our Service'),
      ),
      body: Container(
        width: deviceWidth,
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

     firestoreInstance.collection("feedbacks").document(IDCardClass.userid).setData({
    "customer_opinion": n,
    "comment": p,
    "Date_of_comment": a,
    

  });
  
  
}
}
