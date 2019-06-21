import "package:mqtt_client/mqtt_client.dart";
import 'config.dart';

class ConnectionState {
  final int value;
  const ConnectionState(this.value);
  static const ConnectionState Connecting = ConnectionState(1);
  static const ConnectionState Connected = ConnectionState(2);
  static const ConnectionState ConnectionFailed = ConnectionState(4);
  static const ConnectionState Disconnected = ConnectionState(8);
  static const ConnectionState Subscribing = ConnectionState(16);
  static const ConnectionState Subscribed = ConnectionState(32);
  static const ConnectionState Unsubscribed = ConnectionState(64);

  ConnectionState operator &(ConnectionState other) {
    return ConnectionState(this.value & other.value);
  }

  ConnectionState operator |(ConnectionState other) {
    return ConnectionState(this.value | other.value);
  }

  bool toBool() {
    return this.value != 0;
  }
}

class MQTT {
  static MqttClient client =
      MqttClient.withPort(kMQTTServer, kMqttId, kMQTTPort);
  static ConnectionState connectionState = ConnectionState.Disconnected;
}
