// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'package:flutter/material.dart';

import '../../UI/mightier_icons.dart';
import '../nux_device_control.dart';
import 'NuxConstants.dart';
import 'NuxDevice.dart';
import 'communication/communication.dart';
import 'communication/liteCommunication.dart';
import 'effects/Processor.dart';
import 'presets/MightyLitePreset.dart';
import 'presets/Preset.dart';

enum MLiteChannel { Clean, Overdrive, Distortion }

class NuxMightyLite extends NuxDevice {
  @override
  int get productVID => 48;

  late final LiteCommunication _communication = LiteCommunication(this);
  @override
  DeviceCommunication get communication => _communication;

  @override
  String get productName => "NUX Mighty Lite BT";
  @override
  String get productNameShort => "Mighty Lite";
  @override
  String get productStringId => "mighty_lite";
  @override
  int get productVersion => 0;
  @override
  IconData get productIcon => MightierIcons.amp_lite;

  @override
  List<String> get productBLENames =>
      ["NUX MIGHTY LITE MIDI", "AirBorne GO", "GUO AN MIDI"];

  @override
  int get channelsCount => 3;
  @override
  int get effectsChainLength => 4;
  int get groupsCount => 1;
  @override
  int get amplifierSlotIndex => 1;
  @override
  bool get cabinetSupport => false;
  @override
  int get cabinetSlotIndex => 0;
  @override
  bool get presetSaveSupport => false;
  @override
  bool get reorderableFXChain => false;
  @override
  bool get advancedSettingsSupport => false;
  @override
  bool get batterySupport => false;
  @override
  int get channelChangeCC => MidiCCValues.bCC_AmpModeSetup;
  @override
  int get deviceQRId => 5;

  @override
  List<String> get groupsName => ["Default"];
  @override
  List<ProcessorInfo> get processorList => _processorList;

  final List<ProcessorInfo> _processorList = [
    ProcessorInfo(
        shortName: "Gate",
        longName: "Noise Gate",
        keyName: "gate",
        color: Colors.green,
        icon: MightierIcons.gate),
    ProcessorInfo(
        shortName: "Amp",
        longName: "Amplifier",
        keyName: "amp",
        color: Colors.green,
        icon: MightierIcons.amp),
    ProcessorInfo(
        shortName: "Mod",
        longName: "Modulation",
        keyName: "mod",
        color: Colors.cyan[300]!,
        icon: Icons.waves),
    ProcessorInfo(
        shortName: "Ambience",
        longName: "Ambience",
        keyName: "ambience",
        color: Colors.orange,
        icon: Icons.blur_on),
  ];

  List<String> channelNames = [];

  final List<String> drumStyles = [
    "Metronome",
    "Pop",
    "Metal",
    "Blues",
    "Country",
    "Rock",
    "Ballad Rock",
    "Funk",
    "R&B",
    "Latin"
  ];

  NuxMightyLite(NuxDeviceControl devControl) : super(devControl) {
    //get channel names
    for (var element in MLiteChannel.values) {
      channelNames.add(element.toString().split('.')[1]);
    }

    //clean
    presets.add(MLitePreset(
        device: this, channel: MLiteChannel.Clean.index, channelName: "Clean"));

    //OD
    presets.add(MLitePreset(
        device: this,
        channel: MLiteChannel.Overdrive.index,
        channelName: "Drive"));

    //Dist
    presets.add(MLitePreset(
        device: this,
        channel: MLiteChannel.Distortion.index,
        channelName: "Dist"));
  }

  @override
  List<String> getDrumStyles() => drumStyles;

  @override
  List<Preset> getPresetsList() {
    return presets;
  }

  @override
  String channelName(int channel) {
    return channelNames[channel];
  }

  @override
  void setFirmwareVersion(int ver) {}

  @override
  void setFirmwareVersionByIndex(int ver) {}

  @override
  MLitePreset getCustomPreset(int channel) {
    var preset = MLitePreset(device: this, channel: channel, channelName: "");
    preset.setFirmwareVersion(productVersion);
    return preset;
  }
}
