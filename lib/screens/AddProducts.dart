import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_admin/db/ProductDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import'package:shop_app_admin/db/category.dart';
import'package:shop_app_admin/db/brand.dart';
import 'AddColors.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _productcontroler = new TextEditingController();
  TextEditingController _desccontroler = new TextEditingController();
  TextEditingController _qtycontroller = new TextEditingController();
  TextEditingController _pricecontroller = new TextEditingController();
  CategoryService _categoryService=new CategoryService();
  BrandService _brandService=new BrandService();
  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  String selectedbrand;
  String brandId;
  String CATId;
  String selectedcat;
  List map_chec = ["XS", "S", "L", "XL", "XXL"]; //<Map<String,dynamic>[,];
  bool checkval = false;
  List<String> selectedsize = [];
  List<String> imgsurl = [];
  List<String> selectedColors = [];
  File image1, image2, image3;
  bool loading = false;
  String productname="";
  String description="";
  String quantity="";
  String price="";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add product",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0.4,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blueGrey,
            ),
            onPressed: Navigator.of(context).pop),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formkey,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _Custombutton(1, image1),
                      _Custombutton(2, image2),
                      _Custombutton(3, image3),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "The name must be less than 10 letters",
                        labelText: "Product name",

                        labelStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      controller: _productcontroler,
                      validator: (val) {
                        if (val.isEmpty || val.length > 10) {
                          return "Product name must be less than 10 letters";
                        }
                        else{setState(() {
                          productname=val;

                        });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "description",
                        hintText: "provide breif details about the ptoduct",
                        labelStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      maxLines: 2,
                      maxLength: 100,
                      controller: _desccontroler,
                      validator: (val) {
                        if (val.isEmpty || val.length > 100) {
                          return "description  must have data";
                        }
                        else{setState(() {
                          description=val;

                        });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FutureBuilder<List<String>>(
                      future: _getelements("categories", "category"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton<String>(
                            value: selectedcat,
                            isExpanded: true,
                            isDense: true,
                            onChanged: changecat,
                            hint: Text("Select Category"),
                            items: snapshot.data
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Text("Loading  . . . ");
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FutureBuilder<List<String>>(
                      future: _getelements("brands", "brand"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton<String>(
                            value: selectedbrand,
                            isExpanded: true,
                            isDense: true,
                            onChanged: changebrand,
                            hint: Text("Select Brand"),
                            items: snapshot.data
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Text("Loading  . . . ");
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                labelText: "Quantity",
                                labelStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              controller: _qtycontroller,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter valid quntity";
                                }
                                else{setState(() {
                                  quantity=val;
                                });}
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixText: "L.E",
                                labelText: "Pice",
                                labelStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              controller: _pricecontroller,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Enter Valid price";
                                }
                                else{
                                  setState(() {
                                    price=val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 25, 10, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Available sizes",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Container(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(map_chec[index]),
                                    Checkbox(
                                        value: selectedsize
                                            .contains(map_chec[index]),
                                        onChanged: (v) {
                                          changcheck(v, map_chec[index]);
                                        })
                                  ],
                                ),
                              );
                            },
                            itemCount: map_chec.length,
                          ),
                        ),

                      ],
                    ),
                  ),
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Column(children: <Widget>[
            Container(
              height: 60,
              child: selectedColors.isEmpty
                  ?  Text("No Colors picked yet",style: TextStyle(color: Colors.red),)
                  : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedColors.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          selectedColors.removeAt(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
                            color: Color((int.parse(selectedColors[index]))),
                          ),
                          height: 30,
                          width: 40,

                        ),
                      ),
                    );
                  }),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(90.0,0,90.0,0),
                    child: RaisedButton(
                      onPressed: () async {
                        await _dialogCall(context);
                      },
                      /*uploadimages*/ child: Text("pick color"),
                    ),
                  ),
                ),
              ],
            )

          ],),
        ),

        Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: uploadimages, child: Text("Add product"),
                            color: Colors.black45,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
    );
  }

  Widget _Custombutton(int imagnum, File image) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: OutlineButton(
            onPressed: () {
              (_pickimage(imagnum));
            },
            child: image == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
                    child: Icon(Icons.add),
                  )
                : Container(
                    height: 120,
                    child: Image.file(
                      image,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  )),
      ),
    );
  }

  Future<List<String>> _getelements(
      String col_name, String snap_elements) async {
    QuerySnapshot querytSnapshot =
        await Firestore.instance.collection(col_name).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querytSnapshot.documents;
    List<String> list = [];
    for (int i = 0; i < documentSnapshot.length; i++) {
      list.add(documentSnapshot[i][snap_elements]);
    }
    return list;
  }

  void changecat(String value) async{
    setState(() {
      selectedcat = value;
    });
    CATId=await _categoryService.getCATID(selectedcat);

  }

  void changebrand(String value) async{
    setState(() {
      selectedbrand = value;
    });
    brandId=await _brandService.getbrandID(selectedbrand);
  }

  void changcheck(bool val, String size) {
    if (val) {
      setState(() {
        selectedsize.add(size);
      });
    } else {
      setState(() {
        selectedsize.remove(size);
      });
    }
  }

  _pickimage(int imgnum) async {
    File tempimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    switch (imgnum) {
      case 1:
        setState(() {
          image1 = tempimage;
        });
        break;
      case 2:
        setState(() {
          image2 = tempimage;
        });
        break;
      case 3:
        setState(() {
          image3 = tempimage;
        });
        break;
    }
  }

  void uploadimages() {
    if (_formkey.currentState.validate() &&
        selectedsize.isNotEmpty &&
        CATId!=null&&
        brandId!=null&&
        productname.isNotEmpty&&
        description.isNotEmpty&&
        price.isNotEmpty&&
        quantity.isNotEmpty&&
        selectedColors.isNotEmpty) {
      if (image1 != null && image3 != null && image2 != null) {
        setState(() {
          loading = true;
        });
        ProductDatabase()
            .uploadimages(image1, image2, image3, productname)
            .then((list) {
          setState(() {
            imgsurl = list;
          });
          if (imgsurl.isNotEmpty) {
            ProductDatabase().uploadProduct(
                productname,
                description,
                CATId,
                brandId,
                quantity,
               price,
                selectedsize,
                imgsurl,
            selectedColors);
            setState(() {
              loading = false;
            });
            Fluttertoast.showToast(msg: "product added");
          } else {
            Fluttertoast.showToast(msg: "something wrong had happened ");
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "pick the images of the pictures");
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }
  }

  Future<void> _dialogCall(BuildContext context) async {
      List<String> returnedcolors = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ColorDialog();
          });
      if(returnedcolors!=null){
        setState(() {
          for(int i =0;i<returnedcolors.length;i++){
            selectedColors.add(returnedcolors[i]);

          }
        });
      }

  }
}
