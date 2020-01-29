import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService{
  Firestore _firestore = Firestore.instance;

  void createBrand(String name){
    var id = Uuid();
    String brandId = id.v1();

    _firestore.collection('brands').document(brandId).setData({'brand': name});
  }
  Future<List<DocumentSnapshot>> getallBrand() async {
    List<DocumentSnapshot> documentSnapshot;
    QuerySnapshot querytSnapshot =
    await Firestore.instance.collection("brands").getDocuments();
    documentSnapshot = querytSnapshot.documents;
    return documentSnapshot;
  }
  void deleteBrands(List<String> brandsid)async{
    for(String id in brandsid){    await Firestore.instance.collection("brands").document(id).delete();
    }

  }
  Future<String > getbrandID(String brandname)async{
    if(brandname=="All"){
      return "All";    }
    else{
      String id="";
      QuerySnapshot querytSnapshot = await _firestore.collection('brands').where("brand",isEqualTo:brandname ).getDocuments();
      DocumentSnapshot snapshot=querytSnapshot.documents[0];
      id=snapshot.documentID;
      return id;
    }

  }
  Future<String > getbrand(String brandID)async{
    String brand="";
    DocumentSnapshot snapshot = await _firestore.collection('brands').document(brandID).get();
    brand=snapshot["brand"];
    return brand;
  }
}