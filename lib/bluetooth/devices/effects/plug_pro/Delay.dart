// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import '../../NuxConstants.dart';
import '../Processor.dart';

abstract class Delay extends Processor {
  int get nuxDataLength => 3;

  int get midiCCEnableValue => MidiCCValuesPro.Head_iDLY;
  int get midiCCSelectionValue => MidiCCValuesPro.Head_iDLY;
}

class AnalogDelay extends Delay {
  final name = "Analog";

  int get nuxIndex => 0;

  List<Parameter> parameters = [
    Parameter(
        name: "Rate",
        handle: "rate",
        value: 34,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para1,
        midiCC: MidiCCValuesPro.DLY_Para1),
    Parameter(
        name: "Echo",
        handle: "echo",
        value: 45,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para2,
        midiCC: MidiCCValuesPro.DLY_Para2),
    Parameter(
        name: "Intensity",
        handle: "intensity",
        value: 52,
        valueType: ValueType.tempo,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para3,
        midiCC: MidiCCValuesPro.DLY_Para3),
  ];
}

class DigitalDelay extends Delay {
  final name = "Digital Delay";

  int get nuxIndex => 1;
  List<Parameter> parameters = [
    Parameter(
        name: "E.Level",
        handle: "level",
        value: 49,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para1,
        midiCC: MidiCCValuesPro.DLY_Para1),
    Parameter(
        name: "Feedback",
        handle: "feedback",
        value: 68,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para2,
        midiCC: MidiCCValuesPro.DLY_Para2),
    Parameter(
        name: "Time",
        handle: "time",
        value: 48,
        valueType: ValueType.tempo,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para3,
        midiCC: MidiCCValuesPro.DLY_Para3),
  ];
}

class ModDelay extends Delay {
  final name = "Modulation";

  int get nuxIndex => 2;
  List<Parameter> parameters = [
    Parameter(
        name: "Time",
        handle: "time",
        value: 49,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para1,
        midiCC: MidiCCValuesPro.DLY_Para1),
    Parameter(
        name: "Level",
        handle: "level",
        value: 68,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para2,
        midiCC: MidiCCValuesPro.DLY_Para2),
    Parameter(
        name: "Mod",
        handle: "mod",
        value: 68,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para3,
        midiCC: MidiCCValuesPro.DLY_Para3),
    Parameter(
        name: "Repeat",
        handle: "repeat",
        value: 48,
        valueType: ValueType.tempo,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para4,
        midiCC: MidiCCValuesPro.DLY_Para4),
  ];
}

class TapeEcho extends Delay {
  final name = "Tape Echo";

  int get nuxIndex => 3;
  List<Parameter> parameters = [
    Parameter(
        name: "Time",
        handle: "time",
        value: 61,
        valueType: ValueType.tempo,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para1,
        midiCC: MidiCCValuesPro.DLY_Para1),
    Parameter(
        name: "Level",
        handle: "level",
        value: 43,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para2,
        midiCC: MidiCCValuesPro.DLY_Para2),
    Parameter(
        name: "Repeat",
        handle: "repeat",
        value: 56,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para3,
        midiCC: MidiCCValuesPro.DLY_Para3),
  ];
}

class PanDelay extends Delay {
  final name = "Pan Delay";

  int get nuxIndex => 3;
  List<Parameter> parameters = [
    Parameter(
        name: "Time",
        handle: "time",
        value: 50,
        valueType: ValueType.tempo,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para1,
        midiCC: MidiCCValuesPro.DLY_Para1),
    Parameter(
        name: "Repeat",
        handle: "repeat",
        value: 50,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para2,
        midiCC: MidiCCValuesPro.DLY_Para2),
    Parameter(
        name: "Level",
        handle: "level",
        value: 45,
        valueType: ValueType.percentage,
        devicePresetIndex: PresetDataIndexPlugPro.DLY_Para3,
        midiCC: MidiCCValuesPro.DLY_Para3),
  ];
}
