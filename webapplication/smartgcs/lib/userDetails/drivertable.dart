import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:responsive_table/ResponsiveDatatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgcs/background/background.dart';
import 'package:smartgcs/locations/driverlocation.dart';

import 'package:smartgcs/background/background.dart';
import '../mainpage/select.dart';
import 'package:flutter/services.dart';

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drivers Details',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => DataPage(),
      },
    );
  }
}

class DataPickerPage extends StatefulWidget {
  @override
  _DataPickerPageState createState() => _DataPickerPageState();
}

class _DataPickerPageState extends State<DataPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DataPage extends StatefulWidget {
  DataPage({Key key}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "ID",
        value: "id",
        show: false,
        sortable: true,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "UserID",
        value: "userid",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        // flex: 1,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Address",
        value: "address",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Email",
        value: "email",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "PhoneNo",
        value: "phoneno",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "DateCreated",
        value: "date",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),


    /* DatatableHeader(
        text: "Received",
        value: "received",
        show: true,
        sortable: false,
        sourceBuilder: (value, row) {
          List list = List.from(value);
          return Container(
            child: Column(
              children: [
                Container(
                  width: 85,
                  child: LinearProgressIndicator(
                    value: list.first / list.last,
                  ),
                ),
                Text("${list.first} of ${list.last}")
              ],
            ),
          );
        },
        textAlign: TextAlign.center),*/
  ];

  List<int> _perPages = [5, 10, 15, 100];
  int _total = 100;
  int _currentPerPage;
  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _source = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  String _selectableKey = "id";

  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;

  // List<Map<String, dynamic>> _generateData() {
  _generateData(){
    List<Map<String, dynamic>> temps = List<Map<String, dynamic>>();

    FirebaseFirestore.instance.collection('drivers').get().then((docs)
    {
      if(docs.docs.isNotEmpty){
        for(int i=0;i<docs.docs.length;++i){

          _source.add({
            "id": i,
            "userid":docs.docs[i].id,
            "name": docs.docs[i].data()['name'],
            "address": docs.docs[i].data()['address'],
            "email": docs.docs[i].data()['email'],
            "phoneno": docs.docs[i].data()['phone'],
            "date": docs.docs[i].data()['dateCreated'],
            // "location": docs.docs[i].data()['location']['latitude'],
            // "locationd": docs.docs[i].data()['location']['longitude'],

          });
          // String c= i.toString();
//initMarker(docs.documents[i].data,c);

        }

      }
    });



    // for (var data in source) {
    //   temps.add({
    //     "id": i,
    //     "name": "$i\000$i",
    //     "address": "Product Product Product Product $i",
    //     "email": "Category-$i",
    //     "phoneno": "${i}0.00",
    //     "date": "20.00",
    //
    //   });
    //   i++;
    // }
    // return temps;
  }


  Future _initData() async{
    setState(() => _isLoading = true);
    //  Future.delayed(Duration(seconds: 3)).then((value) {
    //_source.addAll(_generateData());
    _generateData();
    setState(() => _isLoading = false);
    //  });
  }

  @override
  void initState() {
    super.initState();
    //setState(() {
      _initData();
      

   // });
     WidgetsFlutterBinding.ensureInitialized();
  }


  @override

  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(

      SystemUiOverlayStyle(statusBarColor: primaryColor),
    );

    return Scaffold(

      appBar:AppBar(


        //backgroundColor:Colors.purpleAccent,
        title: Container(

          alignment: Alignment.topLeft,
          child: Text("Drivers' Details",

              style: TextStyle(

                color: Colors.white,
                fontSize: 30.0,
              )),

        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
              return MenuApp();
            }), (Route route) => false);
          },
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),
      ),

      body: SingleChildScrollView(

          child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,

              children: [
                Container(

                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(

                    maxHeight: 700,
                  ),
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.black,
                    clipBehavior: Clip.none,
                    child: ResponsiveDatatable(
                      title: !_isSearch
                          ? RaisedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text("Details"))
                          : null,
                      // actions: [
                      //   if (_isSearch)
                      //     Expanded(
                      //         child: TextField(
                      //           decoration: InputDecoration(
                      //               prefixIcon: IconButton(
                      //                   icon: Icon(Icons.cancel),
                      //                   onPressed: () {
                      //                     setState(() {
                      //                       _isSearch = false;
                      //                     });
                      //                   }),
                      //               suffixIcon: IconButton(
                      //                   icon: Icon(Icons.search), onPressed: () {})),
                      //         )),
                      //   if (!_isSearch)
                      //     IconButton(
                      //         icon: Icon(Icons.search),
                      //         onPressed: () {
                      //           setState(() {
                      //             _isSearch = true;
                      //           });
                      //         })
                      // ],
                      headers: _headers,
                      source: _source,
                      selecteds: _selecteds,
                      showSelect: _showSelect,
                      autoHeight: false,
                      onTabRow: (data) {
                        print("table data:  "+data['name']);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                            return LocationDriver(data['userid']);



                             // return MyApp2();
                            }));
//  Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => LocationDriver(data['userid'])));
                        
                      },
                      onSort: (value) {
                        setState(() {
                          _sortColumn = value;
                          _sortAscending = !_sortAscending;
                          if (_sortAscending) {
                            _source.sort((a, b) =>
                                b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                          } else {
                            _source.sort((a, b) =>
                                a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                          }
                        });
                      },
                      sortAscending: _sortAscending,
                      sortColumn: _sortColumn,
                      isLoading: _isLoading,
                      onSelect: (value, item) {
                        print("$value  $item ");
                        if (value) {
                          setState(() => _selecteds.add(item));
                        } else {
                          setState(
                                  () => _selecteds.removeAt(_selecteds.indexOf(item)));
                        }
                      },
                      onSelectAll: (value) {
                        if (value) {
                          setState(() => _selecteds =
                              _source.map((entry) => entry).toList().cast());
                        } else {
                          setState(() => _selecteds.clear());
                        }
                      },
                      footers: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("Rows per page:"),
                        ),
                        if (_perPages != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton(
                                value: _currentPerPage,
                                items: _perPages
                                    .map((e) => DropdownMenuItem(
                                  child: Text("$e"),
                                  value: e,
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _currentPerPage = value;
                                  });
                                }),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentPage =
                              _currentPage >= 2 ? _currentPage - 1 : 1;
                            });
                          },
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () {
                            setState(() {
                              _currentPage++;
                            });
                          },
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ]
          )
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _initData();
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}