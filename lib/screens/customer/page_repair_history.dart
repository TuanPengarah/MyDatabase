import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:services_form/screens/spareparts/repprint.dart';
import 'package:services_form/widget/card_details.dart';

SliverChildListDelegate repairHistory(
  String passID,
  String passName,
  String passPhone,
) {
  return SliverChildListDelegate(
    [
      Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('customer')
              .doc(passID)
              .collection('repair history')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('Loading Jap...'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: snapshot.data.docs.map((document) {
                return CardDetails(
                  model: document['Model'],
                  harga: document['Harga'].toString(),
                  kerosakkan: document['Kerosakkan'],
                  mid: document['MID'],
                  remarks: document['Remarks'],
                  status: document['Status'],
                  tarikh: document['Tarikh'],
                  technician: document['Technician'],
                  timestamp: document['timeStamp'],
                  password: document['Password'],
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => Reprint(
                          nama: passName,
                          noPhone: passPhone,
                          mid: document['MID'],
                          model: document['Model'],
                          kerosakkan: document['Kerosakkan'],
                          price: document['Harga'],
                          remarks: document['Remarks'],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      SizedBox(
        height: 230,
      ),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('customer')
            .doc(passID)
            .collection('repair history')
            .where('Status', isEqualTo: 'Selesai')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('Loading Jap...'),
                ),
              ],
            );
          }
          double sum = 0.0;
          int convert;
          var ds = snapshot.data.docs;
          for (int i = 0; i < ds.length; i++)
            sum += (ds[i]['Harga']).toDouble();
          convert = sum.round();
          return Center(
              child: convert <= 0
                  ? Text(
                      'Tidak pernah keluar modal untuk repair',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  : Text(
                      'Jumlah yang telah dibelanjakan: RM${convert.toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ));
        },
        // Text('Total semua ialah ${total.toString()}'),
      ),
      SizedBox(
        height: 200,
      ),
    ],
  );
}
