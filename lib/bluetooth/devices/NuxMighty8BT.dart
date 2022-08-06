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
import 'presets/Mighty8BTPreset.dart';
import 'presets/Preset.dart';

enum M8BTChannel { Clean, Overdrive, Distortion }

class NuxMighty8BT extends NuxDevice {
  @override
  int get productVID => 48;
  late final LiteCommunication _communication = LiteCommunication(this);
  @override
  DeviceCommunication get communication => _communication;

  @override
  String get productName => "NUX Mighty 8 BT";
  @override
  String get productNameShort => "Mighty 8 BT";
  @override
  IconData get productIcon => MightierIcons.amp_8bt;
  @override
  String get productStringId => "mighty_8bt";
  @override
  int get productVersion => 0;
  @override
  List<String> get productBLENames => ["NUX MIGHTY8BT MIDI"];

  @override
  int get channelsCount => 3;
  @override
  int get effectsChainLength => 5;
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
  int get deviceQRId => 3;

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
        shortName: "Delay",
        longName: "Delay",
        keyName: "delay",
        color: Colors.blueAccent,
        icon: Icons.blur_linear),
    ProcessorInfo(
        shortName: "Reverb",
        longName: "Reverb",
        keyName: "reverb",
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

  NuxMighty8BT(NuxDeviceControl devControl) : super(devControl) {
    //get channel names
    for (var element in M8BTChannel.values) {
      channelNames.add(element.toString().split('.')[1]);
    }

    //clean
    presets.add(M8BTPreset(
        device: this, channel: M8BTChannel.Clean.index, channelName: "Clean"));

    //OD
    presets.add(M8BTPreset(
        device: this,
        channel: M8BTChannel.Overdrive.index,
        channelName: "Drive"));

    //Dist
    presets.add(M8BTPreset(
        device: this,
        channel: M8BTChannel.Distortion.index,
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
  M8BTPreset getCustomPreset(int channel) {
    var preset = M8BTPreset(device: this, channel: channel, channelName: "");
    preset.setFirmwareVersion(productVersion);
    return preset;
  }
}
