import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {
  String id;
  String categoria;
  String produtoId;
  int qtd;
  String size;
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    categoria = document.data["categoria"];
    produtoId = document.data["produtoId"];
    qtd = document.data["qtd"];
    size = document.data["size"];
  }

  Map<String, dynamic> toMap(){
    return {
      "catergoria": categoria,
      "produtoId": produtoId,
      "qtd": qtd,
      "size": size,
      "product": productData.toResumeMap()
    };
  }
}