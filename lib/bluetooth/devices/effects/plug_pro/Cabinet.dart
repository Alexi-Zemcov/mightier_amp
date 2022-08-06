// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'dart:core';

import '../plug_air/Cabinet.dart';

class V1960Pro extends Cabinet {
  @override
  bool get isSeparator => true;
  @override
  String get category => "Electric IR";
  @override
  final cabName = "V1960";
  static int get cabIndex => 0;
  @override
  int get nuxIndex => cabIndex;
}

class A212Pro extends Cabinet {
  @override
  final cabName = "A212"; //Sunn A212???
  static int get cabIndex => 1;
  @override
  int get nuxIndex => cabIndex;
}

class BS410Pro extends Cabinet {
  @override
  final cabName = "BS410";
  static int get cabIndex => 2;
  @override
  int get nuxIndex => cabIndex;
}

class DR112Pro extends Cabinet {
  @override
  final cabName = "DR112";
  static int get cabIndex => 3;
  @override
  int get nuxIndex => cabIndex;
}

class GB412Pro extends Cabinet {
  @override
  final cabName = "GB412";
  static int get cabIndex => 4;
  @override
  int get nuxIndex => cabIndex;
}

class JZ120IRPro extends Cabinet {
  @override
  final cabName = "JZ120";
  static int get cabIndex => 5;
  @override
  int get nuxIndex => cabIndex;
}

class TR212Pro extends Cabinet {
  @override
  final cabName = "TR212";
  @override
  int get nuxIndex => cabIndex;
  static int get cabIndex => 6;
}

class V412Pro extends Cabinet {
  @override
  final cabName = "V412";
  static int get cabIndex => 7;
  @override
  int get nuxIndex => cabIndex;
}

class AGLDB810Pro extends Cabinet {
  @override
  bool get isSeparator => true;

  @override
  String get category => "Bass IR";
  @override
  final cabName = "AGL DB810";
  static int get cabIndex => 8;
  @override
  int get nuxIndex => cabIndex;
}

class AMPSV810Pro extends Cabinet {
  @override
  final cabName = "AMP SV810";
  static int get cabIndex => 9;
  @override
  int get nuxIndex => cabIndex;
}

class MKB410Pro extends Cabinet {
  @override
  final cabName = "MKB 410";
  static int get cabIndex => 10;
  @override
  int get nuxIndex => cabIndex;
}

class TRC410Pro extends Cabinet {
  @override
  final cabName = "TRC 410";
  static int get cabIndex => 11;
  @override
  int get nuxIndex => cabIndex;
}

class GHBirdPro extends Cabinet {
  @override
  bool get isSeparator => true;

  @override
  String get category => "Acoustic IR";
  @override
  final cabName = "G HBird EG Magnetic";
  static int get cabIndex => 12;
  @override
  int get nuxIndex => cabIndex;
}

class GJ15Pro extends Cabinet {
  @override
  final cabName = "G J15 EG Magnetic";
  static int get cabIndex => 13;
  @override
  int get nuxIndex => cabIndex;
}

class MD45Pro extends Cabinet {
  @override
  final cabName = "M D45 EG Magnetic";
  static int get cabIndex => 14;
  @override
  int get nuxIndex => cabIndex;
}

class GIBJ200Pro extends Cabinet {
  @override
  final cabName = "GIB J200 EG Magnetic";
  static int get cabIndex => 15;
  @override
  int get nuxIndex => cabIndex;
}

class GIBJ45Pro extends Cabinet {
  @override
  final cabName = "GIB J45 EG Magnetic";
  static int get cabIndex => 16;
  @override
  int get nuxIndex => cabIndex;
}

class TL314Pro extends Cabinet {
  @override
  final cabName = "TL 314 EG Magnetic";
  static int get cabIndex => 17;
  @override
  int get nuxIndex => cabIndex;
}

class MHD28Pro extends Cabinet {
  @override
  final cabName = "M HD28 EG Magnetic";
  static int get cabIndex => 18;
  @override
  int get nuxIndex => cabIndex;
}
