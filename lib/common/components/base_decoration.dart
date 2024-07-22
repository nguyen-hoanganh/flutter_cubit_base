import 'package:flutter/material.dart';

///Mục đích tạo ra file này để tận dụng những thứ có sẵn để các pj được tạo nhanh hơn
class BaseDecorations {
  /// Shadow-4
  ///rgba(255, 255, 255, 1.0) -> Hex(#ffffff)
  ///shadow [xOffset] : 0.0, [yOffset] : 4.0, [blurRadius] : 4.0, [spreadRadius] : 0.0
  static BoxDecoration shadow4 = BoxDecoration(
    color: const Color.fromRGBO(255, 255, 255, 1.0),
    borderRadius: BorderRadius.circular(4),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(10, 40, 81, 0.1),
        offset: Offset(0.0, 4.0), //Offset
        blurRadius: 4.0,
        spreadRadius: 0.0,
      ), //BoxShadow
      //BoxShadow
    ],
  );

  /// Shadow-8
  ///rgba(255, 255, 255, 1.0) -> Hex(#ffffff)
  ///shadow [xOffset] : 0.0, [yOffset] : 4.0, [blurRadius] : 8.0, [spreadRadius] : 0.0
  static BoxDecoration shadow8 = BoxDecoration(
    color: const Color.fromRGBO(255, 255, 255, 1.0),
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(10, 40, 81, 0.1),
        offset: Offset(0.0, 4.0), //Offset
        blurRadius: 8.0,
        spreadRadius: 0.0,
      ), //BoxShadow
      //BoxShadow
    ],
  );

  /// Shadow-4-Revert
  ///rgba(255, 255, 255, 1.0) -> Hex(#ffffff)
  ///shadow [xOffset] : 0.0, [yOffset] : -2.0, [blurRadius] : 4.0, [spreadRadius] : 0.0
  static BoxDecoration shadow4Revert = BoxDecoration(
    color: const Color.fromRGBO(255, 255, 255, 1.0),
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(10, 40, 81, 0.1),
        offset: Offset(0.0, 4.0), //Offset
        blurRadius: 8.0,
        spreadRadius: 0.0,
      ), //BoxShadow
      //BoxShadow
    ],
  );

  ///Scrim
  static BoxDecoration scrim = BoxDecoration(
    color: const Color.fromRGBO(10, 40, 81, 0.3),
    borderRadius: BorderRadius.circular(8),
  );

  ///Đây là phần hoàng anh test xem lần đầu làm có đúng không --> Không đúng cũng phải đúng!
  static BoxDecoration testHa = BoxDecoration(
    image: const DecorationImage(
      image: NetworkImage(
        'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190710102234/download3.png',
      ),
      fit: BoxFit.cover,
    ), //DecorationImage
    border: Border.all(
      color: Colors.green,
      width: 8,
    ), //Border.all
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        offset: Offset(
          75.0,
          75.0,
        ), //Offset
        blurRadius: 10.0,
        spreadRadius: 2.0,
      ), //BoxShadow
      BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ), //BoxShadow
    ],
  );
}
