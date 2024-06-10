import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> addWord({
    required String word,
    required String translation,
    required String category,
  }) async {
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('diccionario');

      await collectionReference.add({
        'word': word,
        'translation': translation,
        'category': category,
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Documento agregado a $collectionName en Firestore'),
      //   ),
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error al agregar documento a $collectionName en Firestore: $e'),
      //   ),
    }
  }
  static Future<void> addUser({
  required String username,
  required String email,
}) async {
  try {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');

    await collectionReference.doc(email).set({
      'email': email,
      'image': "",
      'username': username,
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('User added to Firestore'),
    //   ),
    // );
  } catch (e) {
    print('Error adding user to Firestore: $e');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Error adding user to Firestore: $e'),
    //   ),
    // );
  }
}

}
