import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_admin/db/brand.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'UpdateBrand.dart';
import 'AddBrand.dart';


class AllBrands extends StatefulWidget {
  @override
  _AllBrandsState createState() => _AllBrandsState();
}

class _AllBrandsState extends State<AllBrands> {
  Color iconcolor = Colors.blueGrey;

  List<String> selectedbrands=[];

  bool allselected=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text("All Brands", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: iconcolor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[

          IconButton(
              icon: Icon(
                Icons.delete,
                color: iconcolor,
              ),
              onPressed: () {_deletebrands(selectedbrands);}),

        ],
      ),
      body:FutureBuilder<List<DocumentSnapshot>>(
        future: BrandService().getallBrand(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
                itemBuilder: (context,index)=>InkWell(

                  child: Card(
                    child: GridTile(
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Checkbox(value:selectedbrands.contains(snapshot.data[index].documentID), onChanged:(val){changcheck(val,snapshot.data[index].documentID,snapshot);}),
                          IconButton(icon: Icon(Icons.edit), onPressed: ()async{
                            await _dialogCall(context,"update",snapshot.data[index]);})
                        ],
                      ),
                      child:  Image.network(snapshot.data[index]["imgurl"]),

                      footer: Container(height: 50,
                          color: Colors.black54,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(child: Text(snapshot.data[index]["brand"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                                ),
                              ),
                            ],
                          )),

                    ),
                  ) ,
                ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error    " + snapshot.error.toString()),
            );
          }

          return Center(child: Text("Loading ......."));
        },
      )
      ,
    );
  }
  void changcheck(bool val, String Brand_ID,AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    if (val) {
      setState(() {
        selectedbrands.add(Brand_ID);
      });
    } else {
      setState(() {
        selectedbrands.remove(Brand_ID);
      });
    }
    if(snapshot.data.length!=selectedbrands.length){
      setState(() {
        allselected=false;
      });
    }
    else{
      allselected=true;
    }
  }

  void _deletebrands(List<String> selectedbrands) {
    if(selectedbrands.isNotEmpty){
      setState(() {
        BrandService().deleteBrands(selectedbrands);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AllBrands()));

      });
    }
    else{
      Fluttertoast.showToast(msg: "Select at least one brand");
    }
  }
  Future<void> _dialogCall(BuildContext context,String type, DocumentSnapshot _snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          if(type=="update"){
            return UpdateBrandDialog(_snapshot);
          }
          return BrandDialog();

        });
  }
}
