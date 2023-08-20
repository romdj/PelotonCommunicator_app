import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:peloton_communicator/classes/device_information.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final logger = Logger();

class MqttManager {
  late MqttServerClient client;

  Future<void> connectToAwsIotCore() async {
    String awsIotEndpoint = dotenv.env['AWS_IOT_ENDPOINT']!;

    const int awsIotPort = 8883;

    const identifier = 'flutter_client';

    client = MqttServerClient.withPort(awsIotEndpoint, identifier, awsIotPort);
    client.logging(on: false);

    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFail;
    client.pongCallback = _pong;

    final connMessage =
        MqttConnectMessage().withClientIdentifier(identifier).startClean();
    client.connectionMessage = connMessage;

    publishNotificationToTopic("device ${getAppDeviceId()} connected");

    try {
      final securityContext = await loadSecurityContext();
      client.securityContext = securityContext;
    } catch (e) {
      logger.i('Exception: $e');
      client.disconnect();
    }
    try {
      await client.connect();
    } catch (e) {
      logger.i('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      logger.i('AWS IoT Core connected');
    } else {
      logger.i('ERROR: AWS IoT Core not connected');
    }
  }

  void _onConnected() {
    publishNotificationToTopic("device ${getAppDeviceId()} connected");
    logger.i('Connected');
  }

  void _onDisconnected() {
    publishNotificationToTopic("device ${getAppDeviceId()} disconnected");
    logger.i('Disconnected');
  }

  void _onSubscribed(String topic) {
    publishNotificationToTopic(
        "device ${getAppDeviceId()} subscribed to $topic");
    logger.i('Subscribed topic: $topic');
  }

  void _onSubscribeFail(String topic) {
    publishNotificationToTopic(
        "device ${getAppDeviceId()} failed to subscribe to $topic");
    logger.i('Failed to subscribe $topic');
  }

  void _pong() {
    logger.i('Ping response client callback invoked');
  }

  // Method to publish a file to a topic
  Future<void> publishFileToTopic(String filePath /* , String topic */) async {
    const topic = 'test_topic/peloton_communicator/file';
    final fileBytes = await File(filePath).readAsBytes();
    Uint8Buffer dataBuffer = Uint8Buffer();
    dataBuffer.addAll(fileBytes);
    int returnValue =
        client.publishMessage(topic, MqttQos.atLeastOnce, dataBuffer);
    logger.i('Published message from $filePath with return value $returnValue');
    MqttClientPayloadBuilder().clear();
  }

  // Method to publish a buffer to a topic
  Future<void> publishBufferToTopic(
      Uint8Buffer buffer /* , String topic */) async {
    const topic = 'test_topic/peloton_communicator/buffer';
    int returnValue = client.publishMessage(topic, MqttQos.atLeastOnce, buffer);
    logger.i('Published message from buffer with return value $returnValue');
    MqttClientPayloadBuilder().clear();
  }

  // Method to publish a JSON string to a topic
  Future<void> publishJsonToTopic(
      String jsonString /* , String topic */) async {
    const topic = 'test_topic/peloton_communicator/text';
    final message = MqttClientPayloadBuilder();
    message.addString(jsonString);
    int returnValue =
        client.publishMessage(topic, MqttQos.atLeastOnce, message.payload!);
    logger.i('Published message ($jsonString) with return value $returnValue');
    // await client.publishMessage(topic, MqttQos.atLeastOnce, message.payload!);
    MqttClientPayloadBuilder().clear();
  }

  Future<void> publishNotificationToTopic(
      String text /* , String topic */) async {
    const topic = 'test_topic/peloton_communicator/notification';
    final message = MqttClientPayloadBuilder();

    message.addString('{"message":"$text"}');
    int returnValue =
        client.publishMessage(topic, MqttQos.atLeastOnce, message.payload!);
    logger.i('Published message ($text) with return value $returnValue');
    // await client.publishMessage(topic, MqttQos.atLeastOnce, message.payload!);
    MqttClientPayloadBuilder().clear();
  }

  Future<SecurityContext> loadSecurityContext() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final path = appDocumentsDirectory.path;

    final certificatePath = dotenv.env['CERTIFICATE_PATH']!;
    final privateKeyFileName = dotenv.env['PRIVATE_KEY']!;
    SecurityContext securityContext = SecurityContext.defaultContext;

    try {
      final certificateContent =
          await rootBundle.loadString('assets/certificates/$certificatePath');
      final privateKeyContent = await rootBundle
          .loadString('assets/certificates/$privateKeyFileName');
      securityContext
          .setTrustedCertificatesBytes(utf8.encode(certificateContent));
      securityContext.usePrivateKeyBytes(utf8.encode(privateKeyContent));
    } catch (e) {
      throw Exception('Certificate could not be loaded. Reason: $e');
    }
    return securityContext;
  }
}
