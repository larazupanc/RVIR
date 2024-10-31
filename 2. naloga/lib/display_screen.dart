import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'zaposleni_model.dart';

class ZaslonZaPrikazZaposlenih extends StatefulWidget {
  const ZaslonZaPrikazZaposlenih({super.key});

  @override
  State<ZaslonZaPrikazZaposlenih> createState() => _ZaslonZaPrikazZaposlenihState();
}

class _ZaslonZaPrikazZaposlenihState extends State<ZaslonZaPrikazZaposlenih> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seznam zaposlenih'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Zaposleni>('zaposleniBox').listenable(),
        builder: (context, Box<Zaposleni> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Ni zaposlenih.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final zaposleni = box.getAt(index);
              return ListTile(
                title: Text('${zaposleni!.ime} ${zaposleni.priimek}'),
                onTap: () => _pokaziPodrobnostiZaposlenega(context, zaposleni, index),
              );
            },
          );
        },
      ),
    );
  }

  void _pokaziPodrobnostiZaposlenega(BuildContext context, Zaposleni zaposleni, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${zaposleni.ime} ${zaposleni.priimek}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Delovno mesto: ${zaposleni.delovnoMesto}'),
              Text('Datum rojstva: ${zaposleni.datumRojstva}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Zapri'),
            ),
            TextButton(
              onPressed: () {
                // Brisanje zaposlenega
                Hive.box<Zaposleni>('zaposleniBox').deleteAt(index);
                Navigator.pop(context);
              },
              child: const Text('Izbriši'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close current dialog
                _urediZaposlenega(context, zaposleni, index); // Open edit form
              },
              child: const Text('Uredi'),
            ),
          ],
        );
      },
    );
  }

  void _urediZaposlenega(BuildContext context, Zaposleni zaposleni, int index) {
    final _imeKontroler = TextEditingController(text: zaposleni.ime);
    final _priimekKontroler = TextEditingController(text: zaposleni.priimek);
    String _izbranoDelovnoMesto = zaposleni.delovnoMesto;
    DateTime? _izbranDatum = zaposleni.datumRojstva;
    TimeOfDay? _uraPrihoda = TimeOfDay.fromDateTime(zaposleni.uraPrihoda);
    TimeOfDay? _uraOdhoda = TimeOfDay.fromDateTime(zaposleni.uraOdhoda);
    Future<void> _izberiDatum(BuildContext context) async {
      final izbran = await showDatePicker(
        context: context,
        initialDate: _izbranDatum ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (izbran != null) {
        setState(() {
          _izbranDatum = izbran;
        });
      }
    }

    Future<void> _izberiUroPrihoda(BuildContext context, setState) async {
      final izbranaUra = await showTimePicker(
        context: context,
        initialTime: _uraPrihoda ?? TimeOfDay.now(),
      );
      if (izbranaUra != null) {
        setState(() {
          _uraPrihoda = izbranaUra;
        });
      }
    }
    Future<void> _izberiUroOdhoda(BuildContext context, setState) async {
      final izbranaUra = await showTimePicker(
        context: context,
        initialTime: _uraOdhoda ?? TimeOfDay.now(),
      );
      if (izbranaUra != null) {
        setState(() {
          _uraOdhoda = izbranaUra;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Uredi zaposlenega'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _imeKontroler,
                    decoration: const InputDecoration(labelText: 'Ime'),
                  ),
                  TextFormField(
                    controller: _priimekKontroler,
                    decoration: const InputDecoration(labelText: 'Priimek'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _izbranoDelovnoMesto,
                    decoration: const InputDecoration(labelText: 'Delovno mesto'),
                    items: ['Programer', 'Vodja projekta', 'Administrator', 'Prodajalec'].map((mesto) {
                      return DropdownMenuItem(
                        value: mesto,
                        child: Text(mesto),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _izbranoDelovnoMesto = value!;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(_izbranDatum == null
                        ? 'Izberi datum rojstva'
                        : 'Datum rojstva: ${_izbranDatum!.toLocal()}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _izberiDatum(context),
                    ),
                  ),
                  ListTile(
                    title: Text(_uraPrihoda == null
                        ? 'Izberi uro prihoda'
                        : 'Ura prihoda: ${_uraPrihoda!.format(context)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _izberiUroPrihoda(context, setState),
                    ),
                  ),
                  ListTile(
                    title: Text(_uraOdhoda == null
                        ? 'Izberi uro odhoda'
                        : 'Ura odhoda: ${_uraOdhoda!.format(context)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _izberiUroOdhoda(context, setState),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Prekliči'),
            ),
            TextButton(
              onPressed: () {
                // Shrani spremembe v Hive
                final updatedZaposleni = Zaposleni(
                  ime: _imeKontroler.text,
                  priimek: _priimekKontroler.text,
                  delovnoMesto: _izbranoDelovnoMesto,
                  datumRojstva: _izbranDatum!,
                  uraPrihoda: DateTime(
                    _izbranDatum!.year,
                    _izbranDatum!.month,
                    _izbranDatum!.day,
                    _uraPrihoda!.hour,
                    _uraPrihoda!.minute,
                  ),
                  uraOdhoda: DateTime(
                    _izbranDatum!.year,
                    _izbranDatum!.month,
                    _izbranDatum!.day,
                    _uraOdhoda!.hour,
                    _uraOdhoda!.minute,
                  ),
                );

                Hive.box<Zaposleni>('zaposleniBox').putAt(index, updatedZaposleni);
                Navigator.pop(context); // Zapri dialog po shranitvi
              },
              child: const Text('Shrani'),
            ),
          ],
        );
      },
    );
  }
}
