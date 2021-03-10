// (c) 2020 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'dart:ui';

import '../NuxDevice.dart';
import '../effects/Processor.dart';
import '../effects/EFX.dart';
import '../effects/Amps.dart';
import '../effects/Cabinet.dart';
import '../effects/Modulation.dart';
import '../effects/Delay.dart';
import '../effects/Reverb.dart';
import 'Preset.dart';

class M8BTPreset extends Preset {
  NuxDevice device;
  int instrument;
  int channel;
  String channelName;
  Color get channelColor => Preset.channelColors[channel];
  final NoiseGate noiseGate = NoiseGate();
  final List<Amplifier> amplifierList = <Amplifier>[];
  final List<Modulation> modulationList = <Modulation>[];
  final List<Delay> delayList = <Delay>[];
  final List<Reverb> reverbList = <Reverb>[];

  bool noiseGateEnabled = true;
  bool modulationEnabled = true;
  bool delayEnabled = true;
  bool reverbEnabled = true;

  int selectedAmp = 0;
  int selectedMod = 0;
  int selectedDelay = 0;
  int selectedReverb = 0;

  M8BTPreset({this.device, this.instrument, this.channel, this.channelName}) {
    //modulation is available everywhere
    modulationList
        .addAll([Phaser(), Chorus(), STChorus(), Flanger(), Vibe(), Tremolo()]);

    amplifierList.addAll([TwinVerb(), Plexi(), Fireman()]);

    delayList.addAll([AnalogDelay(), TapeEcho(), DigitalDelay(), PingPong()]);

    //reverb is available in all presets
    reverbList
        .addAll([RoomReverb(), HallReverb(), PlateReverb(), SpringReverb()]);
  }

  /// checks if the effect slot can be switched on and off
  bool slotSwitchable(int index) {
    if (index == 1) return false;
    return true;
  }

  //returns whether the specific slot is on or off
  bool slotEnabled(int index) {
    switch (index) {
      case 0:
        return noiseGateEnabled;
      case 2:
        return modulationEnabled;
      case 3:
        return delayEnabled;
      case 4:
        return reverbEnabled;
      default:
        return true;
    }
  }

  //turns slot on or off
  @override
  void setSlotEnabled(int index, bool value, bool notifyBT) {
    switch (index) {
      case 0:
        noiseGateEnabled = value;
        break;
      case 2:
        modulationEnabled = value;
        break;
      case 3:
        delayEnabled = value;
        break;
      case 4:
        reverbEnabled = value;
        break;
      default:
        return;
    }

    super.setSlotEnabled(index, value, notifyBT);
  }

  //returns list of effects for given slot
  List<Processor> getEffectsForSlot(int slot) {
    switch (slot) {
      case 0:
        return [noiseGate];
      case 1:
        return amplifierList;
      case 2:
        return modulationList;
      case 3:
        return delayList;
      case 4:
        return reverbList;
    }
    return null;
  }

  //returns which of the effects is selected for a given slot
  int getSelectedEffectForSlot(int slot) {
    switch (slot) {
      case 0:
        return 0;
      case 1:
        return selectedAmp;
      case 2:
        return selectedMod;
      case 3:
        return selectedDelay;
      case 4:
        return selectedReverb;
      default:
        return 0;
    }
  }

  //sets the effect for the given slot
  @override
  void setSelectedEffectForSlot(int slot, int index, bool notifyBT) {
    switch (slot) {
      case 1:
        selectedAmp = index;
        break;
      case 2:
        selectedMod = index;
        break;
      case 3:
        selectedDelay = index;
        break;
      case 4:
        selectedReverb = index;
        break;
    }
    super.setSelectedEffectForSlot(slot, index, notifyBT);
  }

  Color effectColor(int index) {
    if (index != 1)
      return device.processorList[index].color;
    else
      return channelColor;
  }
}