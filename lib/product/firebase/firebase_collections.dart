import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseCollections {
  user,
  category,
  product,
  alergen,
  ;

  CollectionReference get reference => FirebaseFirestore.instance.collection(name);
}
