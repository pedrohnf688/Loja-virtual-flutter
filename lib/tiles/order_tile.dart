import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection("orders").document(orderId).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }else{
                int status = snapshot.data["status"];

                return Column(
                  children: <Widget>[
                    Text("Código do pedido: ${snapshot.data.documentID}", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.0),
                    Text(_buildProductsText(snapshot.data)),
                    SizedBox(height: 4.0),
                    Text("Status do pedido:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCircle("1", "Preparação", status , 1),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey[500],
                        ),
                        _buildCircle("2", "Transporte", status , 2),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey[500],
                        ),
                        _buildCircle("3", "Entrega", status , 3)
                      ],
                    )
                  ],
                );
              }
            }
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot data) {
    String text = "Descrição:\n";
    for(LinkedHashMap p in data.data["products"]){
      text += "${p["qtd"]} x ${p["product"]} ${p["title"]} (R\$ ${p["product"]} ${p["price"].toStringAsFixed(2)})";
    }
    text += "Total: R\$ ${data.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(String title, String subTitle, int status, int thisStatus){
    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    }else if(status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    }else{
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle)
      ],
    );
  }


}
