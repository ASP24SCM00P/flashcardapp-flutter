import 'package:flutter/material.dart';
import 'views/decklist.dart';
import 'package:sqflite/sqflite.dart';


void main() async {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DeckList(),
  ));
}
