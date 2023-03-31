import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final logger = Logger();

class MqttManager {
  late MqttServerClient client;

  Future<void> connectToAwsIotCore() async {
    String awsIotEndpoint = dotenv.env['AWS_IOT_ENDPOINT']!;
    String certificatePath = dotenv.env['CERTIFICATE_PATH']!;
    String privateKeyFileName = dotenv.env['PRIVATE_KEY']!;

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
    logger.i('Connected');
  }

  void _onDisconnected() {
    logger.i('Disconnected');
  }

  void _onSubscribed(String topic) {
    logger.i('Subscribed topic: $topic');
  }

  void _onSubscribeFail(String topic) {
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
    message.addString(text);
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

    final securityContext = SecurityContext.defaultContext;

    final certificateFile = File('$path/$certificatePath');
    logger.d(
        '$path/$certificatePath certificateFile: ${certificateFile.existsSync()}');
    final certificateFile2 = File(certificatePath);
    logger.d(
        '$certificatePath certificateFile2: ${certificateFile2.existsSync()}');
    final certificateFile3 = File('$path/Documents/$certificatePath');
    logger.d(
        '$path/Documents/$certificatePath certificateFile3: ${certificateFile3.existsSync()}');
    final certificateFile4 = File('Documents/$certificatePath');
    logger.d(
        'Documents/$certificatePath certificateFile4: ${certificateFile4.existsSync()}');
    final certificateFile5 =
        File('$path/flutter_assets/certificates/$certificatePath');
    logger.d(
        '$path/flutter_assets/certificates/$certificatePath certificateFile5: ${certificateFile5.existsSync()}');
    final certificateFile6 =
        File('flutter_assets/certificates/$certificatePath');
    logger.d(
        'flutter_assets/certificates/$certificatePath certificateFile6: ${certificateFile6.existsSync()}');
    final certificateFile7 =
        File('/flutter_assets/certificates/$certificatePath');
    logger.d(
        '/flutter_assets/certificates/$certificatePath certificateFile7: ${certificateFile7.existsSync()}');
    final certificateFile8 =
        File('flutter_assets/assets/certificates/$certificatePath');
    logger.d(
        'flutter_assets/certificates/$certificatePath certificateFile8: ${certificateFile8.existsSync()}');
    final certificateFile9 =
        File('/flutter_assets/assets/certificates/$certificatePath');
    logger.d(
        '/flutter_assets/assets/certificates/$certificatePath certificateFile9: ${certificateFile9.existsSync()}');
    final certificateFile10 =
        File('$path/flutter_assets/assets/certificates/$certificatePath');
    logger.d(
        '$path/flutter_assets/assets/certificates/$certificatePath certificateFile10: ${certificateFile10.existsSync()}');

    if (certificateFile.existsSync()) {
      securityContext.setTrustedCertificates('$path/$certificatePath');
    } else {
      throw Exception('Certificate file not found');
    }

    final privateKeyFile = File('$path/$privateKeyFileName');
    if (privateKeyFile.existsSync()) {
      securityContext.usePrivateKey('$path/$privateKeyFileName');
      // securityContext.usePrivateKey('$path/$privateKeyFileName');
    } else {
      throw Exception('Private key file not found');
    }

    return securityContext;
  }
/* 
  Future<String> loadSecurityContextFile(String envVariable, String certificatePath) async {
    // final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    // final path = appDocumentsDirectory.path;

    final certificatePath = dotenv.env[envVariable]!;

    final certificateFile = File(certificatePath);
    if (certificateFile.existsSync()) {
      securityContext.setTrustedCertificates('$path/$certificatePath');
    } else {
      throw Exception('Certificate file not found');
    }

    final privateKeyFile = File('$path/$privateKeyFileName');
    if (privateKeyFile.existsSync()) {
      securityContext.usePrivateKey('$path/$privateKeyFileName');
    } else {
      throw Exception('Private key file not found');
    }

    return securityContext;
  } */
}
