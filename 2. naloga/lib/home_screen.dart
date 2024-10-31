import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'zaposleni_model.dart';
import 'display_screen.dart';

class ZaslonZaVnosPodatkov extends StatefulWidget {
  const ZaslonZaVnosPodatkov({super.key});

  @override
  State<ZaslonZaVnosPodatkov> createState() => _ZaslonZaVnosPodatkovState();
}

class _ZaslonZaVnosPodatkovState extends State<ZaslonZaVnosPodatkov> {
  final _obrazecKljuc = GlobalKey<FormState>();
  final _imeKontroler = TextEditingController();
  final _priimekKontroler = TextEditingController();
  final List<String> _delovnaMesta = [
    'Programer',
    'Vodja projekta',
    'Administrator',
    'Prodajalec'
  ];
  String _izbranoDelovnoMesto = 'Programer';
  DateTime? _izbranDatum;
  DateTime? _uraPrihoda; // Changed to DateTime
  DateTime? _uraOdhoda; // Changed to DateTime

  // Funkcija za prikaz DatePicker
  Future<void> _izberiDatum(BuildContext context) async {
    final izbran = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (izbran != null && izbran != _izbranDatum) {
      setState(() {
        _izbranDatum = izbran;
      });
    }
  }

  // Funkcija za prikaz TimePicker in shranjevanje v DateTime
  Future<void> _izberiUroPrihoda(BuildContext context) async {
    final izbranaUra = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (izbranaUra != null) {
      final now = DateTime.now();
      setState(() {
        _uraPrihoda = DateTime(now.year, now.month, now.day, izbranaUra.hour, izbranaUra.minute);
      });
    }
  }

  Future<void> _izberiUroOdhoda(BuildContext context) async {
    final izbranaUra = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (izbranaUra != null) {
      final now = DateTime.now();
      setState(() {
        _uraOdhoda = DateTime(now.year, now.month, now.day, izbranaUra.hour, izbranaUra.minute);
      });
    }
  }

  Future<void> _shraniZaposlenega() async {
    if (_obrazecKljuc.currentState!.validate() &&
        _izbranDatum != null &&
        _uraPrihoda != null &&
        _uraOdhoda != null) {
      final zaposleniBox = Hive.box<Zaposleni>('zaposleniBox');

      final noviZaposleni = Zaposleni(
        ime: _imeKontroler.text,
        priimek: _priimekKontroler.text,
        delovnoMesto: _izbranoDelovnoMesto,
        datumRojstva: _izbranDatum!,
        uraPrihoda: _uraPrihoda!,
        uraOdhoda: _uraOdhoda!,
      );

      // Shranimo v Hive
      await zaposleniBox.add(noviZaposleni);

      // Pokažemo Toast sporocilo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zaposleni uspešno dodan!')),
      );

      // Navigiraj na seznam zaposlenih
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ZaslonZaPrikazZaposlenih()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izpolnite vsa polja!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vnos zaposlenih'),
      ),
      body: Form(
        key: _obrazecKljuc,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _imeKontroler,
                decoration: const InputDecoration(labelText: 'Ime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prosimo, vnesite ime';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priimekKontroler,
                decoration: const InputDecoration(labelText: 'Priimek'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prosimo, vnesite priimek';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _izbranoDelovnoMesto,
                decoration: const InputDecoration(labelText: 'Delovno mesto'),
                items: _delovnaMesta.map((mesto) {
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
                    : 'Ura prihoda: ${_uraPrihoda!.toLocal()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _izberiUroPrihoda(context),
                ),
              ),
              ListTile(
                title: Text(_uraOdhoda == null
                    ? 'Izberi uro odhoda'
                    : 'Ura odhoda: ${_uraOdhoda!.toLocal()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _izberiUroOdhoda(context),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _shraniZaposlenega,
                child: const Text('Shrani zaposlenega'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
