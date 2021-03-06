import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/check_lock.dart';

buttomManagement(context) {
  bool isDarkMode =
      MediaQuery.of(context).platformBrightness == Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          isDarkMode == true ? Colors.grey[900] : Colors.white,
      systemNavigationBarIconBrightness:
          isDarkMode == true ? Brightness.light : Brightness.dark));
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext c) {
        return Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Pengurusan Sistem',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'inventory');
                  },
                  child: Text(
                    'Semua Stok / Spareparts',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'allpricelist');
                    // Navigator.pushNamed(context, 'calculate');
                  },
                  child: Text(
                    'Senarai Harga',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'calculate');
                  },
                  child: Text(
                    'Pengiraan Harga',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'sales');
                  },
                  child: Text(
                    'Buat Pembayaran',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<CheckLock>(context, listen: false).setLock =
                        true;
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'cashflow');
                  },
                  child: Text(
                    'Cash Flow',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ],
        );
      }).whenComplete(() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blueGrey,
        systemNavigationBarIconBrightness: Brightness.light));
  });
}
