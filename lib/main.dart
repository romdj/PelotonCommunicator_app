import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/long_press_button.dart';
import 'package:peloton_communicator/permissions/microphone_permission_handler.dart';

var packageInfo;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Flutter is properly initialized before running any asynchronous code
  MicrophonePermissionHandler microphonePermissionHandler =
      MicrophonePermissionHandler();

  await microphonePermissionHandler.requestPermission();

  packageInfo = await PackageInfo.fromPlatform();
  await dotenv.load(fileName: '.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            AudioRecording audioRecording = AudioRecording();
            audioRecording
                .init(); // Call the init method after instantiating AudioRecording
            return audioRecording;
          },
        ),
      ],
      child: PelotonCommunicator(),
    ),
  );
}

class PelotonCommunicator extends StatelessWidget {
  const PelotonCommunicator({super.key});
  @override
  Widget build(BuildContext context) {
    String appHeaderTitle =
        'Peloton Communicator - ${packageInfo?.version ?? 'no version found yet'}';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(appHeaderTitle)),
        body: Center(
          child: Consumer<AudioRecording>(
            builder: (context, audioModel, child) =>
                LongPressButton(audioModel: audioModel),
          ),
        ),
      ),
    );
  }
}
