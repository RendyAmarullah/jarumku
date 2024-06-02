import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_jarum/models/jarum.dart';
import 'package:project_jarum/service/location_service.dart';
import 'package:project_jarum/service/service_screen.dart';


class EditScreen extends StatefulWidget {
  final Jarum? jarum;


  const EditScreen({super.key, this.jarum});


  @override
  State<EditScreen> createState() => _EditScreenState();
}


class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double? _latitude;
  double? _longitude;
  XFile? _imageFile;
  Position? _currentPosition;


  @override
  void initState() {
    super.initState();
    if (widget.jarum != null) {
      _titleController.text = widget.jarum!.title;
      _descriptionController.text = widget.jarum!.description;
      _latitude = widget.jarum?.latitude;
      _longitude = widget.jarum?.longitude;
    }
  }


  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);


    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }


  Future<void> _pickLocation() async {
    final currentPosition = await LocationService.getCurrentPosition();
    setState(() {
      _currentPosition = currentPosition;
      _latitude = currentPosition?.latitude;
      _longitude = currentPosition?.longitude;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jarum == null ? 'Add Notes' : 'Update Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title: ',
                textAlign: TextAlign.start,
              ),
              TextField(
                controller: _titleController,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Description: ',
                ),
              ),
              TextField(
                controller: _descriptionController,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Image: '),
              ),
              _imageFile != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: kIsWeb
                          ? CachedNetworkImage(
                              imageUrl: _imageFile!.path,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                            )
                          : Image.file(File(_imageFile!.path),
                              fit: BoxFit.cover,),
                    )
                  : (widget.jarum?.imageUrl != null &&
                          Uri.parse(widget.jarum!.imageUrl!).isAbsolute
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: widget.jarum!.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        )
                      : Container()),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              TextButton(
                onPressed: _pickLocation,
                child: const Text('Get Current Location'),
              ),
              Text(
                'Current Position: ${_latitude != null && _longitude != null ? '$_latitude, $_longitude' : 'Belum ada data lokasi'}',
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? imageUrl;
                      if (_imageFile != null) {
                        imageUrl = await Service.uploadImage(_imageFile!);
                      } else {
                        imageUrl = widget.jarum?.imageUrl;
                      }
                      Jarum jarum = Jarum(
                        id: widget.jarum?.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        imageUrl: imageUrl,
                        latitude: _latitude,
                        longitude: _longitude,
                        createdAt: widget.jarum?.createdAt,
                      );


                      if (widget.jarum == null) {
                        Service.addNote(jarum)
                            .whenComplete(() => Navigator.of(context).pop());
                      } else {
                        Service.updateNote(jarum)
                            .whenComplete(() => Navigator.of(context).pop());
                      }
                    },
                    child: Text(widget.jarum == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
