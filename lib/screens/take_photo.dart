import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  static const routeName = '/take_picture';

  const CameraScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.ultraHigh);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a photo!'),
      ),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Center(
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              child: Center(child: Text('Hello')),
              width: 100.0,
              height: 100.0,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            List<String> paths = new List<String>();

            for (int i = 0; i < 20; i++) {
              // Construct the path where the image should be saved using the
              // pattern package.
              final path = join(
                // Store the picture in the temp directory.
                // Find the temp directory using the `path_provider` plugin.
                (await getTemporaryDirectory()).path,
                //'${DateTime.now()}.png',
                '${DateTime.now()},($i)',
              );
              print(path);

              // Attempt to take a picture and log where it's been saved.
              await _controller.takePicture(path);

              paths.add(path);
            }

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: paths),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final List<String> imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(imagePath.length, (index) {
        return Center(
          child: Image.file(File(imagePath.elementAt(index))),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: _buildGrid(),
      ),
    );
  }
}
