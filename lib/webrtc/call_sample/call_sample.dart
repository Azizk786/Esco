import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'videoCallView.dart';

class CallSample extends StatefulWidget {
  static String tag = 'call_sample';
  var selfId;
  String displayName;
  String ip;
  Signaling signaling;
  var peerId;
  bool isFromDashboard = false;

  static _CallSampleState cs;

  CallSample({Key key, @required this.ip, @required this.displayName, @required this.selfId, @required this.signaling, @required this.peerId, @required this.isFromDashboard});

  @override
  _CallSampleState createState() => cs = new _CallSampleState(serverIP: ip, displayName: displayName, selfId: selfId, signaling: signaling, peerId: peerId, isFromDashboard: isFromDashboard);

  }

class _CallSampleState extends State<CallSample> {
  bool _saving = true;
  Signaling signaling;
  var selfId;
  var peerId;
  String displayName =
  Platform.localHostname + '(' + Platform.operatingSystem + ")";
  Timer timer;
  bool isRemoteStreamFound = false;
  bool isLocalStreamFound = false;
  bool isFromDashboard = false;

  List<dynamic> _peers;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  bool _inCalling = false;
  final String serverIP;
  _CallSampleState currentContext;
  bool isCallTerminated = false;
  Timer tt;
  _CallSampleState({Key key, @required this.serverIP, @required this.displayName, @required this.selfId, @required this.signaling, @required this.peerId, @required this.isFromDashboard});

  @override
  initState() {
    super.initState();
    currentContext = this;
    connectingToPeear();

    initRenderers();
    _connect();
  }

  connectingToPeear() {

    timer = Timer.periodic(new Duration(seconds: 20), (timer) {
      if(timer != null) {
        timer.cancel();
      }
      try{
        Navigator.pop(context);
      } catch(e) {

      }
    });
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();

    currentContext = null;
    isRemoteStreamFound = false;
    isLocalStreamFound = false;
    isCallTerminated = false;

    if(VideoCall.vc != null) {
      VideoCall.vc.onStateChange = null;
      VideoCall.vc.onPeersUpdate = null;
      VideoCall.vc.onLocalStream = null;
      VideoCall.vc.onAddRemoteStream = null;
      VideoCall.vc.onRemoveRemoteStream = null;
    }


    if (signaling != null) signaling.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    tt = Timer(Duration(milliseconds: 1000), () {
      if(tt != null)
      tt.cancel();
      Signaling.getSignalingContext().connect();
    });

  }

  void _connect() async {

    VideoCall videoCall = VideoCall.getSharedInstance();

    videoCall.onStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.CallStateNew:
          this.setState(() {
            if(timer != null)
              timer.cancel();
            _inCalling = true;
            _saving = false;
          });
          break;
        case SignalingState.CallStateBye:
          this.setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;

            if(_inCalling && !isCallTerminated) {
              _inCalling = false;
              Navigator.pop(context);
            }
            //* Back navigation
          });
          break;
        case SignalingState.CallStateInvite:
        case SignalingState.CallStateConnected:
        case SignalingState.CallStateRinging:
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };

    videoCall.onPeersUpdate = ((event) {
      this.setState(() {
        selfId = event['self'];
        _peers = event['peers'];

        for(int i = 0; i< _peers.length; i++) {
          if(_peers[i]["id"] == peerId.toString()) {
            _invitePeer(context, peerId, false);
          }
        }

      });
    });

    videoCall.onLocalStream = ((stream) {
      this.setState(() {
        isLocalStreamFound = true;
        _localRenderer.srcObject = stream;
      });
    });

    videoCall.onAddRemoteStream = ((stream) {
      this.setState(() {
        isRemoteStreamFound = true;
        _remoteRenderer.srcObject = stream;
      });
    });

    videoCall.onRemoveRemoteStream = ((stream) {
      this.setState(() {
        _remoteRenderer.srcObject = null;
      });
    });



    this.setState(() {
      _peers = Signaling.sharedPeers;

      for(int i = 0; i< _peers.length; i++) {
        if(_peers[i]["id"] == peerId.toString()) {
          _invitePeer(context, peerId, false);
        }
      }


    });

  }

  _invitePeer(context, peerId, use_screen) async {
    if (signaling != null && peerId != selfId) {
      if(isFromDashboard) {
       signaling.callAccept(peerId.toString(), 'video', use_screen);
      } else {
        signaling.ring(peerId.toString(), 'video', use_screen);
      }
    }
  }

  _hangUp() {
    if (signaling != null) {
      isCallTerminated = true;
      signaling.bye();
      Navigator.pop(context);
    }
  }

  _switchCamera() {
    signaling.switchCamera();
  }

  _muteMic() {

  }

  _buildRow(context, peer) {
    var self = (peer['id'] == selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + '[Your self]'
            : peer['name'] + '[' + peer['user_agent'] + ']'),
        onTap: null,
        trailing: new SizedBox(
            width: 100.0,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: () => _invitePeer(context, peer['id'], false),
                    tooltip: 'Video calling',
                  ),
                  IconButton(
                    icon: const Icon(Icons.screen_share),
                    onPressed: () => _invitePeer(context, peer['id'], true),
                    tooltip: 'Screen sharing',
                  )
                ])),
        subtitle: Text('id: ' + peer['id']),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('call'),
//        actions: <Widget>[
//          IconButton(
//            icon: const Icon(Icons.settings),
//            onPressed: null,
//            tooltip: 'setup',
//          ),
//        ],
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? new SizedBox(
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _hangUp,
                    tooltip: 'Hangup',
                    child: new Icon(Icons.call_end),
                    backgroundColor: Colors.red,
                  ),
        SizedBox(width: 20,),
        FloatingActionButton(
        onPressed: _switchCamera,
        tooltip: 'Camera',
        child: new Icon(Icons.camera_front),
        backgroundColor: Colors.red,
      ),
                  SizedBox(width: 20,),
                  FloatingActionButton(
                    onPressed: _switchCamera,
                    tooltip: 'Camera',
                    child: new Icon(Icons.speaker_phone),
                    backgroundColor: Colors.red,
                  )
                ])) : null,
      body: (_inCalling &&  isRemoteStreamFound &&  isLocalStreamFound)
          ? OrientationBuilder(builder: (context, orientation) {
              return new Container(
                child: new Stack(children: <Widget>[
                  new Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: new RTCVideoView(_remoteRenderer),
                        decoration: new BoxDecoration(color: Colors.black54),
                      )),
                  new Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: new Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: new RTCVideoView(_localRenderer),
                      decoration: new BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ]),
              );
            })
          : Center(
    child: new CircularProgressIndicator()),
    );
  }
}
