import 'package:flutter/material.dart';
import 'package:shop_app_admin/db/category.dart';
import 'package:shop_app_admin/db/ordersDatabase.dart';
import 'AddBrand.dart';
import 'AddCAT.dart';
import 'AddProducts.dart';
import 'AllBrand.dart';
import 'AllCATs.dart';
import 'AllProducts.dart';
import 'package:shop_app_admin/db/ProductDatabase.dart';
import 'package:shop_app_admin/db/UsersDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'OrdersPage.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  ProductDatabase _productDatabase = new ProductDatabase();
  UsersDatabase _usersDatabase = new UsersDatabase();
  CategoryService _categoryService = new CategoryService();
  OrdersDatabase _ordersDatabase = new OrdersDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Admin()));
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  FutureBuilder<List<DocumentSnapshot>>(
                      future: _usersDatabase.getusers(),
                      builder: (context, snapshot) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.people_outline),
                                  label: Text("Users")),
                              subtitle: Text(
                                snapshot.hasData
                                    ? "${snapshot.data.length}"
                                    : snapshot.hasError ? "Error" : "0",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              )),
                        );
                      }),
                  FutureBuilder<List<DocumentSnapshot>>(
                      future: _categoryService.getallCategories(),
                      builder: (context, snapshot) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>AllCATs()));},
                                  icon: Icon(Icons.category),
                                  label: Text(
                                    "CATs",
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              subtitle: Text(
                                snapshot.hasData
                                    ? "${snapshot.data.length}"
                                    : snapshot.hasError ? "Error" : "0",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              )),
                        );
                      }),
                  FutureBuilder<List<DocumentSnapshot>>(
                      future: _productDatabase.getallproducts("All", "All"),
                      builder: (context, snapshot) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>AllPruductsPage()));},
                                  icon: Icon(Icons.track_changes),
                                  label: Text("Producs")),
                              subtitle: Text(
                                snapshot.hasData
                                    ? "${snapshot.data.length}"
                                    : snapshot.hasError ? "Error" : "0",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              )),
                        );
                      }),
                  Card(
                    elevation: 5,
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.tag_faces),
                            label: Text("Sold")),
                        subtitle: Text(
                          '13',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                  FutureBuilder<List<DocumentSnapshot>>(
                      future: _ordersDatabase.getorders("all"),
                      builder: (context, snapshot) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OrdersPage()));
                                  },
                                  icon: Icon(Icons.shopping_cart),
                                  label: Text("Orders")),
                              subtitle: Text(
                                snapshot.hasData
                                    ? "${snapshot.data.length}"
                                    : snapshot.hasError ? "Error" : "0",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 60.0),
                              )),
                        );
                      }),
                  Card(
                    elevation: 5,
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.close),
                            label: Text("Return")),
                        subtitle: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AllPruductsPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () async {
                await _dialogCall(context, "cat");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllCATs()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: () async {
                await _dialogCall(context, "brand");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("brand list"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllBrands()));
              },
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  Future<void> _dialogCall(BuildContext context, String type) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (type == "cat") {
            return CatDialog();
          } else if (type == "brand") {
            return BrandDialog();
          } else {
            return SizedBox();
          }
        });
  }
}
