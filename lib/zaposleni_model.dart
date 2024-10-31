import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'zaposleni_model.g.dart';

@HiveType(typeId: 0)
class Zaposleni extends HiveObject {
  @HiveField(0)
  final String ime;

  @HiveField(1)
  final String priimek;

  @HiveField(2)
  final String delovnoMesto;

  @HiveField(3)
  final DateTime datumRojstva;

  @HiveField(4)
  final DateTime uraPrihoda;

  @HiveField(5)
  final DateTime uraOdhoda;

  Zaposleni({
    required this.ime,
    required this.priimek,
    required this.delovnoMesto,
    required this.datumRojstva,
    required this.uraPrihoda,
    required this.uraOdhoda,
  });
}
