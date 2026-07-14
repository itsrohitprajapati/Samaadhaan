import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class VideoComplaintScreen extends StatefulWidget {
  @override
  _VideoComplaintScreenState createState() => _VideoComplaintScreenState();
}

class _VideoComplaintScreenState extends State<VideoComplaintScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      await _controller.startVideoRecording();
    } else {
      await _controller.stopVideoRecording();
    }

    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Complaint'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CameraPreview(_controller),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
