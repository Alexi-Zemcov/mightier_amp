// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'dart:core';

import 'package:mighty_plug_manager/bluetooth/nux_device_control.dart';
import 'package:mighty_plug_manager/platform/simpleSharedPrefs.dart';

import '../../NuxConstants.dart';
import '../Processor.dart';

//cabinets are 3 categories - electric, acoustic and bass
abstract class Cabinet extends Processor {
  @override
  int get nuxDataLength => 1;

  @override
  int get midiCCEnableValue => MidiCCValues.bCC_CabEnable;
  @override
  int get midiCCSelectionValue => MidiCCValues.bCC_CabMode;

  String get cabName;
  @override
  String get name {
    var _name = SharedPrefs().getCustomCabinetName(
        NuxDeviceControl.instance().device.productStringId, nuxIndex);
    return _name ?? cabName;
  }

  Parameter value = Parameter(
      devicePresetIndex: PresetDataIndexPlugAir.cabgain,
      name: "Level",
      handle: "level",
      value: 0,
      valueType: ValueType.db,
      midiCC: MidiCCValues.bCC_Routing);

  @override
  List<Parameter> get parameters => [value];
}

class V1960 extends Cabinet {
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

class A212 extends Cabinet {
  @override
  final cabName = "A212"; //Sunn A212???
  static int get cabIndex => 1;
  @override
  int get nuxIndex => cabIndex;
}

class BS410 extends Cabinet {
  @override
  final cabName = "BS410";
  static int get cabIndex => 2;
  @override
  int get nuxIndex => cabIndex;
}

class DR112 extends Cabinet {
  @override
  final cabName = "DR112";
  static int get cabIndex => 3;
  @override
  int get nuxIndex => cabIndex;
}

class GB412 extends Cabinet {
  @override
  final cabName = "GB412";
  static int get cabIndex => 4;
  @override
  int get nuxIndex => cabIndex;
}

class JZ120IR extends Cabinet {
  @override
  final cabName = "JZ120";
  static int get cabIndex => 5;
  @override
  int get nuxIndex => cabIndex;
}

class TR212 extends Cabinet {
  @override
  final cabName = "TR212";
  @override
  int get nuxIndex => cabIndex;
  static int get cabIndex => 6;
}

class V412 extends Cabinet {
  @override
  final cabName = "V412";
  static int get cabIndex => 7;
  @override
  int get nuxIndex => cabIndex;
}

class AGLDB810 extends Cabinet {
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

class AMPSV810 extends Cabinet {
  @override
  final cabName = "AMP SV810";
  static int get cabIndex => 9;
  @override
  int get nuxIndex => cabIndex;
}

class MKB410 extends Cabinet {
  @override
  final cabName = "MKB 410";
  static int get cabIndex => 10;
  @override
  int get nuxIndex => cabIndex;
}

class TRC410 extends Cabinet {
  @override
  final cabName = "TRC 410";
  static int get cabIndex => 11;
  @override
  int get nuxIndex => cabIndex;
}

class GHBird extends Cabinet {
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

class GJ15 extends Cabinet {
  @override
  final cabName = "G J15 EG Magnetic";
  static int get cabIndex => 13;
  @override
  int get nuxIndex => cabIndex;
}

class MD45 extends Cabinet {
  @override
  final cabName = "M D45 EG Magnetic";
  static int get cabIndex => 14;
  @override
  int get nuxIndex => cabIndex;
}

class GIBJ200 extends Cabinet {
  @override
  final cabName = "GIB J200 EG Magnetic";
  static int get cabIndex => 15;
  @override
  int get nuxIndex => cabIndex;
}

class GIBJ45 extends Cabinet {
  @override
  final cabName = "GIB J45 EG Magnetic";
  static int get cabIndex => 16;
  @override
  int get nuxIndex => cabIndex;
}

class TL314 extends Cabinet {
  @override
  final cabName = "TL 314 EG Magnetic";
  static int get cabIndex => 17;
  @override
  int get nuxIndex => cabIndex;
}

class MHD28 extends Cabinet {
  @override
  final cabName = "M HD28 EG Magnetic";
  static int get cabIndex => 18;
  @override
  int get nuxIndex => cabIndex;
}
