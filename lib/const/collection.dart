import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;

CollectionReference<Map<String, dynamic>> userCollection =
    FirebaseFirestore.instance.collection('user');
CollectionReference<Map<String, dynamic>> adminCollection =
    FirebaseFirestore.instance.collection('admin');
