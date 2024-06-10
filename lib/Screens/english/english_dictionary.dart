import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speak_app/utils/string_extensions.dart';

class DictionaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diccionario', style: Theme.of(context).textTheme.headlineSmall),
        leading: Icon(Icons.book, color: Theme.of(context).primaryColor),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('diccionario').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No hay palabras disponibles'),
            );
          }
          // Agrupar las palabras por categoría
          Map<String, List<Map<String, String>>> groupedWords = {};
          snapshot.data!.docs.forEach((doc) {
            String category = doc['category'];
            String word = doc['word'];
            String translation = doc['translation'];

            if (!groupedWords.containsKey(category)) {
              groupedWords[category] = [];
            }

            groupedWords[category]!.add({
              'word': word,
              'translation': translation,
            });
          });

          // Construir la lista
          return ListView(
            children: groupedWords.entries.map((entry) {
              return _buildCategoryList(context, entry.key, entry.value);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, String category, List<Map<String, String>> words) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Theme.of(context).canvasColor,
          child: Center(
            child: Text(
              capitalize(category),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: words.length,
          itemBuilder: (context, index) {
            String word = capitalize(words[index]['word']!);
            String translation = capitalize(words[index]['translation']!);
            Color color = index.isOdd ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight;
            return Container(
              color: color,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      word,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      translation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
