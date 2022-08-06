import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mighty_plug_manager/UI/widgets/app_drawer.dart';
import 'package:mighty_plug_manager/midi/MidiControllerManager.dart';
import 'package:mighty_plug_manager/platform/simpleSharedPrefs.dart';

import 'UI/pages/drumEditor.dart';
import 'UI/pages/jamTracks.dart';
//pages
import 'UI/pages/presetEditor.dart';
import 'UI/pages/settings.dart';
import 'UI/popups/alertDialogs.dart';
import 'UI/theme.dart';
import 'UI/widgets/bottom_bar.dart';
import 'UI/widgets/nestedWillPopScope.dart';
import 'UI/widgets/nux_app_bar.dart';
import 'UI/widgets/presets/presetList.dart';
import 'UI/widgets/volume_drawer.dart';
import 'bluetooth/NuxDeviceControl.dart';
import 'bluetooth/bleMidiHandler.dart';

enum LayoutMode { navBar, drawer, columns }

class Home extends StatefulWidget {
  final MidiControllerManager midiMan = MidiControllerManager();

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late BuildContext dialogContext;
  late TabController controller;
  final List<Widget> _tabs = [];

  bool isBottomDrawerOpen = false;

  bool connectionFailed = false;
  late Timer _timeout;
  StateSetter? dialogSetState;

  @override
  void initState() {
    if (!AppThemeConfig.allowRotation) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }

    super.initState();

    //add 5 pages widgets
    _tabs.addAll([
      PresetEditor(),
      PresetList(),
      DrumEditor(),
      JamTracks(),
      const Settings(),
    ]);

    controller = TabController(initialIndex: 0, length: 5, vsync: this)
      ..addListener(_tabControllerListener);

    NuxDeviceControl.instance()
        .connectStatus
        .stream
        .listen(_connectionStateListener);
    NuxDeviceControl.instance().addListener(_onDeviceChanged);

