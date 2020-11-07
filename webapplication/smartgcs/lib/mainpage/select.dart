
import 'package:smartgcs/userDetails/garbageBins_information.dart';

import 'package:smartgcs/userDetails/feedback.dart';
import 'package:smartgcs/userDetails/usertable.dart';
import 'package:smartgcs/userDetails/drivertable.dart';
import 'package:flutter/material.dart';

class MenuApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'SmartGCS Home Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Admin Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String satisfaction;
  final List<String> opinion= ['Dispose waste','Recycle waste','De-cluster waste'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,


          ),
          actions: [
            DropdownButton<String>(
          hint: Text('Choose today collecting wate type',
          ),
          
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

          ],
        ),
        body: Stack(

              children: <Widget>[
          Image(
          image: AssetImage("assets/images/background.jpg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
             Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //SizedBox(height: 50),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                       //return UserInfromation();
                            return MyApp();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF00C853),
                            Color(0xFF00E676),
                            Color(0xFF69F9AE),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Users\'s Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                 // SizedBox(height: 24),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                     // return  DriverInformation();
                        return MyApp1();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF00C853),
                            Color(0xFF00E676),
                            Color(0xFF69F9AE),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Driver\'s Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  //SizedBox(height: 24),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return GarbageBin();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF00C853),
                            Color(0xFF00E676),
                            Color(0xFF69F9AE),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Garbage Bins\'s Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                 // SizedBox(height: 24),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return UserFeedbacks();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF00C853),
                            Color(0xFF00E676),
                            Color(0xFF69F9AE),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Comments',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ]),
          ],
        ));
  }
}
