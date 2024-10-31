import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'zaposleni_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ZaposleniAdapter());
  await Hive.openBox<Zaposleni>('zaposleniBox');

  runApp(const MojaAplikacija());
}

class MojaAplikacija extends StatelessWidget {
  const MojaAplikacija({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikacija za zaposlene',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ZaslonZaVnosPodatkov(),
    );
  }
}
