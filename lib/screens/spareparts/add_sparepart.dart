import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:services_form/brain/quality_suggestion.dart';
import 'package:services_form/brain/spareparts_suggestion.dart';
import 'package:services_form/brain/smartphone_suggestion.dart';
import 'package:services_form/widget/text_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:services_form/brain/spareparts_database.dart';
import 'package:services_form/brain/sqlite_services.dart';

tarikh() {
  var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  return formatter.format(now);
}

CashFlow cashflow;

final FirebaseDatabase database = FirebaseDatabase.instance;
BioSpareparts bio;

DatabaseReference databaseReference;

List<BioSpareparts> bioList;

final GlobalKey<FormState> formkey = GlobalKey<FormState>();
final csparepart = TextEditingController();
final ctype = TextEditingController();
final csupplier = TextEditingController();
final cquantity = TextEditingController();
final cmanufactor = TextEditingController();
final cdetails = TextEditingController();
final cprice = TextEditingController();

List supplierlist = [
  {"name": "MG", "id": "Mobile Gadget Resources"},
  {"name": "G", "id": "Golden Spareparts"},
  {"name": "GM", "id": "GM Communication"},
  {"name": "RnJ", "id": "RnJ Spareparts"},
  {"name": "OR", "id": "Orange Spareparts"},
];

class AddSparepart extends StatefulWidget {
  @override
  _AddSparepartState createState() => _AddSparepartState();
}

