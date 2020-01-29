import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_admin/db/ordersDatabase.dart';

import 'OrderDetails.dart';

class OrdersPage extends StatefulWidget {
  static String _uid;
  OrdersPage({String uid = ""}) {
    _uid = uid;
  }
  @override
  _OrdersPageState createState() => _OrdersPageState(_uid);
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  String _uid;
  _OrdersPageState(String uid) {
    this._uid = uid;
  }
  List<String> selectedproducts = [];
  OrdersDatabase _ordersDatabase = new OrdersDatabase();
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              isScrollable: true,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Ordered"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Proccess"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Delivered"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Canceled"),
                )
              ],
              controller: _tabController),
          title: Text("My Orders"),
        ),
        body: TabBarView(controller: _tabController, children: [
          tabview("ordered"),
          tabview("proccess"),
          tabview("delivered"),
          tabview("canceled"),
        ]));
  }

  void onorderitemtap(DocumentSnapshot _documentSnapshot) {
    if (selectedproducts.isNotEmpty) {
      if (selectedproducts.contains(_documentSnapshot.documentID)) {
        setState(() {
          selectedproducts.remove(_documentSnapshot.documentID);
        });
      } else {
        setState(() {
          selectedproducts.add(_documentSnapshot.documentID);
        });
      }
    }
  }

  Widget tabview(String orderCase) {
    return Container(
        child: FutureBuilder<List<DocumentSnapshot>>(
            future: _ordersDatabase.getorders(orderCase),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        switch (orderCase) {
                          case "ordered":
                            {
                              return listitem(
                                  orderCase, snapshot.data[index], index);
                            }
                            break;
                          case "proccess":
                            {
                              return listitem(
                                  orderCase, snapshot.data[index], index);
                            }
                            break;
                          case "delivered":
                            {
                              return listitem(
                                  orderCase, snapshot.data[index], index);
                            }
                            break;
                          case "canceled":
                            {
                              return listitem(
                                  orderCase, snapshot.data[index], index);
                            }
                            break;
                          default:
                            {}
                            return Center(
                                child: Text('No $orderCase products for now'));
                        }
                      });
                } else {
                  return Center(child: Text('No $orderCase products for now'));
                }
              }

              return Center(child: CircularProgressIndicator());
            }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget listitem(String itemType, DocumentSnapshot snapshot, int index) {
    return Card(
        child: ListTile(
      onTap: () {
        onorderitemtap(snapshot);
      },
      selected: selectedproducts.contains(snapshot.documentID),
      onLongPress: () {
        setState(() {
          selectedproducts.add(snapshot.documentID);
        });
      },
      leading: Image.network(snapshot["images url"][0]),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              snapshot["name"],
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          itemType!="delivered"&&itemType!="canceled"?  PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _onitemselected(snapshot.documentID, value);
                });
              },
              itemBuilder: (_) => <PopupMenuItem<String>>[
                itemType == "ordered"
                    ? new PopupMenuItem<String>(
                        child: new Text('Ship'),
                        value: "ship",
                      )
                    : itemType == "proccess"
                        ? new PopupMenuItem<String>(
                            child: new Text('Delivered'), value: "deliver")
                        : null,
                itemType == "ordered"
                    ? new PopupMenuItem<String>(
                        child: new Text('Reject'),
                        value: "reject",
                      )
                    :null,
              ],
            ):SizedBox(),
          ],
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Text("Ordered  :"),
                Text(
                  "  ${snapshot["ordered"]}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          itemType == "proccess"
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: snapshot["shipped"] == null
                      ? Row(
                          children: <Widget>[
                            Text("Shipped  :"),
                            Text(
                              "  ${snapshot["shipped"]}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Text("Rejected  :"),
                            Text(
                              "  ${snapshot["rejected"]}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                )
              : itemType == "delivered"
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Shipped  :"),
                              Text(
                                "  ${snapshot["shipped"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Delivered  :"),
                              Text(
                                "  ${snapshot["delivered"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : itemType == "canceled"
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Canceled  :"),
                              Text(
                                "  ${snapshot["canceled"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Text("Price  :"),
                Text(
                  "  ${snapshot["price"]}  L.E",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Text("Quantity  :"),
                Text(
                  "  ${snapshot["quantuty"]}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Total  :"),
                  Text(
                    "  ${double.parse(snapshot["quantuty"].toString()) * double.parse(snapshot["price"])}",
                    style: TextStyle(
                        color: Colors.red[700], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetails(snapshot)));
                },
                textColor: Colors.red,
                shape: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                child: Text("Details"),
              )
            ],
          ),
        ],
      ),
    ));
  }

  _onitemselected(String id, String request) async {
    switch (request) {
      case "ship":
        {
          await _ordersDatabase.ship_product(id);
        }
        break;
      case "reject":
        {
          await _ordersDatabase.reject_product(id);
        }
        break;
      case "deliver":
        {
          await _ordersDatabase.delever_product(id);
        }
    }
  }
}
