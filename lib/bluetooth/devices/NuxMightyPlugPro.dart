// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'package:flutter/material.dart';
import 'communication/communication.dart';
import 'communication/plugProCommunication.dart';
import '../../UI/mightierIcons.dart';

import '../NuxDeviceControl.dart';
import 'NuxConstants.dart';
import 'NuxDevice.dart';
import 'effects/Processor.dart';
import 'presets/PlugProPreset.dart';
import 'presets/Preset.dart';

enum PlugProChannel { Clean, Overdrive, Distortion, AGSim, Pop, Rock, Funk }

enum PlugProVersion { PlugPro1 }

class NuxMightyPlugPro extends NuxDevice {
  //this is used in conversion of very old format of presets which
  // didn't contain device id. They were always for mighty plug/air
  static const defaultNuxId = "mighty_plug_air";
  int get productVID => 48;
  late PlugProCommunication _communication = new PlugProCommunication(this);
  DeviceCommunication get communication => _communication;

  PlugProVersion version = PlugProVersion.PlugPro1;

  String get productName => "NUX Mighty Plug Pro";
  String get productNameShort => "Mighty Plug Pro";
  String get productStringId => "mighty_plug_pro";
  int get productVersion => version.index;
  IconData get productIcon => MightierIcons.amp_plugair;
  List<String> get productBLENames => ["MIGHTY PLUG PRO"];

  int get channelsCount => 7;
  int get effectsChainLength => 9;
  int get groupsCount => 1;
  int get amplifierSlotIndex {
    var preset = getPreset(selectedChannel);
    for (int i = 0; i < processorList.length; i++)
      if (preset.getProcessorAtSlot(i) == 3) return i;

    return 3;
  }

  bool get cabinetSupport => true;
  int get cabinetSlotIndex {
    var preset = getPreset(selectedChannel);
    for (int i = 0; i < processorList.length; i++)
      if (preset.getProcessorAtSlot(i) == 4) return i;

    return 4;
  }

  bool get presetSaveSupport => false;
  bool get reorderableFXChain => true;
  bool get advancedSettingsSupport => false;
  bool get batterySupport => false;
  int get channelChangeCC => MidiCCValues.bCC_CtrlType;

  //TODO: might be different
  int get deviceQRId => 6;

  List<ProcessorInfo> get processorList => _processorList;

  final List<ProcessorInfo> _processorList = [
    ProcessorInfo(
        shortName: "GATE",
        longName: "Noise Gate",
        keyName: "gate",
        color: Colors.lightGreen,
        icon: MightierIcons.gate),
    ProcessorInfo(
        shortName: "COMP",
        longName: "comp",
        keyName: "compressor",
        color: Colors.yellow,
        icon: Icons.stacked_line_chart),
    ProcessorInfo(
        shortName: "EFX",
        longName: "EFX",
        keyName: "efx",
        color: Colors.orange,
        icon: MightierIcons.pedal),
    ProcessorInfo(
        shortName: "AMP",
        longName: "Amplifier",
        keyName: "amp",
        color: Colors.red,
        icon: MightierIcons.amp),
    ProcessorInfo(
        shortName: "IR",
        longName: "Cabinet",
        keyName: "cabinet",
        color: Colors.lightBlue,
        icon: MightierIcons.cabinet),
    ProcessorInfo(
        shortName: "MOD",
        longName: "Modulation",
        keyName: "mod",
        color: Colors.indigo[400]!,
        icon: Icons.waves),
    ProcessorInfo(
        shortName: "EQ",
        longName: "EQ",
        keyName: "eq",
        color: Colors.grey[300]!,
        icon: MightierIcons.sliders),
    ProcessorInfo(
        shortName: "DLY",
        longName: "Delay",
        keyName: "delay",
        color: Colors.purple,
        icon: Icons.blur_linear),
    ProcessorInfo(
        shortName: "RVB",
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
    "Swing",
    "Rock",
    "Ballad Rock",
    "Funk",
    "R&B",
    "Latin",
    "Dance"
  ];

  NuxMightyPlugPro(NuxDeviceControl devControl) : super(devControl) {
    //get channel names
    PlugProChannel.values.forEach((element) {
      channelNames.add(element.toString().split('.')[1]);
    });

    //clean
    presets.add(PlugProPreset(
        device: this, channel: PlugProChannel.Clean.index, channelName: "1"));

    //OD
    presets.add(PlugProPreset(
        device: this,
        channel: PlugProChannel.Overdrive.index,
        channelName: "2"));

    //Dist
    presets.add(PlugProPreset(
        device: this,
        channel: PlugProChannel.Distortion.index,
        channelName: "3"));

    //AGSim
    presets.add(PlugProPreset(
        device: this, channel: PlugProChannel.AGSim.index, channelName: "4"));

    //Pop Bass
    presets.add(PlugProPreset(
        device: this, channel: PlugProChannel.Pop.index, channelName: "5"));

    //Rock Bass
    presets.add(PlugProPreset(
        device: this, channel: PlugProChannel.Rock.index, channelName: "6"));

    //Funk Bass
    presets.add(PlugProPreset(
        device: this, channel: PlugProChannel.Funk.index, channelName: "7"));

    for (var preset in presets)
      (preset as PlugProPreset).setFirmwareVersion(version.index);
  }

  List<String> getDrumStyles() => drumStyles;

  List<Preset> getPresetsList() {
    return presets;
  }

  @override
  String channelName(int channel) {
    return channelNames[channel];
  }

  @override
  void setFirmwareVersion(int ver) {
    version = PlugProVersion.PlugPro1;

    //set all presets with that firmware
    for (var preset in presets)
      (preset as PlugProPreset).setFirmwareVersion(version.index);
  }

  @override
  void setFirmwareVersionByIndex(int ver) {
    if (ver > getAvailableVersions() - 1) ver = getAvailableVersions() - 1;
    version = PlugProVersion.values[ver];

    //set all presets with that firmware
    for (var preset in presets)
      (preset as PlugProPreset).setFirmwareVersion(version.index);
  }

  @override
  PlugProPreset getCustomPreset(int channel) {
    var preset = PlugProPreset(device: this, channel: channel, channelName: "");
    preset.setFirmwareVersion(productVersion);
    return preset;
  }
}