    BLEMidiHandler.instance().initBle(_bleErrorHandler);
  }

  @override
  void dispose() {
    super.dispose();
    NuxDeviceControl.instance().removeListener(_onDeviceChanged);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final layoutMode = _getLayoutMode(mediaQuery);
    final currentVolume = NuxDeviceControl.instance().masterVolume;
    //WARNING: Workaround for a flutter bug - if the app is started with screen off,
    //one of the widgets throwns an exception and the app scaffold is empty
    if (screenWidth < 10) return Container();

    return FocusScope(
      autofocus: true,
      onKey: _onKeyFocusScope,
      child: NestedWillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: const NuxAppBar(),
          drawer: layoutMode == LayoutMode.drawer
              ? AppDrawer(
                  onSwitchPageIndex: _onTabBarSwitchIndex,
                  currentIndex: _currentIndex,
                  totalTabs: _tabs.length,
                  currentVolume: currentVolume,
                  onVolumeChanged: _onVolumeChanged,
                  onVolumeDragEnd: _onVolumeDragEnd,
                )
              : null,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                children: [
                  if (layoutMode == LayoutMode.columns)
                    AppDrawer(
                      onSwitchPageIndex: _onTabBarSwitchIndex,
                      currentIndex: _currentIndex,
                      totalTabs: _tabs.length,
                      currentVolume: currentVolume,
                      onVolumeChanged: _onVolumeChanged,
                      onVolumeDragEnd: _onVolumeDragEnd,
                    ),
                  Expanded(
                    child: layoutMode == LayoutMode.navBar
                        ? TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller,
                            children: _tabs,
                          )
                        : _tabs.elementAt(_currentIndex),
                  ),
                ],
              ),
              if (layoutMode != LayoutMode.columns)
                BottomDrawer(
                  isBottomDrawerOpen: isBottomDrawerOpen,
                  onExpandChange: (val) => setState(() {
                    isBottomDrawerOpen = val;
                  }),
                  child: VolumeSlider(
                    currentVolume: currentVolume,
                    onVolumeChanged: _onVolumeChanged,
                    onVolumeDragEnd: _onVolumeDragEnd,
                  ),
                ),
            ],
          ),
          bottomNavigationBar: layoutMode == LayoutMode.navBar
              ? GestureDetector(
                  onVerticalDragUpdate: _onBottomBarSwipe,
                  child: BottomBar(
                    index: _currentIndex,
                    onTap: _onTabBarSwitchIndex,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  void _onVolumeDragEnd(_) {
    SharedPrefs().setValue(
      SettingsKeys.masterVolume,
      NuxDeviceControl.instance().masterVolume,
    );
  }

  void _onVolumeChanged(value) {
    setState(() {
      NuxDeviceControl.instance().masterVolume = value;
    });
  }

  KeyEventResult _onKeyFocusScope(node, event) {
    if (event.runtimeType.toString() == 'RawKeyDownEvent' &&
        event.logicalKey.keyId != 0x100001005) {
      MidiControllerManager().onHIDData(event);
    }
    return KeyEventResult.skipRemainingHandlers;
  }

  void _bleErrorHandler(BluetoothError error, dynamic data) {
    {
      switch (error) {
        case BluetoothError.unavailable:
          AlertDialogs.showInfoDialog(context,
              title: "Warning!",
              description: "Your device does not support bluetooth!",
              confirmButton: "OK");
          break;
        case BluetoothError.permissionDenied:
          AlertDialogs.showLocationPrompt(context, false, null);
          break;
        case BluetoothError.locationServiceOff:
          AlertDialogs.showInfoDialog(context,
              title: "Location service is disabled!",
              description:
                  "Please, enable location service. It is required for Bluetooth connection to work.",
              confirmButton: "OK");
          break;
      }
    }
  }

  void _onConnectionTimeout() async {
    connectionFailed = true;
    if (dialogSetState != null) {
      dialogSetState?.call(() {});
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
      dialogSetState = null;
      BLEMidiHandler.instance().disconnectDevice();
    }
  }

  void _connectionStateListener(DeviceConnectionState event) {
    switch (event) {
      case DeviceConnectionState.connectedStart:
        if (dialogSetState != null) break;
        print("just connected");
        connectionFailed = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogContext = context;
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                dialogSetState = setState;
                return NestedWillPopScope(
                  onWillPop: () => Future.value(false),
                  child: Dialog(
                    backgroundColor: Colors.grey[700],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!connectionFailed)
                            const CircularProgressIndicator(),
                          if (connectionFailed)
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            connectionFailed
                                ? "Connection Failed!"
                                : "Connecting",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );

        //setup a timer incase something fails
        _timeout = Timer(const Duration(seconds: 10), _onConnectionTimeout);

        break;
      case DeviceConnectionState.presetsLoaded:
        print("presets loaded");
        break;
      case DeviceConnectionState.configReceived:
        print("config loaded");
        dialogSetState = null;
        _timeout.cancel();
        Navigator.pop(context);
        break;
    }
  }

  void _onDeviceChanged() {
    setState(() {});
  }

  Future<bool> _willPopCallback() async {
    Completer<bool> confirmation = Completer<bool>();
    AlertDialogs.showConfirmDialog(context,
        title: "Exit Mightier Amp?",
        cancelButton: "No",
        confirmButton: "Yes",
        confirmColor: Colors.red,
        description: "Are you sure?", onConfirm: (val) {
      if (val) {
        //disconnect device if connected
        BLEMidiHandler.instance().disconnectDevice();
      }
      confirmation.complete(val);
    });
    return confirmation.future;
  }

  void _onBottomBarSwipe(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      //open
      setState(() {
        isBottomDrawerOpen = true;
      });
    } else {
      //close
      setState(() {
        isBottomDrawerOpen = false;
      });
    }
  }

  void _onTabBarSwitchIndex(int index) {
    setState(() {
      _currentIndex = index;
      controller.animateTo(_currentIndex);
    });
  }

  void _tabControllerListener() {
    setState(() {
      _currentIndex = controller.index;
    });
  }

  LayoutMode _getLayoutMode(MediaQueryData mediaQuery) {
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final screenWidth = mediaQuery.size.width;
    debugPrint('Screen Width is: $screenWidth.');
    if (screenWidth >= 700) return LayoutMode.columns;
    if (screenWidth >= 600) return LayoutMode.drawer;
    return LayoutMode.navBar;
  }
}
