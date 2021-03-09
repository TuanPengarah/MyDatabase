import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/screens/job_sheet.dart';
import 'package:services_form/screens/new_customer_details.dart';
import 'customer_details.dart';
import 'package:avatar_letter/avatar_letter.dart';

class CustomerDatabase extends StatefulWidget {
  @override
  _CustomerDatabaseState createState() => _CustomerDatabaseState();
}

class _CustomerDatabaseState extends State<CustomerDatabase> {
  bool searchState = false;
  String _searchController;
  Future resultsLoaded;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: 'Tambah Jobsheet baru',
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobSheet(
                    editCustomer: false,
                  ),
                ),
              );
            },
          ),
          title: !searchState
              ? Text('All Customer')
              : TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchController = value.toLowerCase();
                    });
                  },
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    fillColor: Colors.white,
                    hoverColor: Colors.white,
                    hintText: 'Cari nama pelanggan...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
          centerTitle: true,
          actions: [
            !searchState
                ? IconButton(
                    tooltip: 'Cari customer',
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.close_rounded),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                      });
                    },
                  ),
          ],
        ),
        body: searchState == false
            ? Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('customer')
                      .orderBy('Nama')
                      .snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('Loading jap'),
                      );
                    }
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        return ListTile(
                          leading: Hero(
                            tag: document.id,
                            child: AvatarLetter(
                              textColor: Colors.white,
                              numberLetters: 2,
                              fontSize: 15,
                              upperCase: true,
                              letterType: LetterType.Circular,
                              text: document['Nama'],
                              backgroundColor: Colors.blueGrey,
                              backgroundColorHex: null,
                              textColorHex: null,
                            ),
                          ),
                          title: Text('' + document['Nama']),
                          subtitle: Text('' + document['No Phone']),
                          onLongPress: () {},
                          onTap: () {
                            SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle(
                                    systemNavigationBarColor: Colors
                                        .blueGrey // navigation bar color // status bar color
                                    ));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewCustomerDetails(
                                  nama: document['Nama'],
                                  databaseUID: document.id,
                                  nomborTelefon: document['No Phone'],
                                  email: document['Email'],
                                ),
                              ),
                            );
                          },
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            : Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('customer')
                      .where('Search Index', arrayContains: _searchController)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('Loading jap'),
                      );
                    }
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        return ListTile(
                          leading: AvatarLetter(
                            textColor: Colors.white,
                            numberLetters: 2,
                            fontSize: 15,
                            upperCase: true,
                            letterType: LetterType.Circular,
                            text: document['Nama'],
                            backgroundColor: Colors.blueGrey,
                            backgroundColorHex: null,
                            textColorHex: null,
                          ),
                          title: Text('' + document['Nama']),
                          subtitle: Text('' + document['No Phone']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerDetails(
                                  nama: document['Nama'],
                                  phone: document['No Phone'],
                                  model: document['Harga'],
                                  id: document.id,
                                  price: document['Search Index'],
                                  email: document['Email'],
                                  remarks: document['Remarks'],
                                  password: document['Password'],
                                ),
                              ),
                            );
                          },
                          trailing: Icon(Icons.keyboard_arrow_right_sharp),
                        );
                      }).toList(),
                    );
                  },
                ),
              ));
  }
}
