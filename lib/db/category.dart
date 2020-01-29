import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


class CategoryService{
  Firestore _firestore = Firestore.instance;

  void createCategory(String name){
  var id = Uuid();
  String categoryId = id.v1();

    _firestore.collection('categories').document(categoryId).setData({'category': name});
  }
  Future<List<DocumentSnapshot>> getallCategories() async {
    List<DocumentSnapshot> documentSnapshot;
        QuerySnapshot querytSnapshot =
        await Firestore.instance.collection("categories").getDocuments();
        documentSnapshot = querytSnapshot.documents;
    return documentSnapshot;
  }
  void deleteCATs(List<String> categoriesid)async{
    for(String id in categoriesid){    await Firestore.instance.collection("categories").document(id).delete();
    }

  }

  Future<String > getCATID(String catname)async{
    if(catname=="All"){
      return "All";
    }
    else{    String id="";
    QuerySnapshot querytSnapshot = await _firestore.collection('categories').where("category",isEqualTo:catname ).getDocuments();
    DocumentSnapshot snapshot=querytSnapshot.documents[0];
    id=snapshot.documentID;
    return id;}

  }  Future<String > getcat(String CATID)async{
    String CAT="";
    DocumentSnapshot snapshot = await _firestore.collection('categories').document(CATID).get();
    CAT=snapshot["category"];
    return CAT;
  }
}