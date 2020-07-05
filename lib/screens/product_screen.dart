import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/cart_screen.dart';
import 'package:lojavirtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {

  final ProductData productData;

  ProductScreen(this.productData);

  @override
  _ProductScreenState createState() => _ProductScreenState(productData);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData productData;
  String tam;

  _ProductScreenState(this.productData);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
        centerTitle: true
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: productData.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                    productData.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0
                    ),
                    maxLines: 3
                ),
                Text(
                  "R\$ ${productData.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: primaryColor
                  )
                ),
                SizedBox(height: 16.0),
                Text("Tamanho",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                    )
                ),
                SizedBox(
                    height: 32.0,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5
                        ),
                      children: productData.sizes.map((t) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              tam = t;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color: t == tam ? primaryColor : Colors.grey[500],
                                width: 3.0
                              )
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(t),
                          ),
                        );
                      }).toList(),
                    )
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: tam != null ? (){
                      if(UserModel.of(context).isLoggedIn()){
                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = tam;
                        cartProduct.qtd = 1;
                        cartProduct.produtoId = productData.id;
                        cartProduct.categoria = productData.category;
                        cartProduct.productData = productData;

                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> CartScreen())
                        );

                      }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar no Carrinho" : "Entre para Comprar",
                        style: TextStyle(fontSize: 16.0)),
                    color: primaryColor,
                    textColor: Colors.white,
                  )
                ),
                SizedBox(height: 16.0),
                Text("Descrição",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                    )
                ),
                Text(productData.description, style: TextStyle(fontSize: 16.0))
              ],
            ),
          )
        ],
      ),
    );
  }
}
