import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;
  List<CartProduct> produtos = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItens();
    }
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    produtos.add(cartProduct);
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.id = doc.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.id).delete();
    produtos.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.qtd --;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.id).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.qtd ++;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.id).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItens() async {
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    produtos = query.documents.map((doc)=> CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductPrice(){
    double price = 0.0;
    for(CartProduct c in produtos){
      if(c.productData != null){
        price += c.qtd * c.productData.price;
      }
    }
    return price;
  }

  double getShipPrice(){
    return 9.99;
  }

  double getDiscount(){
    return getProductPrice() * discountPercentage/100;
  }

  void updatePrices(){
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if(produtos.length == 0){
      return null;
    }

    isLoading = true;
    notifyListeners();
    double productsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    
    DocumentReference df = await Firestore.instance.collection("orders").add(
        {
          "clienteId": user.firebaseUser.uid,
          "products": produtos.map((cartProducts)=>cartProducts.toMap()).toList(),
          "shipPrice": shipPrice,
          "productsPrice": productsPrice,
          "discount": discount,
          "totalPrice": (productsPrice + shipPrice - discount),
          "status": 1
        });
    
    await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders").document(df.documentID).setData(
        {
          "orderId": df.documentID
        });

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    produtos.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return df.documentID;
  }


}