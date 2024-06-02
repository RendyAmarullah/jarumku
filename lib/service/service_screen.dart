import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:project_jarum/models/jarum.dart';

class Service {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _jarumCollection =
      _database.collection('jarum');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('images/$fileName');

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(File(imageFile.path));
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<void> addNote(Jarum jarum) async {
    Map<String, dynamic> newjarum = {
      'title': jarum.title,
      'description': jarum.description,
      'image_url': jarum.imageUrl,
      'latitude': jarum.latitude,
      'longitude': jarum.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _jarumCollection.add(newjarum);
  }

  static Future<void> updateNote(Jarum jarum) async {
    Map<String, dynamic> updatedNote = {
      'title': jarum.title,
      'description': jarum.description,
      'image_url': jarum.imageUrl,
      'latitude': jarum.latitude,
      'longitude': jarum.longitude,
      'created_at': jarum.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _jarumCollection.doc(jarum.id).update(updatedNote);
  }

  static Future<void> deleteNote(Jarum jarum) async {
    await _jarumCollection.doc(jarum.id).delete();
  }

  static Future<QuerySnapshot> retrieveNotes() {
    return _jarumCollection.get();
  }

  static Stream<List<Jarum>> getNoteList() {
    return _jarumCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Jarum(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          imageUrl: data['image_url'],
          latitude:
              data['latitude'] != null ? data['latitude'] as double : null,
          longitude:
              data['longitude'] != null ? data['longitude'] as double : null,
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }
}