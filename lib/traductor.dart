import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Traductor extends StatefulWidget {
  @override
  _TraductorState createState() => _TraductorState();
}

class _TraductorState extends State<Traductor> {
  List<Map<String, dynamic>> languages = [];
  String idiomaInicio = 'es';
  String idiomaFinal = 'en';
  String textoTraducido = '';

  final String getUrl = 'https://text-translator2.p.rapidapi.com/getLanguages';
  final String postUrl = 'https://text-translator2.p.rapidapi.com/translate';
  final String apiKey = '1bc8398281msh2231918aaa711b5p193962jsnd5d145dc100f';

  @override
  void initState() {
    super.initState();
    fetchLanguages();
  }

  void fetchLanguages() async {
    final response = await http.get(Uri.parse(getUrl), headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      setState(() {
        languages = List<Map<String, dynamic>>.from(json.decode(response.body)['data']['languages']);
      });
    }
  }

  void translateText(String textToTranslate) async {
    final parametrosTraduccion = {
      'source_language': idiomaInicio,
      'target_language': idiomaFinal,
      'text': textToTranslate,
    };

    final response = await http.post(Uri.parse(postUrl), headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'text-translator2.p.rapidapi.com',
      'content-type': 'application/x-www-form-urlencoded',
    }, body: parametrosTraduccion);

    if (response.statusCode == 200) {
      setState(() {
        textoTraducido = json.decode(response.body)['data']['translatedText'];
      });
    }
  }

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('TRADUCTOR', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0), 
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text('Traducir del:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 30),
                DropdownButton<String>(
                  value: idiomaInicio,
                  onChanged: (newValue) {
                    setState(() {
                      idiomaInicio = newValue!;
                    });
                  },
                  items: languages.map<DropdownMenuItem<String>>((Map<String, dynamic> language) {
                    return DropdownMenuItem<String>(
                      value: language['code'],
                      child: Text(language['name']),
                    );
                  }).toList(), 
                ),
              ],
            ),

            Row(
              children: [
                Text('al:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 30),
                DropdownButton<String>(
                  value: idiomaFinal,
                  onChanged: (newValue) {
                    setState(() {
                      idiomaFinal = newValue!;
                    });
                  },
                  items: languages.map<DropdownMenuItem<String>>((Map<String, dynamic> language) {
                    return DropdownMenuItem<String>(
                      value: language['code'],
                      child: Text(language['name']),
                    );
                  }).toList(),
                ),
              ],
            ),

            SizedBox(height: 30),
            TextField(
              controller: textEditingController,  
              decoration: InputDecoration(labelText: 'Ingresa el texto'), 
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                translateText(textEditingController.text);
              },
              child: Text('Traducir'),
            ),
            SizedBox(height: 20),
            Text('TRADUCCION:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
            SizedBox(height: 10),
            Text(textoTraducido),
          ],
        ),
      ),
    );
  }
}