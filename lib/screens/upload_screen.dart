import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ewaste_manager/services/firebase_storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      Fluttertoast.showToast(msg: "Please select an image to upload");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final storageService = Provider.of<FirebaseStorageService>(context, listen: false);
      String imageUrl = await storageService.uploadImage(_image!);
      Fluttertoast.showToast(msg: "Upload successful");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(imageUrl: imageUrl)),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Upload failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload E-Waste Image'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _image == null
                        ? const Icon(Icons.image_not_supported, size: 100, color: Colors.grey)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_image!, height: 200),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.image, color: Colors.white),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.camera, color: Colors.white),
                          label: const Text('Camera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Reset Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _resetImage,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: _isLoading
                  ? const SizedBox.shrink()
                  : const Icon(Icons.cloud_upload, color: Colors.white),
              label: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Upload Image', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: _isLoading ? null : _uploadImage,
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String imageUrl;

  const ResultScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Result'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                const Text('Image Uploaded Successfully!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageUrl),
                ),
                const SizedBox(height: 20),
                const Text('Recycling Instructions will be displayed here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}