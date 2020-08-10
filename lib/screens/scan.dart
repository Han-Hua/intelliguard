import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import '../models/tracing_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class ScanBeacon extends StatefulWidget {
  static const routeName = '/scan';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ScanBeacon> with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;
  String location = "North Agora";
  String status = "";
  String nric = "";
  int contact = 0;
  String checkStatus = "";
  List<Beacon> beacons = <Beacon>[];


  Future<String> getNRICPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nric = prefs.getString("nric");

    return nric;
  }

  Future<int> getContactPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int contact = prefs.getInt("contact");

    return contact;
  }

  Future<String> contactTracing(TracingInfo a) async {
    String url =
        "https://maddintelliguard.azurewebsites.net/api/Entry/addTracing";

    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: convert.jsonEncode({
          "location": a.location,
          "nric": a.nric,
          "contact": a.contact,
          "status": a.status,
          "entrytime": a.entrytime
        }));

    return response.statusCode.toString();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    listeningState();

    getNRICPreference().then(updateNRIC);
    getContactPreference().then(updateContact);
    super.initState();
  }

  void updateNRIC(String nric) {
    setState(() {
      this.nric = nric;
    });
  }
  void updateContact(int contact) {
    setState(() {
      this.contact = contact;
    });
  }

  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('BluetoothState = $state');
      streamController.add(state);

      switch (state) {
        case BluetoothState.stateOn:
          initScanBeacon();
          break;
        case BluetoothState.stateOff:
          await pauseScanBeacon();
          await checkAllRequirements();
          break;
      }
    });
  }

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;

    setState(() {
      this.authorizationStatusOk = authorizationStatusOk;
      this.locationServiceEnabled = locationServiceEnabled;
      this.bluetoothEnabled = bluetoothEnabled;
    });
  }

  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    await checkAllRequirements();
    if (!authorizationStatusOk ||
        !locationServiceEnabled ||
        !bluetoothEnabled) {
      print('RETURNED, authorizationStatusOk=$authorizationStatusOk, '
          'locationServiceEnabled=$locationServiceEnabled, '
          'bluetoothEnabled=$bluetoothEnabled');
      return;
    }
    final regions = <Region>[
      Region(
        identifier: 'c6107d19954b9b9a7014e224fac63417',
        proximityUUID: 'B9407F30-F5F8-466E-AFF9-25556B57FE6D',
      ),
    ];
    regions.add(Region(
      identifier: '1eb411f43b4a35d0b20be604e86fbd3c',
      proximityUUID: '7B8C48A1-6287-FE3C-F194-C99FA98C3AA3',
    ));

    if (_streamRanging != null) {
      if (_streamRanging.isPaused) {
        _streamRanging.resume();
        return;
      }
    }

    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      print(result);
      if (result != null && mounted) {
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            list.forEach((element) {
              if (element.accuracy < 0.2) {
                _beacons.add(element);

                if (element.proximityUUID ==
                    'B9407F30-F5F8-466E-AFF9-25556B57FE6D') {
                  status = 'Check-IN';
                  if (status != checkStatus) {
                    checkStatus = status;
                    TracingInfo record = new TracingInfo(
                        location, nric, contact, status, DateTime.now());
                    contactTracing(record);
                  }
                } else if (element.proximityUUID ==
                    '7B8C48A1-6287-FE3C-F194-C99FA98C3AA3') {
                  status = 'Check-Out';
                  if (status != checkStatus) {
                    checkStatus = status;
                    TracingInfo record = new TracingInfo(
                        location, nric, contact, status, DateTime.now());
                    contactTracing(record);
                  }
                }
              }
            });
          });
          _beacons.sort(_compareParameters);
        });
      }
    });
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null && _streamBluetooth.isPaused) {
        _streamBluetooth.resume();
      }
      await checkAllRequirements();
      if (authorizationStatusOk && locationServiceEnabled && bluetoothEnabled) {
        await initScanBeacon();
      } else {
        await pauseScanBeacon();
        await checkAllRequirements();
      }
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    streamController?.close();
    _streamRanging?.cancel();
    _streamBluetooth?.cancel();
    flutterBeacon.close;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Beacon'),
          centerTitle: false,
          actions: <Widget>[
            if (!authorizationStatusOk)
              IconButton(
                  icon: Icon(Icons.portable_wifi_off),
                  color: Colors.red,
                  onPressed: () async {
                    await flutterBeacon.requestAuthorization;
                  }),
            if (!locationServiceEnabled)
              IconButton(
                  icon: Icon(Icons.location_off),
                  color: Colors.red,
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      await flutterBeacon.openLocationSettings;
                    } else if (Platform.isIOS) {}
                  }),
            StreamBuilder<BluetoothState>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final state = snapshot.data;

                  if (state == BluetoothState.stateOn) {
                    return IconButton(
                      icon: Icon(Icons.bluetooth_connected),
                      onPressed: () {},
                      color: Colors.lightBlueAccent,
                    );
                  }

                  if (state == BluetoothState.stateOff) {
                    return IconButton(
                      icon: Icon(Icons.bluetooth),
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          try {
                            await flutterBeacon.openBluetoothSettings;
                          } on PlatformException catch (e) {
                            print(e);
                          }
                        } else if (Platform.isIOS) {}
                      },
                      color: Colors.red,
                    );
                  }

                  return IconButton(
                    icon: Icon(Icons.bluetooth_disabled),
                    onPressed: () {},
                    color: Colors.grey,
                  );
                }

                return SizedBox.shrink();
              },
              stream: streamController.stream,
              initialData: BluetoothState.stateUnknown,
            ),
          ],
        ),
        body: _beacons == null || _beacons.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: ListTile.divideTiles(
                    context: context,
                    tiles: _beacons.map((beacon) {
                      return ListTile(
                        title: Text(location),
                        subtitle: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                child: Text('$status',
                                    style: TextStyle(fontSize: 13.0)),
                                flex: 1,
                                fit: FlexFit.tight),
                            Flexible(
                                child: Text('$nric',
                                    style: TextStyle(fontSize: 13.0)),
                                flex: 2,
                                fit: FlexFit.tight)
                          ],
                        ),
                      );
                    })).toList(),
              ),
      ),
    );
  }
}