class _AddSparepartState extends State<AddSparepart> {
  bool _sparepartsmiss = false;
  bool _typemiss = false;
  bool _suppliermiss = false;
  bool _quantitymiss = false;
  bool _manufactor = false;
  bool _details = false;
  bool _price = false;

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bioList = [];
    bio = BioSpareparts(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    );
    databaseReference = database.reference().child('Spareparts');
    databaseReference.onChildChanged.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) async {
    setState(() {
      bioList.add(BioSpareparts.fromSnapshot((event.snapshot)));
    });
  }

  void _onEntryChanged(Event event) async {
    var oldEntry = bioList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      bioList[bioList.indexOf(oldEntry)] =
          BioSpareparts.fromSnapshot((event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          setState(() {
            csparepart.text.isEmpty
                ? _sparepartsmiss = true
                : _sparepartsmiss = false;
            ctype.text.isEmpty ? _typemiss = true : _typemiss = false;
            csupplier.text.isEmpty
                ? _suppliermiss = true
                : _suppliermiss = false;
            cquantity.text.isEmpty
                ? _quantitymiss = true
                : _quantitymiss = false;
            cmanufactor.text.isEmpty ? _manufactor = true : _manufactor = false;
            cdetails.text.isEmpty ? _details = true : _details = false;
            cprice.text.isEmpty ? _details = true : _details = false;
          });
          if (_sparepartsmiss == false &&
              _suppliermiss == false &&
              _typemiss == false &&
              _quantitymiss == false &&
              _manufactor == false &&
              _details == false &&
              _price == false) {
            _formConfirmation(context);
          }
        },
      ),
      appBar: AppBar(
        title: Text('Tambah Sparepart'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBar(
              password: false,
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                csupplier.text = suggestion['name'].toString();
              },
              callBack: (pattern) async {
                return supplierlist;
              },
              builder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.business),
                  title: Text('${suggestion['name']}'),
                  subtitle: Text('${suggestion['id']}'),
                );
              },
              controll: csupplier,
              hintTitle: 'Supplier',
              focus: false,
              valueChange: (vsupplier) {
                if (csupplier.text != vsupplier.toUpperCase())
                  csupplier.value =
                      csupplier.value.copyWith(text: vsupplier.toUpperCase());
              },
              keyType: TextInputType.name,
              err: _suppliermiss ? 'Sila masukkan nama supplier' : null,
            ),
            TextBar(
              password: false,
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                csparepart.text = suggestion.toString().toUpperCase();
              },
              callBack: (pattern) {
                return SmartphoneSuggestion.getSuggestions(pattern);
              },
              builder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.phone_android_sharp),
                  title: Text(suggestion),
                );
              },
              controll: csparepart,
              hintTitle: 'Model',
              focus: false,
              valueChange: (vmodel) {
                if (csparepart.text != vmodel.toUpperCase())
                  csparepart.value =
                      csparepart.value.copyWith(text: vmodel.toUpperCase());
              },
              keyType: TextInputType.name,
              err: _sparepartsmiss ? 'Sila masukkan model smartphone' : null,
            ),
            TextBar(
              password: false,
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                ctype.text = suggestion.toString().toUpperCase();
              },
              callBack: (pattern) {
                return PartsSuggestion.getSuggestions(pattern);
              },
              builder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.electrical_services_rounded),
                  title: Text(suggestion),
                  // subtitle: Text('${suggestion['id']}'),
                );
              },
              controll: ctype,
              hintTitle: 'Jenis Spareparts',
              focus: false,
              valueChange: (vtype) {
                if (ctype.text != vtype.toUpperCase())
                  ctype.value = ctype.value.copyWith(text: vtype.toUpperCase());
              },
              keyType: TextInputType.name,
              err: _typemiss ? 'Sila masukkan jenis spareparts' : null,
            ),
            TextBar(
              password: false,
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                cmanufactor.text = suggestion.toString().toUpperCase();
              },
              callBack: (pattern) {
                return ManufactorSuggestion.getSuggestions(pattern);
              },
              builder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.electrical_services_rounded),
                  title: Text(suggestion),
                  // subtitle: Text('${suggestion['id']}'),
                );
              },
              controll: cmanufactor,
              hintTitle: 'Kualiti Spareparts',
              focus: false,
              valueChange: (vmanufactor) {
                if (cmanufactor.text != vmanufactor.toUpperCase())
                  cmanufactor.value = cmanufactor.value
                      .copyWith(text: vmanufactor.toUpperCase());
              },
              keyType: TextInputType.name,
              err:
                  _manufactor ? 'Sila masukkan jenis kualiti spareparts' : null,
            ),
            TextBar(
              password: false,
              controll: cdetails,
              hintTitle: 'Maklumat Sparepart',
              hintEdit: 'cth: Warna, tarikh pengeluar battery, dll..',
              focus: false,
              valueChange: (vmanufactor) {
                if (cdetails.text != vmanufactor.toUpperCase())
                  cdetails.value =
                      cdetails.value.copyWith(text: vmanufactor.toUpperCase());
              },
              keyType: TextInputType.name,
              err: _details ? 'Sila masukkan makluamat sparepart' : null,
            ),
            TextBar(
              password: false,
              controll: cquantity,
              hintTitle: 'Kuantiti',
              focus: false,
              valueChange: (vquantity) {
                if (cquantity.text != vquantity.toUpperCase())
                  cquantity.value =
                      cquantity.value.copyWith(text: vquantity.toUpperCase());
              },
              keyType: TextInputType.number,
              err: _quantitymiss ? 'Sila masukkan kuantiti' : null,
            ),
            TextBar(
              password: false,
              controll: cprice,
              hintTitle: 'Harga Supplier',
              focus: false,
              valueChange: (vquantity) {
                if (cprice.text != vquantity.toUpperCase())
                  cprice.value =
                      cprice.value.copyWith(text: vquantity.toUpperCase());
              },
              keyType: TextInputType.number,
              err: _quantitymiss ? 'Sila masukkan harga supplier' : null,
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

_formConfirmation(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Batal"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text('Pasti'),
    onPressed: () {
      for (int i = 0; i < int.parse(cquantity.text); i++) {
        submit();
        localCF();
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, 'inventory');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Tambah Spareparts'),
    content: Text('Pastikan segala maklumat spareparts adalah betul!'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void localCF() {
  if (cashflow == null) {
    CashFlow cf = CashFlow(
      dahBayar: 0,
      price: int.parse(cprice.text) -
          int.parse(cprice.text) -
          int.parse(cprice.text),
      spareparts: '${csparepart.text} (${ctype.text})',
      tarikh: tarikh().toString(),
    );
    DBProvider.db.insert(cf).then((id) => {
          print('tambah '
              'ke database $id')
        });
  }
}

void submit() {
  String _tarikh = tarikh().toString();
  bio.sparepart = csparepart.text.toString();
  bio.type = ctype.text.toString();
  bio.supplier = csupplier.text.toString();
  bio.manufactor = cmanufactor.text.toString();
  bio.details = cdetails.text.toString();
  bio.date = _tarikh;
  bio.price = cprice.text;
  databaseReference
      .push()
      .set(bio.toJson())
      .then(
          (value) => showToast('Sparepart telah berjaya ditambah ke database'))
      .catchError((error) => showToast('Kesilapan telah berlaku: $error'));
}

void clear() {
  ctype.clear();
  csupplier.clear();
  csparepart.clear();
  cquantity.clear();
  cmanufactor.clear();
  cdetails.clear();
}
