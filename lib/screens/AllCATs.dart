import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_admin/db/category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'UpdateCAT.dart';


class AllCATs extends StatefulWidget {
  @override
  _AllCATsState createState() => _AllCATsState();
}

class _AllCATsState extends State<AllCATs> {
  Color iconcolor = Colors.blueGrey;

  List<String> selectedCATs=[];

  bool allselected=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text("All Categories", style: TextStyle(color: Colors.blueGrey)),
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
              onPressed: () {_deleteCATs(selectedCATs);}),

        ],
      ),
      body:FutureBuilder<List<DocumentSnapshot>>(
        future: CategoryService().getallCategories(),
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
                          Checkbox(value:selectedCATs.contains(snapshot.data[index].documentID), onChanged:(val){changcheck(val,snapshot.data[index].documentID,snapshot);}),
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
                              padding: const EdgeInsets.fromLTRB(15.0,0,15.0,0),
                              child: Center(child: Text(snapshot.data[index]["category"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
  void changcheck(bool val, String CAT_ID,AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    if (val) {
      setState(() {
        selectedCATs.add(CAT_ID);
      });
    } else {
      setState(() {
        selectedCATs.remove(CAT_ID);
      });
    }
    if(snapshot.data.length!=selectedCATs.length){
      setState(() {
        allselected=false;
      });
    }
    else{
      allselected=true;
    }
  }

  void _deleteCATs(List<String> selectedCATs) {
    if(selectedCATs.isNotEmpty){
      setState(() {
        CategoryService().deleteCATs(selectedCATs);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AllCATs()));

      });
    }
    else{
      Fluttertoast.showToast(msg: "Select at least one category");
    }
  }
  Future<void> _dialogCall(BuildContext context,String type, DocumentSnapshot _snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
            return UpdateCATDialog(_snapshot);

        });
  }
}
