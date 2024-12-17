import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageWidget extends StatefulWidget {
  @override
  _UploadImageWidgetState createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  bool hasPicked = false;
  XFile? selectedImage;

  // Function to pick the image from a source
  void pickImage({required ImageSource source, required BuildContext context}) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
      source: source,
    );
    if (image != null) {
      setState(() {
        hasPicked = true;
      });
    }
    setState(() => selectedImage = image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidget("Upload a picture of the receipt/servicing card."),
        SizedBox(height: 5.0),
        GestureDetector(
          onTap: () => pickImage(source: ImageSource.gallery, context: context),
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
            ),
            child: Center(
              child: hasPicked && selectedImage != null
                  ? Image.file(
                File(selectedImage!.path),
                fit: BoxFit.cover,
              )
                  : Text(
                "Upload file",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
