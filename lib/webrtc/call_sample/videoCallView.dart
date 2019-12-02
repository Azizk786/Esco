import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';

typedef void SignalingStateCallback(SignalingState state);
typedef void StreamStateCallback(MediaStream stream);
typedef void OtherEventCallback(dynamic event);

class VideoCall {

  SignalingStateCallback onStateChange;
  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  OtherEventCallback onPeersUpdate;

  static VideoCall vc;

  VideoCall() {
    vc = this;
  }

  onStateChanged(SignalingState state) {
    if (this.onStateChange != null) {
      this.onStateChange(state);
    }
  }

  onLocalStreamChanged(MediaStream stream) {
    if (this.onLocalStream != null) {
      this.onLocalStream(stream);
    }
  }

  onAddRemoteStreamChanged(MediaStream stream) {
    if (this.onAddRemoteStream != null) {
      this.onAddRemoteStream(stream);
    }
  }

  onRemoveRemoteStreamChanged(MediaStream stream) {
    if (this.onRemoveRemoteStream != null) {
      this.onRemoveRemoteStream(stream);
    }
  }

  onPeersUpdated(dynamic event) {
    if (this.onPeersUpdate != null) {
      this.onPeersUpdate(event);
    }
  }

  static VideoCall getSharedInstance() {
    return vc;
  }
}